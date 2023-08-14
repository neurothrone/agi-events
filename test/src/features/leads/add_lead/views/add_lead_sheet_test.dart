import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agi_events/src/core/models/models.dart';
import 'package:agi_events/src/core/widgets/primary_button.dart';
import 'package:agi_events/src/features/leads/add_lead/widgets/add_lead_form.dart';
import 'package:agi_events/src/features/leads/add_lead/views/add_lead_sheet.dart';
import 'package:agi_events/src/infrastructure/database/repositories/isar_database_repository.dart';
import 'package:agi_events/src/infrastructure/firebase/repositories/firebase_realtime_repository.dart';
import '../../../../../mocks/mocks.dart';

void main() {
  group("AddLeadSheet tests", () {
    late MockDatabaseRepository mockDatabaseRepository;
    late MockRealtimeRepository mockRealtimeRepository;
    late MockLeadsController mockLeadsController;
    late Event event;

    setUp(() {
      mockDatabaseRepository = MockDatabaseRepository();
      mockRealtimeRepository = MockRealtimeRepository();
      mockLeadsController = MockLeadsController();

      event = Event(
        eventId: "eventId",
        title: "Random event",
        image: "image",
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 3)),
        saved: true,
      );
    });

    Future<void> setUpAddLeadSheet(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarDatabaseRepositoryProvider.overrideWithValue(
              mockDatabaseRepository,
            ),
            firebaseRealtimeRepositoryProvider.overrideWithValue(
              mockRealtimeRepository,
            ),
          ],
          child: MaterialApp(
            home: AddLeadSheet(event: event),
          ),
        ),
      );
    }

    testWidgets(
      "AddLeadPage should have the correct text in the title widget",
      (WidgetTester tester) async {
        // Arrange
        await setUpAddLeadSheet(tester);
        // Act
        final title = find.text("New lead");
        // Assert
        expect(title, findsOneWidget);
      },
    );

    testWidgets(
      "All TextFormFields are rendered",
      (WidgetTester tester) async {
        // Arrange
        await setUpAddLeadSheet(tester);
        // Act
        final results = find.byType(TextFormField);
        // Assert
        expect(results, findsNWidgets(10));
      },
    );

    testWidgets(
      "Next button is rendered",
      (WidgetTester tester) async {
        // Arrange
        await setUpAddLeadSheet(tester);
        // Act
        final nextButton = find.byType(PrimaryButton);
        // Assert
        expect(nextButton, findsOneWidget);
      },
    );

    testWidgets(
      "Next button is disabled when required fields are empty",
      (tester) async {
        // Arrange
        await setUpAddLeadSheet(tester);
        // Act
        final nextButton =
            find.byType(PrimaryButton).evaluate().first.widget as PrimaryButton;
        // Assert
        expect(nextButton.onPressed, isNull);
      },
    );

    testWidgets(
      "Next button is enabled when all required fields are filled",
      (tester) async {
        // Arrange
        await setUpAddLeadSheet(tester);

        final firstNameField = find.byKey(const Key("firstNameField"));
        final lastNameField = find.byKey(const Key("lastNameField"));
        final companyField = find.byKey(const Key("companyField"));
        final emailField = find.byKey(const Key("emailField"));

        // Act
        await tester.enterText(firstNameField, "John");
        await tester.enterText(lastNameField, "Doe");
        await tester.enterText(companyField, "Doe Industries");
        await tester.enterText(emailField, "john.doe@example.com");

        // Let any potential state changes finish
        await tester.pumpAndSettle();

        final primaryButtonFinder = find.byType(PrimaryButton);
        if (primaryButtonFinder.evaluate().isEmpty) {
          fail("Expected to find a PrimaryButton, but found none.");
        }
        final nextButton =
            primaryButtonFinder.first.evaluate().first.widget as PrimaryButton;

        // Assert
        expect(nextButton.onPressed, isNotNull);
      },
    );

    testWidgets(
      "Pressing next on First Name field allows input in Last Name field",
      (tester) async {
        // Arrange
        await setUpAddLeadSheet(tester);

        final firstNameField = find.byKey(const Key("firstNameField"));
        final lastNameField = find.byKey(const Key("lastNameField"));

        // Act
        await tester.tap(firstNameField);
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.enterText(lastNameField, "Doe");

        // Assert
        expect(find.text("Doe"), findsOneWidget);
      },
    );

    testWidgets(
      "Pressing done on the Last Field removes focus (dismisses keyboard)",
      (tester) async {
        // Arrange
        final originalSize = tester.binding.createViewConfiguration().size;
        addTearDown(() async {
          await tester.binding.setSurfaceSize(originalSize);
        });

        await tester.binding.setSurfaceSize(const Size(800, 1600));
        await setUpAddLeadSheet(tester);

        final sellerField = find.byKey(const Key("sellerField"));

        final scrollable = find.byType(ListView);
        await tester.dragUntilVisible(
          scrollable,
          sellerField,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        // Act
        await tester.tap(sellerField);
        await tester.testTextInput.receiveAction(TextInputAction.done);

        // Assert
        final currentFocus = FocusScope.of(
          tester.element(
            find.byType(AddLeadForm),
          ),
        ).focusedChild;
        expect(currentFocus, isNull);
      },
    );
  });
}
