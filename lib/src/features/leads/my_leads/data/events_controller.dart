import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/firebase/repositories/firebase_realtime_repository.dart';
import '../../../../core/interfaces/repositories/fake_realtime_repository.dart';
import '../../../../core/interfaces/repositories/realtime_repository.dart';

final eventsControllerProvider =
    StateNotifierProvider<EventsController, AsyncValue<List<String>>>((ref) {
  // final RealtimeRepository realtimeRepository = ref.watch(
  //   firebaseRealtimeRepositoryProvider,
  // );

  final RealtimeRepository realtimeRepository = ref.watch(
    fakeRealtimeRepositoryProvider,
  );

  return EventsController(realtimeRepository: realtimeRepository);
});

class EventsController extends StateNotifier<AsyncValue<List<String>>> {
  EventsController({
    required RealtimeRepository realtimeRepository,
  })  : _realtimeRepository = realtimeRepository,
        super(const AsyncData([])) {
    _init();
  }

  final RealtimeRepository _realtimeRepository;

  Future<void> _init() async {
    await fetchEvents();
  }

  Future<void> eventExists(String eventId) async {
    final bool eventExists = await _realtimeRepository.eventExists(
      eventId,
    );
    debugPrint("ℹ️ -> Event [$eventId] exists: $eventExists");
  }

  Future<void> fetchEvents() async {
    try {
      state = const AsyncValue.loading();

      List<String> events = await _realtimeRepository.fetchEvents();

      state = AsyncValue.data(events);
      debugPrint("ℹ️ -> Events: $events");
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Unexpected error while fetching events. Error: $exception",
      );
      state = AsyncValue.error(exception.toString(), stacktrace);
    }
  }

  Future<void> fetchEventDataById(String eventId) async {
    Map<String, dynamic>? map = await _realtimeRepository.fetchEventDataById(
      eventId,
    );

    if (map != null) {
      debugPrint("✅ -> Event [$eventId]: $map");
      // _parseMap(map, "exhibitor");
    } else {
      debugPrint("❌ -> No event data.");
    }
  }

  void _parseMap(Map<String, dynamic> map, String category) {
    try {
      List<Map<String, dynamic>> dataList = (map[category] as Map)
          .map(
            (key, value) => MapEntry(key.toString(), value),
          )
          .values
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (value) => (value["data"] as Map).map(
              (key, value) => MapEntry(key.toString(), value),
            ),
          )
          .toList();

      debugPrint("ℹ️ -> Length: ${dataList.length}");
    } catch (exception, stacktrace) {
      debugPrint("❌ -> Failed to parse map. Exception: $exception");
    }
  }
}
