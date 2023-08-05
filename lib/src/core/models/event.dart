import 'lead.dart';

class Event {
  const Event({
    required this.eventId,
    required this.leads,
  });

  final String eventId;
  final List<Lead> leads;
}
