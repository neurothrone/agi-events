import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/fake/data/providers.dart';
import '../../../core/fake/repositories/fake_database_repository.dart';
import '../../../core/fake/repositories/fake_realtime_repository.dart';
import '../../../core/interfaces/repositories/database_repository.dart';
import '../../../core/interfaces/repositories/realtime_repository.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/enums/enums.dart';
import 'providers.dart';

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
  final AsyncValue<Map<String, dynamic>> fakeRealtimeData = ref.watch(
    fakeRealtimeDataFutureProvider,
  );
  final RealtimeRepository realtimeRepository = ref.watch(
    fakeRealtimeRepositoryProvider(fakeRealtimeData),
  );

  final eventsData = ref.watch(eventsDataProvider);

  return EventsController(
    events: eventsData,
    databaseRepository: databaseRepository,
    realtimeRepository: realtimeRepository,
  );
});

// TODO: move eventsData to separate controller -> EventsDataController

class EventsDataController extends StateNotifier<AsyncValue<List<Event>>> {
  EventsDataController() : super(const AsyncData([]));
}

class EventsController extends StateNotifier<AsyncValue<List<Event>>> {
  EventsController({
    required List<Event> events,
    required DatabaseRepository databaseRepository,
    required RealtimeRepository realtimeRepository,
  })  : _databaseRepository = databaseRepository,
        _realtimeRepository = realtimeRepository,
        super(const AsyncData([])) {
    _init(events);
  }

  final DatabaseRepository _databaseRepository;
  final RealtimeRepository _realtimeRepository;

  Future<void> _init(List<Event> events) async {
    await processEvents(events);
  }

  // TODO: remove if unused
  Future<bool> eventExists(String eventId) async {
    return await _realtimeRepository.eventExists(eventId);
  }

  Future<void> processEvents(List<Event> events) async {
    final List<Event> savedEvents = await _fetchSavedEvents();

    try {
      state = const AsyncValue.loading();

      final List<Event> currentEvents = _mergeAndKeepSaved(
        events,
        savedEvents,
      );

      state = AsyncValue.data(currentEvents);
    } catch (e, st) {
      debugPrint(
        "❌ -> Unexpected error while processing events.",
      );
      state = AsyncValue.error(e.toString(), st);
    }
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

  // TODO: can be reused
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

  // TODO: can be reused
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

  // TODO: reusable functions like this can be moved to the repository
  Future<Map<String, dynamic>?> _fetchEventDataById(
    String eventId,
  ) async {
    Map<String, dynamic>? eventMap =
        await _realtimeRepository.fetchEventDataById(
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

  Future<void> addEventByExhibitorId({
    required String exhibitorId,
    required String eventId,
    Function(String)? onError,
  }) async {
    final Map<String, dynamic>? eventMap = await _fetchEventDataById(eventId);

    if (eventMap == null) return;

    final RawExhibitorData? exhibitor = _processMapIntoUserData(
      eventMap: eventMap,
      userId: exhibitorId,
      userCategory: UserCategory.exhibitor,
      factory: RawExhibitorData.fromMap,
    );

    if (exhibitor == null) {
      if (onError != null) {
        onError("You have not registered for this Event");
      }
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
