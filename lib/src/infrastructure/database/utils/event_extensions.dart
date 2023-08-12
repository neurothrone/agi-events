import '../../../core/models/models.dart';
import '../domain/domain.dart';

extension EventExtensions on Event {
  static Event fromEventIsar(EventIsar eventIsar) {
    return Event(
      eventId: eventIsar.eventId,
      title: eventIsar.title,
      image: eventIsar.image,
      startDate: eventIsar.startDate,
      endDate: eventIsar.endDate,
      saved: eventIsar.saved,
    );
  }
}
