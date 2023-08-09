import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../interfaces/repositories/database_repository.dart';
import '../../models/models.dart';

final fakeDatabaseRepositoryProvider = Provider<FakeDatabaseRepository>((ref) {
  return FakeDatabaseRepository();
});

class FakeDatabaseRepository implements DatabaseRepository {
  final Set<Event> _events = {};
  final Set<Lead> _leads = {};

  // region Event Management

  @override
  Future<void> saveEvent(Event event) async {
    _events.add(event);
  }

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
  Future<List<Event>> fetchEvents() async {
    final List<Event> events = _events.toList();
    events.sort((a, b) => b.startDate.compareTo(a.startDate));
    return events;
  }

  // endregion

  // region Lead Management

  @override
  Future<void> saveLead(Lead lead) async {
    _leads.add(lead);
  }

  @override
  Future<List<Lead>> fetchLeadsByEventId(String eventId) async {
    List<Lead> leads = _leads.toList();
    leads.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return leads;
  }

  @override
  Future<void> updateLead(Lead lead) async {
    _leads.remove(lead);
    _leads.add(lead);
  }

  @override
  Future<void> deleteLead(Lead lead) async {
    _leads.remove(lead);
  }

  // endregion
}
