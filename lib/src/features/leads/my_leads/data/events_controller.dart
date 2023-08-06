import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/fake/data/providers.dart';
import '../../../../core/fake/repositories/fake_database_repository.dart';
import '../../../../core/fake/repositories/fake_realtime_repository.dart';
import '../../../../core/interfaces/repositories/database_repository.dart';
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

  // !: Fake Local Database
  final DatabaseRepository databaseRepository = ref.watch(
    fakeDatabaseRepositoryProvider,
  );
  // !: Fake Realtime database
  final jsonData = ref.watch(fakeDataFutureProvider);
  final RealtimeRepository realtimeRepository = ref.watch(
    fakeRealtimeRepositoryProvider(jsonData),
  );

  final qrScanController = ref.watch(qrScanControllerProvider);
  return EventsController(
    databaseRepository: databaseRepository,
    realtimeRepository: realtimeRepository,
    qrScanController: qrScanController,
  );
});

class EventsController extends StateNotifier<AsyncValue<List<Event>>> {
  EventsController({
    required DatabaseRepository databaseRepository,
    required RealtimeRepository realtimeRepository,
    required QrScanController qrScanController,
  })  : _databaseRepository = databaseRepository,
        _realtimeRepository = realtimeRepository,
        _qrScanController = qrScanController,
        super(const AsyncData([])) {
    _init();
  }

  final DatabaseRepository _databaseRepository;
  final RealtimeRepository _realtimeRepository;
  final QrScanController _qrScanController;

  Future<void> _init() async {
    await fetchEvents();
  }

  Future<bool> eventExists(String eventId) async {
    return await _realtimeRepository.eventExists(
      eventId,
    );
  }

  Future<void> fetchEvents() async {
    try {
      state = const AsyncValue.loading();

      // Fetch all event data from Realtime database
      Map<String, dynamic> eventsMap =
          await _realtimeRepository.fetchEventsData();

      // Extract out only the details of each event map
      List<Map<String, dynamic>> eventsDetailMap = _processEventsDataFromMap(
        eventsMap,
      );
      // Convert to model
      List<Event> fetchedEvents =
          eventsDetailMap.map((eventMap) => Event.fromMap(eventMap)).toList();

      // Merge saved and fetched lists and only keep unique Events where
      // the 'saved' property is equal to true
      final List<Event> savedEvents = await _fetchSavedEvents();
      final List<Event> events = _mergeAndKeepSaved(fetchedEvents, savedEvents);

      state = AsyncValue.data(events);
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Unexpected error while fetching events. Error: $exception",
      );
      state = AsyncValue.error(exception.toString(), stacktrace);
    }
  }

  List<Map<String, dynamic>> _processEventsDataFromMap(
    Map<String, dynamic> map,
  ) {
    return map
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
  }

  List<Event> _mergeAndKeepSaved(
    List<Event> fetchedEvents,
    List<Event> savedEvents,
  ) {
    // Concatenate both lists
    List<Event> concatenatedList = [...fetchedEvents, ...savedEvents];

    // Create a map to store each event by its id
    Map<String, Event> eventMap = {};

    for (final event in concatenatedList) {
      if (eventMap.containsKey(event.eventId)) {
        // If the map already contains an event with this id, keep the 'saved' one
        if (event.saved) {
          eventMap[event.eventId] = event;
        }
      } else {
        // If the map does not contain an event with this id, add it
        eventMap[event.eventId] = event;
      }
    }

    // Return the values of the map as a new list
    return eventMap.values.toList();
  }

  Future<List<Event>> _fetchSavedEvents() async {
    final List<Event> savedEvents = await _databaseRepository.fetchEvents();
    return savedEvents;
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

  Future<Map<String, dynamic>?> _fetchEventDataById(
    String eventId,
  ) async {
    Map<String, dynamic>? eventMap =
        await _realtimeRepository.fetchEventDataById(
      eventId,
    );
    return eventMap;
  }

  Future<RawExhibitorData?> _processMapIntoExhibitorData({
    required Map<String, dynamic> eventMap,
    required String exhibitorId,
    required String eventId,
  }) async {
    final Map<String, dynamic>? allUsersMap = _processAllUsersDataFromEventMap(
      eventMap: eventMap,
      userCategory: UserCategory.exhibitor,
    );

    if (allUsersMap == null) return null;

    Map<String, dynamic>? userMap = _processUserDataByIdFromUsersMap(
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

  Map<String, dynamic>? _processEventDetailsMap(
    Map<String, dynamic> eventMap,
  ) {
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

    final Map<String, dynamic>? eventMap = await _fetchEventDataById(eventId);

    if (eventMap == null) return;

    final RawExhibitorData? exhibitor = await _processMapIntoExhibitorData(
      eventMap: eventMap,
      exhibitorId: qrCode,
      eventId: eventId,
    );

    if (exhibitor == null) {
      debugPrint("❌ -> Exhibitor was null.");
      return;
    }

    // !: If we got this far the exhibitor was registered in Firebase
    final Map<String, dynamic>? eventDetailsMap =
        _processEventDetailsMap(eventMap);

    if (eventDetailsMap == null) return;

    final Event event = Event.fromMap(eventDetailsMap).copyWith(saved: true);
    _replaceOldEventWithUpdatedEvent(event);

    final bool hasSavedEvent = await _saveEventToDatabase(event);
    if (hasSavedEvent) {
      _replaceOldEventWithUpdatedEvent(event);
    }
  }

  Future<bool> _saveEventToDatabase(Event event) async {
    try {
      await _databaseRepository.saveEvent(event);
      return true;
    } catch (e) {
      debugPrint("❌ -> Failed to save Event to local database. Error: $e");
      return false;
    }
  }

  void _replaceOldEventWithUpdatedEvent(Event updatedEvent) {
    try {
      final currentEvents = (state.value ?? [])
          .map((oldEvent) => oldEvent == updatedEvent ? updatedEvent : oldEvent)
          .toList();

      state = AsyncValue.data(currentEvents);
    } catch (e) {
      debugPrint("❌ -> Failed to update saved event in UI. Error: $e");
    }
  }
}
