import 'models.dart';

class Lead {
  const Lead({
    required this.eventId,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.email,
    this.phone,
    this.position,
    this.countryCode,
    this.address,
    this.zipCode,
    this.city,
    this.notes,
    required this.scannedAt,
    required this.hashedString,
  });

  factory Lead.fromRawVisitorData({
    required RawVisitorData visitor,
    required Event event,
  }) {
    final hashedString = "${visitor.email}${visitor.firstName}"
            "${visitor.lastName}${event.eventId}"
        .toLowerCase();

    return Lead(
      eventId: event.eventId,
      firstName: visitor.firstName,
      lastName: visitor.lastName,
      company: visitor.company,
      email: visitor.email,
      phone: visitor.phone,
      position: visitor.position,
      countryCode: visitor.countryCode,
      address: visitor.address,
      zipCode: visitor.zipCode,
      city: visitor.city,
      scannedAt: DateTime.now(),
      hashedString: hashedString,
    );
  }

  factory Lead.fromRawExhibitorData({
    required RawExhibitorData exhibitor,
    required Event event,
  }) {
    final hashedString = "${exhibitor.email}${exhibitor.firstName}"
            "${exhibitor.lastName}${event.eventId}"
        .toLowerCase();

    return Lead(
      eventId: event.eventId,
      firstName: exhibitor.firstName,
      lastName: exhibitor.lastName,
      company: exhibitor.company,
      email: exhibitor.email,
      phone: exhibitor.phone,
      scannedAt: DateTime.now(),
      hashedString: hashedString,
    );
  }

  final String eventId;
  final String firstName;
  final String lastName;
  final String company;
  final String email;
  final String? phone;
  final String? position;
  final String? countryCode;
  final String? address;
  final String? zipCode;
  final String? city;
  final String? notes;
  final DateTime scannedAt;
  final String hashedString;

  String get fullName => "$firstName $lastName";

  @override
  String toString() {
    return "Lead{\n"
        " eventId: $eventId,\n"
        " firstName: $firstName,\n"
        " lastName: $lastName,\n"
        " company: $company,\n"
        " email: $email,\n"
        " phone: $phone,\n"
        " position: $position,\n"
        " countryCode: $countryCode,\n"
        " address: $address,\n"
        " zipCode: $zipCode,\n"
        " city: $city,\n"
        " notes: $notes,\n"
        " scannedAt: $scannedAt,\n"
        " hashedString: $hashedString,\n"
        '}';
  }

  Lead copyWith({
    String? eventId,
    String? firstName,
    String? lastName,
    String? company,
    String? email,
    String? phone,
    String? position,
    String? countryCode,
    String? address,
    String? zipCode,
    String? city,
    String? notes,
    DateTime? scannedAt,
    String? hashedString,
  }) {
    return Lead(
      eventId: eventId ?? this.eventId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      position: position ?? this.position,
      countryCode: countryCode ?? this.countryCode,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      scannedAt: scannedAt ?? this.scannedAt,
      hashedString: hashedString ?? this.hashedString,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lead &&
          runtimeType == other.runtimeType &&
          hashedString == other.hashedString;

  @override
  int get hashCode => hashedString.hashCode;
}
