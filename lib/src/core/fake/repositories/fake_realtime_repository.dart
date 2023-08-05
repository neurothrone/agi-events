import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../interfaces/repositories/realtime_repository.dart';

final fakeRealtimeRepositoryProvider =
    Provider.family<FakeRealtimeRepository, AsyncValue<Map<String, dynamic>>>(
        (ref, jsonData) {
  // Check if data is available
  if (jsonData is AsyncData<Map<String, dynamic>>) {
    // Data is available
    return FakeRealtimeRepository(data: jsonData.value);
  } else {
    // Data is not yet available
    return const FakeRealtimeRepository(data: {});
  }
});

class FakeRealtimeRepository implements RealtimeRepository {
  const FakeRealtimeRepository({
    required Map<String, dynamic> data,
  }) : _data = data;

  final Map<String, dynamic> _data;

  @override
  Future<bool> eventExists(String eventId) async {
    final List<String> events = await fetchEvents();
    return events.contains(eventId);
  }

  @override
  Future<List<String>> fetchEvents() async {
    return Future.value(_data.keys.map((key) => key.toString()).toList());
  }

  @override
  Future<Map<String, dynamic>?> fetchEventDataById(String eventId) async {
    final doesEventExist = await eventExists(eventId);
    if (!doesEventExist) return null;

    final Map<String, dynamic> eventData =
        _data[eventId] as Map<String, dynamic>;
    return eventData;
  }
}
