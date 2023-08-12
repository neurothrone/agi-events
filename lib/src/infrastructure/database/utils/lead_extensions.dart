import '../../../core/models/models.dart';
import '../domain/domain.dart';

extension LeadExtensions on Lead {
  static Lead fromLeadIsar(LeadIsar leadIsar) {
    return Lead(
      eventId: leadIsar.eventId,
      firstName: leadIsar.firstName,
      lastName: leadIsar.lastName,
      company: leadIsar.company,
      email: leadIsar.email,
      phone: leadIsar.phone,
      position: leadIsar.position,
      countryCode: leadIsar.countryCode,
      address: leadIsar.address,
      zipCode: leadIsar.zipCode,
      city: leadIsar.city,
      product: leadIsar.product,
      seller: leadIsar.seller,
      notes: leadIsar.notes,
      scannedAt: leadIsar.scannedAt,
      hashedString: leadIsar.hashedString,
    );
  }
}
