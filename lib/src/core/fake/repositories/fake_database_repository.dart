import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../interfaces/repositories/database_repository.dart';
import '../../models/models.dart';

final fakeDatabaseRepositoryProvider = Provider<FakeDatabaseRepository>((ref) {
  return FakeDatabaseRepository();
});

class FakeDatabaseRepository implements DatabaseRepository {
  final List<Event> _events = [];
  final List<Lead> _leads = [];

  @override
  Future<Event?> fetchEventById(String eventId) async {
    for (final event in _events) {
      if (event.eventId == eventId) {
        return Future.value(event);
      }
    }
    return Future.value(null);
  }

  @override
  Future<List<Event>> fetchEvents() async => _events;

  @override
  Future<List<Lead>> fetchLeadsByEventId(String eventId) async {
    // TODO: implement fetchLeadsByEventId
    throw UnimplementedError();
  }

  @override
  Future<void> saveEvent(Event event) async {
    _events.add(event);
  }

  @override
  Future<void> saveLead(Lead lead) async {
    _leads.add(lead);
  }
}
