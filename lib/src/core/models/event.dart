class Event {
  const Event({
    required this.eventId,
    required this.title,
    required this.subtitle,
    required this.image,
    this.saved = false,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map["eventId"] as String,
      title: map["title"] as String,
      subtitle: map["subtitle"] as String,
      image: map["image"] as String,
      saved: false,
    );
  }

  final String eventId;
  final String title;
  final String subtitle;
  final String image;
  final bool saved;

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
    bool? saved,
  }) {
    return Event(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      image: image ?? this.image,
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
