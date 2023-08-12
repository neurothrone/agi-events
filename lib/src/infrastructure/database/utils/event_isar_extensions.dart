import '../../../core/models/models.dart';
import '../domain/domain.dart';

extension EventIsarExtensions on EventIsar {
  static EventIsar fromEvent(Event event) {
    return EventIsar()
      ..eventId = event.eventId
      ..title = event.title
      ..image = event.image
      ..startDate = event.startDate
      ..endDate = event.endDate
      ..saved = event.saved;
  }
}
