import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../interfaces/repositories/realtime_repository.dart';
import '../../models/models.dart';
import '../../utils/enums/enums.dart';

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
    final List<String> events = await fetchEventIds();
    return events.contains(eventId);
  }

  @override
  Future<Map<String, dynamic>> fetchEventsData() async {
    return Future.value(_data);
  }

  @override
  Future<List<String>> fetchEventIds() async {
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

  @override
  Future<RawExhibitorData?> fetchExhibitorById({
    required String exhibitorId,
    required Event event,
  }) async {
    final Map<String, dynamic>? eventMap = await _fetchEventDataById(
      event.eventId,
    );

    if (eventMap == null) return null;

    final RawExhibitorData? exhibitor = _processMapIntoUserData(
      eventMap: eventMap,
      userId: exhibitorId,
      userCategory: UserCategory.exhibitor,
      factory: RawExhibitorData.fromMap,
    );

    return exhibitor;
  }

  Future<Map<String, dynamic>?> _fetchEventDataById(
      String eventId,
      ) async {
    Map<String, dynamic>? eventMap =
    await fetchEventDataById(
      eventId,
    );
    return eventMap;
  }

  T? _processMapIntoUserData<T extends RawUserData>({
    required Map<String, dynamic> eventMap,
    required String userId,
    required UserCategory userCategory,
    required T Function(Map<String, dynamic>) factory,
  }) {
    final Map<String, dynamic>? allUsersMap = _processAllUsersDataFromEventMap(
      eventMap: eventMap,
      userCategory: userCategory,
    );

    if (allUsersMap == null) return null;

    Map<String, dynamic>? userMap = _processUserDataByIdFromUsersMap(
      allUsersMap,
      userId,
    );

    if (userMap == null) return null;

    try {
      final user = factory(userMap);
      return user;
    } catch (exception) {
      return null;
    }
  }

  Map<String, dynamic>? _processAllUsersDataFromEventMap({
    required Map<String, dynamic> eventMap,
    required UserCategory userCategory,
  }) {
    try {
      final Map<String, dynamic> allUsersData =
      (eventMap[userCategory.name] as Map)
          .map((key, value) => MapEntry(key.toString(), value));
      return allUsersData;
    } catch (exception) {
      return null;
    }
  }

  Map<String, dynamic>? _processUserDataByIdFromUsersMap(
      Map<String, dynamic> usersMap,
      String userId,
      ) {
    if (!usersMap.containsKey(userId)) return null;

    try {
      Map<String, dynamic> userData =
      usersMap[userId]["data"] as Map<String, dynamic>;
      return userData;
    } catch (exception) {
      return null;
    }
  }
}
