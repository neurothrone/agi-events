import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/fake/data/providers.dart';
import '../../../../core/fake/repositories/fake_realtime_repository.dart';
import '../../../../core/interfaces/repositories/realtime_repository.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../qr_scan/data/qr_scan_controller.dart';

final eventsControllerProvider =
    StateNotifierProvider<EventsController, AsyncValue<List<Event>>>((ref) {
  // !: Firebase Realtime database
  // final RealtimeRepository realtimeRepository = ref.watch(
  //   firebaseRealtimeRepositoryProvider,
  // );

  // !: Fake Realtime database
  final jsonData = ref.watch(fakeDataFutureProvider);
  final RealtimeRepository realtimeRepository = ref.watch(
    fakeRealtimeRepositoryProvider(jsonData),
  );

  final qrScanController = ref.watch(qrScanControllerProvider);
  return EventsController(
    realtimeRepository: realtimeRepository,
    qrScanController: qrScanController,
  );
});

class EventsController extends StateNotifier<AsyncValue<List<Event>>> {
  EventsController({
    required RealtimeRepository realtimeRepository,
    required QrScanController qrScanController,
  })  : _realtimeRepository = realtimeRepository,
        _qrScanController = qrScanController,
        super(const AsyncData([])) {
    _init();
  }

  final RealtimeRepository _realtimeRepository;
  final QrScanController _qrScanController;

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

      Map<String, dynamic> eventsMap =
          await _realtimeRepository.fetchEventsData();

      List<Map<String, dynamic>> eventsDetailMap = eventsMap
          .map(
            (key, value) => MapEntry(key.toString(), value),
          )
          .values
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (value) => (value["event"] as Map).map(
              (key, value) => MapEntry(key.toString(), value),
            ),
          )
          .toList();

      List<Event> events = eventsDetailMap
          .map(
            (eventMap) => Event.fromMap(eventMap),
          )
          .toList();

      debugPrint("ℹ️ -> events: $events");

      state = AsyncValue.data(events);
      // debugPrint("ℹ️ -> Events: $events");
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Unexpected error while fetching events. Error: $exception",
      );
      state = AsyncValue.error(exception.toString(), stacktrace);
    }
  }

  // Future<void> fetchEvents() async {
  //   try {
  //     state = const AsyncValue.loading();
  //
  //     List<String> events = await _realtimeRepository.fetchEventIds();
  //
  //     state = AsyncValue.data(events);
  //     debugPrint("ℹ️ -> Events: $events");
  //   } catch (exception, stacktrace) {
  //     debugPrint(
  //       "❌ -> Unexpected error while fetching events. Error: $exception",
  //     );
  //     state = AsyncValue.error(exception.toString(), stacktrace);
  //   }
  // }

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
    } catch (exception) {
      debugPrint("❌ -> Failed to parse map. Exception: $exception");
    }
  }

  // Future<void> fetchExhibitorById({
  //   required String exhibitorId,
  //   required String eventId,
  // }) async {
  //   Map<String, dynamic>? map = await _realtimeRepository.fetchEventDataById(
  //     eventId,
  //   );
  //
  //   if (map != null) {
  //     // debugPrint("✅ -> Event [$eventId]: $map");
  //     final List<Map<String, dynamic>>? allExhibitorsData = _parseEventMap(
  //       map: map,
  //       userCategory: UserCategory.exhibitor,
  //       userId: exhibitorId,
  //     );
  //
  //     if (allExhibitorsData != null) {
  //       debugPrint("✅ -> All ExhibitorsData: $allExhibitorsData");
  //     }
  //   } else {
  //     debugPrint("❌ -> No event data.");
  //   }
  // }

  // List<Map<String, dynamic>>? _parseEventMap({
  //   required Map<String, dynamic> map,
  //   required UserCategory userCategory,
  //   required String userId,
  // }) {
  //   try {
  //     final Map<String, dynamic> allUsersData = (map[userCategory.name] as Map)
  //         .map((key, value) => MapEntry(key.toString(), value));
  //     debugPrint("ℹ️ -> userId: $userId");
  //     debugPrint("ℹ️ -> all usersData Length: ${allUsersData.length}");
  //     // debugPrint("ℹ️ -> all usersData: $allUsersData");
  //
  //     if (allUsersData.containsKey(userId)) {
  //       debugPrint("✅ -> FOUND userId [$userId]");
  //       Map<String, dynamic> userData =
  //           allUsersData[userId]["data"] as Map<String, dynamic>;
  //       debugPrint("✅ -> userData $userData");
  //
  //       final exhibitor = RawExhibitorData.fromMap(userData);
  //       debugPrint("✅ -> exhibitor $exhibitor");
  //     }
  //
  //     return null;
  //   } catch (exception) {
  //     debugPrint("❌ -> Failed to parse map. Exception: $exception");
  //     return null;
  //   }
  // }

  Map<String, dynamic>? getAllUsersDataFromEventMap(
    Map<String, dynamic> eventMap,
    UserCategory userCategory,
  ) {
    try {
      final Map<String, dynamic> allUsersData =
          (eventMap[userCategory.name] as Map)
              .map((key, value) => MapEntry(key.toString(), value));
      return allUsersData;
    } catch (exception) {
      return null;
    }
  }

  Map<String, dynamic>? getUserDataByIdFromUsersMap(
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

  Future<Map<String, dynamic>?> getEventDataById(
    String eventId,
  ) async {
    Map<String, dynamic>? eventMap =
        await _realtimeRepository.fetchEventDataById(
      eventId,
    );
    return eventMap;
  }

  Future<RawExhibitorData?> getExhibitorData({
    required Map<String, dynamic> eventMap,
    required String exhibitorId,
    required String eventId,
  }) async {
    final Map<String, dynamic>? allUsersMap = getAllUsersDataFromEventMap(
      eventMap,
      UserCategory.exhibitor,
    );

    if (allUsersMap == null) return null;

    Map<String, dynamic>? userMap = getUserDataByIdFromUsersMap(
      allUsersMap,
      exhibitorId,
    );

    if (userMap == null) return null;

    try {
      final exhibitor = RawExhibitorData.fromMap(userMap);
      return exhibitor;
    } catch (exception) {
      return null;
    }
  }

  Map<String, dynamic>? getEventDetailsMap(Map<String, dynamic> eventMap) {
    try {
      final eventDetailsMap = eventMap["event"] as Map<String, dynamic>;
      return eventDetailsMap;
    } catch (e) {
      debugPrint("❌ -> Event Map did not have details. Error: $e.");
      return null;
    }
  }

  Future<void> openQrScanner({
    required String eventId,
    required BuildContext context,
  }) async {
    final String? qrCode = await _qrScanController.showQrScanner(
      scanType: ScanType.exhibitor,
      context: context,
    );

    // TODO: show invalid qr code error or camera not available in qr view
    if (qrCode == null) return;

    final Map<String, dynamic>? eventMap = await getEventDataById(eventId);

    if (eventMap == null) return;

    final RawExhibitorData? exhibitor = await getExhibitorData(
      eventMap: eventMap,
      exhibitorId: qrCode,
      eventId: eventId,
    );

    if (exhibitor == null) {
      debugPrint("❌ -> Exhibitor was null.");
      return;
    }

    // !: If we got this far the exhibitor was registered in Firebase
    debugPrint("✅ -> Exhibitor: $exhibitor");

    final Map<String, dynamic>? eventDetailsMap = getEventDetailsMap(eventMap);

    if (eventDetailsMap == null) return;

    debugPrint("✅ -> Event details: $eventDetailsMap");

    // TODO: if we get this far, create event with event id
    // TODO: get image from firebase storage
    // TODO: get title and subtitle from firebase database
    // TODO: add event to "Your Events" and remove existing event from "Coming Events"

    // TODO: Check if eventId is not in "Your Events"
    // TODO: If not => Show QR Scanner with ScanType.exhibitor
    // TODO get QR code
    // TODO: if valid, add event to "Your Events" and local database
  }
}
