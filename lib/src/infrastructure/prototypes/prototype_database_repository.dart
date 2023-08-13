import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/interfaces/interfaces.dart';
import '../../core/models/models.dart';

final prototypeDatabaseRepositoryProvider = Provider<PrototypeDatabaseRepository>((ref) {
  return PrototypeDatabaseRepository();
});

class PrototypeDatabaseRepository implements DatabaseRepository {
  final Set<Event> _events = {};
  final Set<Lead> _leads = {};

  // region Event Management

  @override
  Future<void> saveEvent(Event event) async {
    _events.add(event);
  }

  @override
  Future<List<Event>> fetchEvents() async {
    final List<Event> events = _events.toList();
    events.sort((a, b) => a.startDate.compareTo(b.startDate));
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
