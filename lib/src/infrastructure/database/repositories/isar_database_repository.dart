import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/interfaces/database_repository.dart';
import '../../../core/models/models.dart';
import '../domain/domain.dart';
import '../utils/utils.dart';

final isarDatabaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
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
    final eventIsar = EventIsarExtensions.fromEvent(event);

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
        .map((EventIsar eventIsar) => EventExtensions.fromEventIsar(eventIsar))
        .toList();
    return events;
  }

  // endregion

  // region Lead Management

  @override
  Future<void> saveLead(Lead lead) async {
    final leadIsar = LeadIsarExtensions.fromLead(lead);

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
        .eventIdEqualTo(eventId)
        .sortByScannedAt()
        .findAll();

    final List<Lead> leads = leadIsars
        .map((leadIsar) => LeadExtensions.fromLeadIsar(leadIsar))
        .toList();
    return leads;
  }

  @override
  Future<void> updateLead(Lead lead) async {
    final leadIsar = LeadIsarExtensions.fromLead(lead);

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
