import '../../models/models.dart';
import '../domain/domain.dart';

extension LeadIsarExtensions on LeadIsar {
  static LeadIsar fromLead(Lead lead) {
    return LeadIsar()
      ..eventId = lead.eventId
      ..firstName = lead.firstName
      ..lastName = lead.lastName
      ..company = lead.company
      ..email = lead.email
      ..phone = lead.phone
      ..position = lead.position
      ..address = lead.address
      ..zipCode = lead.zipCode
      ..city = lead.city
      ..product = lead.product
      ..seller = lead.seller
      ..notes = lead.notes
      ..scannedAt = lead.scannedAt
      ..hashedString = lead.hashedString;
  }
}
