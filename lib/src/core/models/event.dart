import '../utils/utils.dart';

class Event {
  const Event({
    required this.eventId,
    required this.title,
    required this.image,
    required this.startDate,
    required this.endDate,
    this.saved = false,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    final eventId = map.containsKey("eventId") ? map["eventId"] as String : "";
    final title = map.containsKey("title") ? map["title"] as String : "";
    final image = map.containsKey("image") ? map["image"] as String : "";
    String rawStartDate =
        map.containsKey("startDate") ? map["startDate"] as String : "";
    String rawEndDate =
        map.containsKey("endDate") ? map["endDate"] as String : "";

    DateTime startDate = rawStartDate.toDateTime();
    DateTime endDate = rawEndDate.toDateTime();

    return Event(
      eventId: eventId,
      title: title,
      image: image,
      startDate: startDate,
      endDate: endDate,
      saved: false,
    );
  }

  final String eventId;
  final String title;
  final String image;
  final DateTime startDate;
  final DateTime endDate;
  final bool saved;

  String get subtitle =>
      "${startDate.formattedForDay}-${endDate.formattedForDayAndMonth}";

  @override
  String toString() {
    return "Event{"
        " eventId: $eventId,"
        " title: $title,"
        " subtitle: $subtitle,"
        " image: $image,"
        " saved: $saved,"
        "}";
  }

  Event copyWith({
    String? eventId,
    String? title,
    String? subtitle,
    String? image,
    DateTime? startDate,
    DateTime? endDate,
    bool? saved,
  }) {
    return Event(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      saved: saved ?? this.saved,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          eventId == other.eventId;

  @override
  int get hashCode => eventId.hashCode;
}
