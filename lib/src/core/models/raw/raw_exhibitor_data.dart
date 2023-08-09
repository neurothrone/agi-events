import 'raw_user_data.dart';

final class RawExhibitorData extends RawUserData {
  const RawExhibitorData({
    required String company,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String hashedString,
    required this.registeredAtDate,
  }) : super(
          company: company,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          hashedString: hashedString,
        );

  factory RawExhibitorData.fromMap(Map<String, dynamic> map) {
    final RawUserData baseData = RawUserData.fromMap(map);

    final registeredAtDate = map.containsKey("registeredAtDate")
        ? map["registeredAtDate"] as String
        : "";

    return RawExhibitorData(
      company: baseData.company,
      email: baseData.email,
      firstName: baseData.firstName,
      lastName: baseData.lastName,
      phone: baseData.phone,
      hashedString: baseData.hashedString,
      registeredAtDate: registeredAtDate,
    );
  }

  final String registeredAtDate;

  @override
  String toString() {
    return "RawExhibitorData{"
        " company: $company,"
        " email: $email,"
        " firstName: $firstName,"
        " lastName: $lastName,"
        " phone: $phone,"
        " hashedString: $hashedString,"
        " registeredAtDate: $registeredAtDate,"
        "}";
  }
}
