import 'package:isar/isar.dart';

part 'lead_isar.g.dart';

@collection
class LeadIsar {
  Id id = Isar.autoIncrement;
  @Index(caseSensitive: false)
  late String eventId;
  late String firstName;
  late String lastName;
  late String company;
  late String email;
  String? phone;
  String? position;
  String? countryCode;
  String? address;
  String? zipCode;
  String? city;
  String? notes;
  @Index(caseSensitive: false)
  late DateTime scannedAt;
  @Index(unique: true, replace: true, caseSensitive: false)
  late String hashedString;
}
