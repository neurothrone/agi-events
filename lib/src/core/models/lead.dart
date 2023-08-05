class Lead {
  const Lead({
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
}
