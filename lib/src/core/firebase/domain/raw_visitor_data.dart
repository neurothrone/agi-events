import 'raw_lead_data.dart';

class RawVisitorData extends RawLeadData {
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
    return RawVisitorData(
      company: map["company"] as String,
      email: map["email"] as String,
      firstName: map["firstName"] as String,
      lastName: map["lastName"] as String,
      phone: map["phone"] as String,
      hashedString: map["hashedString"] as String,
      countryCode: map["countryCode"] as String,
      position: map["position"] as String,
      address: map["address"] as String,
      zipCode: map["zipCode"] as String,
      city: map["city"] as String,
    );
  }

  final String countryCode;
  final String position;
  final String address;
  final String zipCode;
  final String city;
}
