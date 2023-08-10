import 'package:isar/isar.dart';

part 'event_isar.g.dart';

@collection
class EventIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true, caseSensitive: false)
  late String eventId;
  late String title;
  late String image;
  @Index(caseSensitive: false)
  late DateTime startDate;
  late DateTime endDate;
  late bool saved;
}
