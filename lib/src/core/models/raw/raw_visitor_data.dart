import 'raw_user_data.dart';

final class RawVisitorData extends RawUserData {
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
    final RawUserData baseData = RawUserData.fromMap(map);

    final countryCode =
        map.containsKey("countryCode") ? map["countryCode"] as String : "";
    final position =
        map.containsKey("position") ? map["position"] as String : "";
    final address = map.containsKey("address") ? map["address"] as String : "";
    final zipCode = map.containsKey("zipCode") ? map["zipCode"] as String : "";
    final city = map.containsKey("city") ? map["city"] as String : "";

    return RawVisitorData(
      company: baseData.company,
      email: baseData.email,
      firstName: baseData.firstName,
      lastName: baseData.lastName,
      phone: baseData.phone,
      hashedString: baseData.hashedString,
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
