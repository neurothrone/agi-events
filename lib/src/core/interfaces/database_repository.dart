import '../models/models.dart';

/// An abstract repository defining the necessary operations for
/// interacting with the app's database.
///
/// This class serves as a contract that concrete implementations
/// must adhere to, ensuring consistent behavior across different
/// database sources.
abstract class DatabaseRepository {
  /// Saves the provided event to the database.
  ///
  /// Parameters:
  /// - [event]: The event data to be saved.
  ///
  /// Returns:
  /// A `Future` that completes once the event has been saved.
  Future<void> saveEvent(Event event);

  /// Fetches all events from the database.
  ///
  /// Returns:
  /// A `Future` that resolves to a list of [Event]s.
  Future<List<Event>> fetchEvents();

  /// Saves the provided lead to the database.
  ///
  /// Parameters:
  /// - [lead]: The lead data to be saved.
  ///
  /// Returns:
  /// A `Future` that completes once the lead has been saved.
  Future<void> saveLead(Lead lead);

  /// Fetches all leads associated with the provided event ID.
  ///
  /// Parameters:
  /// - [eventId]: The unique identifier for the event.
  ///
  /// Returns:
  /// A `Future` that resolves to a list of [Lead]s.
  Future<List<Lead>> fetchLeadsByEventId(String eventId);

  /// Updates the details of an existing lead in the database.
  ///
  /// Parameters:
  /// - [lead]: The lead data with updated details.
  ///
  /// Returns:
  /// A `Future` that completes once the lead has been updated.
  Future<void> updateLead(Lead lead);

  /// Deletes the provided lead from the database.
  ///
  /// Parameters:
  /// - [lead]: The lead data to be deleted.
  ///
  /// Returns:
  /// A `Future` that completes once the lead has been deleted.
  Future<void> deleteLead(Lead lead);
}
