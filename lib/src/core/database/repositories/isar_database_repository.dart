import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../interfaces/repositories/database_repository.dart';
import '../../models/models.dart';
import '../domain/domain.dart';

final isarDatabaseRepositoryProvider = Provider<IsarDatabaseRepository>((ref) {
  return IsarDatabaseRepository();
});

class IsarDatabaseRepository implements DatabaseRepository {
  IsarDatabaseRepository() {
    db = openDatabase();
  }

  late Future<Isar> db;

  Future<Isar> openDatabase() async {
    if (Isar.instanceNames.isEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          EventIsarSchema,
          LeadIsarSchema,
        ],
        // TODO: turn off inspector for production
        inspector: true,
        directory: directory.path,
      );
    }

    return Future.value(
      Isar.getInstance(),
    );
  }

  Future<void> resetDatabase() async {
    final Isar isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<void> closeDatabase() async {
    final Isar isar = await db;
    await isar.close();
  }

  // region Event Management

  @override
  Future<void> saveEvent(Event event) async {
    final eventIsar = EventIsar()
      ..eventId = event.eventId
      ..title = event.title
      ..image = event.image
      ..startDate = event.startDate
      ..endDate = event.endDate
      ..saved = event.saved;

    final Isar isar = await db;
    await isar.writeTxn(() async {
      isar.eventIsars.put(eventIsar);
    });
  }

  @override
  Future<List<Event>> fetchEvents() async {
    final isar = await db;
    final List<EventIsar> eventIsars =
        await isar.eventIsars.where().sortByStartDate().findAll();

    final List<Event> events = eventIsars
        .map(
          (EventIsar e) => Event(
            eventId: e.eventId,
            title: e.title,
            image: e.image,
            startDate: e.startDate,
            endDate: e.endDate,
            saved: e.saved,
          ),
        )
        .toList();
    return events;
  }

  // endregion

  // region Lead Management

  @override
  Future<void> saveLead(Lead lead) async {
    final leadIsar = LeadIsar()
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
      ..notes = lead.notes
      ..scannedAt = lead.scannedAt
      ..hashedString = lead.hashedString;

    final Isar isar = await db;
    await isar.writeTxn(() async {
      await isar.leadIsars.put(leadIsar);
    });
  }

  @override
  Future<List<Lead>> fetchLeadsByEventId(String eventId) async {
    final Isar isar = await db;
    final List<LeadIsar> leadIsars = await isar.leadIsars
        .filter()
        .eventIdEqualTo(
          eventId,
        )
        .sortByScannedAt()
        .findAll();

    final List<Lead> leads = leadIsars
        .map(
          (l) => Lead(
            eventId: l.eventId,
            firstName: l.firstName,
            lastName: l.lastName,
            company: l.company,
            email: l.email,
            phone: l.phone,
            position: l.position,
            countryCode: l.countryCode,
            address: l.address,
            zipCode: l.zipCode,
            city: l.city,
            notes: l.notes,
            scannedAt: l.scannedAt,
            hashedString: l.hashedString,
          ),
        )
        .toList();
    return leads;
  }

  @override
  Future<void> updateLead(Lead lead) async {
    final leadIsar = LeadIsar()
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
      ..notes = lead.notes
      ..scannedAt = lead.scannedAt
      ..hashedString = lead.hashedString;

    final Isar isar = await db;
    await isar.writeTxn(() async {
      await isar.leadIsars.putByHashedString(leadIsar);
    });
  }

  @override
  Future<void> deleteLead(Lead lead) async {
    final Isar isar = await db;
    await isar.writeTxn(() async {
      await isar.leadIsars.deleteByHashedString(lead.hashedString);
    });
  }

// endregion
}
