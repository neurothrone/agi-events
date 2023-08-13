import 'package:mocktail/mocktail.dart';

import 'package:agi_events/src/core/interfaces/interfaces.dart';
import 'package:agi_events/src/core/models/models.dart';

class MockDatabaseRepository extends Mock implements DatabaseRepository {
  @override
  Future<List<Event>> fetchEvents() async {
    final event1 = Event(
      eventId: "eventId1",
      title: "Random event 1",
      image: "image1",
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 3)),
      saved: true,
    );
    final event2 = Event(
      eventId: "eventId2",
      title: "Random event 2",
      image: "image2",
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 8)),
      saved: true,
    );
    return [event1, event2];
  }
}