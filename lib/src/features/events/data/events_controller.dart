import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../core/interfaces/database_repository.dart';
import '../../../core/interfaces/realtime_repository.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/utils.dart';
import '../../../infrastructure/database/repositories/isar_database_repository.dart';
import '../../../infrastructure/firebase/repositories/firebase_realtime_repository.dart';
import 'providers.dart';

// region Providers

final eventsFutureProvider = FutureProvider<List<Event>>((ref) async {
  return await fetchEventsFromJson();
});

final eventsControllerProvider =
    StateNotifierProvider<EventsController, AsyncValue<List<Event>>>((ref) {
  final DatabaseRepository databaseRepository = ref.watch(
    isarDatabaseRepositoryProvider,
  );
  final RealtimeRepository realtimeRepository = ref.watch(
    firebaseRealtimeRepositoryProvider,
  );

  return EventsController(
    databaseRepository: databaseRepository,
    realtimeRepository: realtimeRepository,
  );
});

// endregion

class EventsController extends StateNotifier<AsyncValue<List<Event>>> {
  EventsController({
    required DatabaseRepository databaseRepository,
    required RealtimeRepository realtimeRepository,
  })  : _databaseRepository = databaseRepository,
        _realtimeRepository = realtimeRepository,
        super(const AsyncData([]));

  final DatabaseRepository _databaseRepository;
  final RealtimeRepository _realtimeRepository;

  // region Events Management on Startup

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
      if (kDebugMode) {
        debugPrint(
          "❌ -> Unexpected error while processing events. Error: $e",
        );
      }
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<List<Event>> _fetchSavedEvents() async {
    try {
      final List<Event> savedEvents = await _databaseRepository.fetchEvents();
      return savedEvents;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            "❌ -> Caught an exception in _fetchSavedEvents(). Error: $e");
      }
      return [];
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

  // endregion

  // region Exhibitor & Event Management on Scan

  Future<Event?> addEventByExhibitorId({
    required String exhibitorId,
    required Event event,
    Function(String)? onError,
  }) async {
    Event? newEvent;
    String? errorMessage;
    RawExhibitorData? exhibitor;

    try {
      exhibitor = await _realtimeRepository
          .fetchExhibitorById(exhibitorId: exhibitorId, event: event)
          .timeout(
        const Duration(seconds: AppConstants.timeoutSeconds),
        onTimeout: () {
          throw RealtimeException(
            error: RealtimeError.noInternetConnection,
            message: RealtimeError.noInternetConnection.message,
          );
        },
      );
    } catch (e) {
      if (e is RealtimeException) {
        errorMessage = e.message;
      }
    }

    if (exhibitor != null) {
      newEvent = await _addEventToYourEvents(event);
      return newEvent;
    }

    if (onError != null) {
      onError(errorMessage ?? "You have not registered for this Event.");
    }

    return null;
  }

  Future<Event?> _addEventToYourEvents(Event event) async {
    final Event newEvent = event.copyWith(saved: true);
    _replaceOldEventWithUpdatedEvent(newEvent);

    final bool hasSavedEvent = await _saveEventToDatabase(newEvent);
    if (hasSavedEvent) {
      _replaceOldEventWithUpdatedEvent(newEvent);
      return newEvent;
    }

    return null;
  }

  Future<bool> _saveEventToDatabase(Event event) async {
    try {
      await _databaseRepository.saveEvent(event);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ -> Failed to save Event to local database. Error: $e");
      }
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
      if (kDebugMode) {
        debugPrint("❌ -> Failed to update saved event in UI. Error: $e");
      }
    }
  }

// endregion
}
