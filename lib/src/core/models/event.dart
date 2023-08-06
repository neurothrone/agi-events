class Event {
  const Event({
    required this.eventId,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map["eventId"] as String,
      title: map["title"] as String,
      subtitle: map["subtitle"] as String,
      image: map["image"] as String,
    );
  }

  final String eventId;
  final String title;
  final String subtitle;
  final String image;

  @override
  String toString() {
    return "Event{"
        " eventId: $eventId,"
        " title: $title,"
        " subtitle: $subtitle,"
        " image: $image,"
        "}";
  }

  Event copyWith({
    String? eventId,
    String? title,
    String? subtitle,
    String? image,
  }) {
    return Event(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      image: image ?? this.image,
    );
  }
}
