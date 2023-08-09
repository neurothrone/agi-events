import '../../models/models.dart';

abstract class DatabaseRepository {
  Future<void> saveEvent(Event event);

  Future<void> saveLead(Lead lead);

  Future<List<Event>> fetchEvents();

  Future<Event?> fetchEventById(String eventId);

  Future<List<Lead>> fetchLeadsByEventId(String eventId);

  Future<void> updateLead(Lead lead);

  Future<void> deleteLead(Lead lead);
}
