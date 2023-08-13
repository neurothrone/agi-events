import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agi_events/src/infrastructure/mocks/mock_realtime_repository.dart';
import 'package:agi_events/src/core/models/models.dart';
import 'package:agi_events/src/core/utils/utils.dart';

void main() {
  group(
    "MockRealtimeRepository Providers",
    () {
      late ProviderContainer container;

      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        container = ProviderContainer();
      });

      tearDown(() {
        container.dispose();
      });

      test(
        "mockRealtimeDataFutureProvider returns the expected data",
        () async {
          // Arrange
          // [container] -> handled by setUp()

          // A Completer is used to detect when the Future completes
          final completer = Completer<void>();

          // Act
          // Inside the microtask, we read from the provider and
          // complete the completer.
          Future.microtask(() {
            container.read(mockRealtimeDataFutureProvider);
            completer.complete();
          });

          // Wait for the Future to complete
          await completer.future;

          // Assert
          // At this point, the data should be loaded
          final providerResult = container.read(
            mockRealtimeDataFutureProvider,
          );
          final loadedData = providerResult.maybeWhen(
            data: (Map<String, dynamic> data) => data,
            orElse: () => null,
          );
          expect(loadedData, isNotNull);

          container.dispose();
        },
      );

      test(
        "mockRealtimeRepositoryProvider returns the expected repository",
        () async {
          // Assert
          // [container] -> handled by setUp()
          final loadedData = await container.read(
            mockRealtimeDataFutureProvider.future,
          );

          // Act
          final repository = container.read(
            mockRealtimeRepositoryProvider(AsyncValue.data(loadedData)),
          );

          // Assert
          expect(repository, isA<MockRealtimeRepository>());
        },
      );
    },
  );

  group("MockRealtimeRepository", () {
    late MockRealtimeRepository repository;
    late Map<String, dynamic> mockData;

    late Event event;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      mockData = await loadJsonFromAssets(
        "assets/data/mock-realtime-data.json",
      );
      repository = MockRealtimeRepository(data: mockData);

      event = Event(
        eventId: "sopno398628",
        title: "Random event",
        image: "image",
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 3)),
        saved: true,
      );
    });

    test(
      "fetchExhibitorById returns correct exhibitor data",
      () async {
        // Arrange
        // [event] -> handled by setUp()
        const exhibitorId = "00103eb2bc20ca78bf7234c65041373c92c40560";
        const exhibitorEmail = "morten.harte@ricoh.no";

        // Act
        final exhibitor = await repository.fetchExhibitorById(
          exhibitorId: exhibitorId,
          event: event,
        );

        // Assert
        expect(exhibitor?.email, exhibitorEmail);
      },
    );

    test(
      "fetchVisitorById returns correct visitor data",
      () async {
        // Arrange
        // [event] -> handled by setUp()
        const visitorId = "01671e138a62787f8ce141f3d161ff6ea4338a6e";
        const visitorEmail = "nicolae@expon.no";

        // Act
        final visitor = await repository.fetchVisitorById(
          visitorId: visitorId,
          event: event,
        );

        // Assert
        expect(visitor?.email, visitorEmail);
      },
    );

    test(
      "fetchExhibitorById returns null for non-existent exhibitor",
      () async {
        // Arrange
        // [event] -> handled by setUp()

        // Act
        final exhibitor = await repository.fetchExhibitorById(
          exhibitorId: "nonExistentExhibitorId",
          event: event,
        );

        // Assert
        expect(exhibitor, isNull);
      },
    );

    test(
      "fetchVisitorById returns null for non-existent visitor",
      () async {
        // Arrange
        // [event] -> handled by setUp()

        // Act
        final visitor = await repository.fetchVisitorById(
          visitorId: "nonExistentVisitorId",
          event: event,
        );

        // Assert
        expect(visitor, isNull);
      },
    );
  });
}
