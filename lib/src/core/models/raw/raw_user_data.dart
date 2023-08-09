base class RawUserData {
  const RawUserData({
    required this.company,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.hashedString,
  });

  factory RawUserData.fromMap(Map<String, dynamic> map) {
    final company = map.containsKey("company") ? map["company"] as String : "";
    final email = map.containsKey("email") ? map["email"] as String : "";
    final firstName =
        map.containsKey("firstName") ? map["firstName"] as String : "";
    final lastName =
        map.containsKey("lastName") ? map["lastName"] as String : "";

    final String phone;
    final dynamic phoneFromMap = map["phone"];
    if (phoneFromMap is String) {
      phone = phoneFromMap;
    } else if (phoneFromMap is int) {
      phone = phoneFromMap.toString();
    } else {
      phone = "";
    }

    final exhibitionId =
        map.containsKey("exhibitionId") ? map["exhibitionId"] as String : "";
    final hashedString = "$email$firstName$lastName$exhibitionId".toLowerCase();

    return RawUserData(
      company: company,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      hashedString: hashedString,
    );
  }

  final String company;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String hashedString;
}
