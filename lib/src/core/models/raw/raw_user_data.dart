abstract class RawUserData {
  const RawUserData({
    required this.company,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.hashedString,
  });

  final String company;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String hashedString;
}
