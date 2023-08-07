import 'raw_user_data.dart';

class RawVisitorData extends RawUserData {
  const RawVisitorData({
    required String company,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String hashedString,
    required this.countryCode,
    required this.position,
    required this.address,
    required this.zipCode,
    required this.city,
  }) : super(
          company: company,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          hashedString: hashedString,
        );

  factory RawVisitorData.fromMap(Map<String, dynamic> map) {
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
    final hashedString = "$firstName$lastName$exhibitionId";

    final countryCode =
        map.containsKey("countryCode") ? map["countryCode"] as String : "";
    final position =
        map.containsKey("position") ? map["position"] as String : "";
    final address = map.containsKey("address") ? map["address"] as String : "";
    final zipCode = map.containsKey("zipCode") ? map["zipCode"] as String : "";
    final city = map.containsKey("city") ? map["city"] as String : "";

    return RawVisitorData(
      company: company,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      hashedString: hashedString,
      countryCode: countryCode,
      position: position,
      address: address,
      zipCode: zipCode,
      city: city,
    );
  }

  final String countryCode;
  final String position;
  final String address;
  final String zipCode;
  final String city;

  @override
  String toString() {
    return "RawVisitorData{"
        " company: $company,"
        " email: $email,"
        " firstName: $firstName,"
        " lastName: $lastName,"
        " phone: $phone,"
        " countryCode: $countryCode,"
        " position: $position,"
        " address: $address,"
        " zipCode: $zipCode,"
        " city: $city,"
        "}";
  }
}
