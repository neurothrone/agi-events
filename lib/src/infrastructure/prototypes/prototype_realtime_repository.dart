import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/constants.dart';
import '../../core/interfaces/interfaces.dart';
import '../../core/models/models.dart';
import '../../core/utils/enums/enums.dart';
import '../../core/utils/utils.dart';

// region Providers

final prototypeRealtimeDataFutureProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final Map<String, dynamic> realtimeData = await loadJsonFromAssets(
    AssetsConstants.prototypeRealtimeJson,
  );
  return realtimeData;
});

final prototypeRealtimeRepositoryProvider = Provider.family<
    PrototypeRealtimeRepository,
    AsyncValue<Map<String, dynamic>>>((ref, jsonData) {
  // Check if data is available
  if (jsonData is AsyncData<Map<String, dynamic>>) {
    // Data is available
    return PrototypeRealtimeRepository(data: jsonData.value);
  } else {
    // Data is not yet available
    return const PrototypeRealtimeRepository(data: {});
  }
});

// endregion

class PrototypeRealtimeRepository implements RealtimeRepository {
  const PrototypeRealtimeRepository({
    required Map<String, dynamic> data,
  }) : _data = data;

  final Map<String, dynamic> _data;

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

  @override
  Future<RawVisitorData?> fetchVisitorById({
    required String visitorId,
    required Event event,
  }) async {
    final Map<String, dynamic>? eventMap = await _fetchEventDataById(
      event.eventId,
    );

    if (eventMap == null) return null;

    final RawVisitorData? visitor = _processMapIntoUserData(
      eventMap: eventMap,
      userId: visitorId,
      userCategory: UserCategory.visitor,
      factory: RawVisitorData.fromMap,
    );

    return visitor;
  }

  Future<Map<String, dynamic>?> _fetchEventDataById(String eventId) async {
    final eventIds = _data.keys.map((key) => key.toString()).toList();
    final doesEventExist = eventIds.contains(eventId);

    if (!doesEventExist) return null;

    final eventMap = _data[eventId] as Map<String, dynamic>;
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
