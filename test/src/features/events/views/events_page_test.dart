import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agi_events/src/core/constants/constants.dart';
import 'package:agi_events/src/infrastructure/database/repositories/isar_database_repository.dart';
import 'package:agi_events/src/infrastructure/firebase/repositories/firebase_realtime_repository.dart';
import 'package:agi_events/src/features/events/views/events_page.dart';
import '../../../../mocks/mocks.dart';

void main() {
  group("EventsPage tests", () {
    late MockDatabaseRepository mockDatabaseRepository;
    late MockRealtimeRepository mockRealtimeRepository;

    setUp(() {
      mockDatabaseRepository = MockDatabaseRepository();
      mockRealtimeRepository = MockRealtimeRepository();
    });

    Future<void> setUpEventsPage(WidgetTester tester) async {
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
          child: const MaterialApp(
            home: EventsPage(),
          ),
        ),
      );
    }

    testWidgets(
      "EventsPage should have the correct text in the title widget",
      (WidgetTester tester) async {
        // Arrange
        await setUpEventsPage(tester);

        // Act
        final title = find.text("Welcome to\n${AppConstants.appTitle}");

        // Assert
        expect(title, findsOneWidget);
      },
    );
  });
}
