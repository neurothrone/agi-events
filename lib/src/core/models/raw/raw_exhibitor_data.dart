import 'raw_user_data.dart';

class RawExhibitorData extends RawUserData {
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

    final registeredAtDate = map.containsKey("registeredAtDate")
        ? map["registeredAtDate"] as String
        : "";

    return RawExhibitorData(
      company: company,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      hashedString: hashedString,
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
