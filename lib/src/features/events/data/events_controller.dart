import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/fake/data/providers.dart';
import '../../../core/fake/repositories/fake_database_repository.dart';
import '../../../core/fake/repositories/fake_realtime_repository.dart';
import '../../../core/interfaces/repositories/database_repository.dart';
import '../../../core/interfaces/repositories/realtime_repository.dart';
import '../../../core/models/models.dart';
import 'providers.dart';

// region Providers

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

// endregion

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

  // region Events Management on Startup

  Future<void> _init(List<Event> events) async {
    await processEvents(events);
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

  Future<List<Event>> _fetchSavedEvents() async {
    final List<Event> savedEvents = await _databaseRepository.fetchEvents();
    return savedEvents;
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

  // endregion

  // region Exhibitor & Event Management on Scan

  Future<void> addEventByExhibitorId({
    required String exhibitorId,
    required Event event,
    Function(String)? onError,
  }) async {
    final RawExhibitorData? exhibitor =
        await _realtimeRepository.fetchExhibitorById(
      exhibitorId: exhibitorId,
      event: event,
    );

    if (exhibitor == null) {
      if (onError != null) {
        onError("You have not registered for this Event");
      }
      return;
    }

    // !: If we got this far the exhibitor was registered in Firebase
    await _addEventToYourEvents(event);
  }

  Future<void> _addEventToYourEvents(Event event) async {
    final Event newEvent = event.copyWith(saved: true);
    _replaceOldEventWithUpdatedEvent(newEvent);

    final bool hasSavedEvent = await _saveEventToDatabase(newEvent);
    if (hasSavedEvent) {
      _replaceOldEventWithUpdatedEvent(newEvent);
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

  // endregion
}
