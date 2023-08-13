import 'package:flutter_test/flutter_test.dart';

import 'package:agi_events/src/infrastructure/mocks/mock_database_repository.dart';
import 'package:agi_events/src/core/models/models.dart';

void main() {
  group("MockDatabaseRepository", () {
    late MockDatabaseRepository repository;

    setUp(() {
      repository = MockDatabaseRepository();
    });

    test(
      "saveEvent should add an event to the repository",
      () async {
        // Arrange
        final event = Event(
          eventId: "eventId",
          title: "Random event",
          image: "image",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 3)),
          saved: true,
        );

        await repository.saveEvent(event);

        // Act
        final events = await repository.fetchEvents();

        // Assert
        expect(events, contains(event));
      },
    );

    test(
      "fetchEvents should retrieve events sorted by startDate in "
      "descending order",
      () async {
        // Arrange
        final event1 = Event(
          eventId: "eventId1",
          title: "Random event 1",
          image: "image1",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 3)),
          saved: true,
        );
        final event2 = Event(
          eventId: "eventId2",
          title: "Random event 2",
          image: "image2",
          startDate: DateTime.now().add(const Duration(days: 5)),
          endDate: DateTime.now().add(const Duration(days: 8)),
          saved: true,
        );

        await repository.saveEvent(event1);
        await repository.saveEvent(event2);

        // Act
        final events = await repository.fetchEvents();

        // Assert
        expect(events.first, event1);
        expect(events.last, event2);
      },
    );

    test(
      "saveLead saves the lead correctly",
      () async {
        // Arrange
        const eventId = "eventId";
        final startDate = DateTime.now();

        const firstName = "John";
        const lastName = "Doe";
        const company = "Test AB";
        const email = "john.doe@example.com";

        final lead = Lead(
          eventId: eventId,
          firstName: firstName,
          lastName: lastName,
          company: company,
          email: email,
          scannedAt: startDate.add(const Duration(hours: 1)),
          hashedString: "$email$firstName$lastName$eventId",
        );

        // Act
        await repository.saveLead(lead);

        // Assert
        final leads = await repository.fetchLeadsByEventId(eventId);
        expect(leads.contains(lead), true);
      },
    );

    test(
      "fetchLeadsByEventId returns leads sorted by scannedAt in "
      "descending order, i.e. with the most recent (latest) first",
      () async {
        // Arrange
        const eventId = "eventId";
        final startDate = DateTime.now();

        const firstName1 = "John";
        const lastName1 = "Doe";
        const company1 = "Test AB";
        const email1 = "john.doe@example.com";

        final lead1 = Lead(
          eventId: eventId,
          firstName: firstName1,
          lastName: lastName1,
          company: company1,
          email: email1,
          scannedAt: startDate.add(const Duration(hours: 1)),
          hashedString: "$email1$firstName1$lastName1$eventId",
        );

        const firstName2 = "Jane";
        const lastName2 = "Doe";
        const company2 = "Doe Industries";
        const email2 = "jane.doe@example.com";

        final lead2 = Lead(
          eventId: eventId,
          firstName: firstName2,
          lastName: lastName2,
          company: company2,
          email: email2,
          scannedAt: startDate.add(const Duration(hours: 2)),
          hashedString: "$email2$firstName2$lastName2$eventId",
        );
        await repository.saveLead(lead1);
        await repository.saveLead(lead2);

        // Act
        final leads = await repository.fetchLeadsByEventId(eventId);

        // Assert
        expect(leads.first, lead2);
        expect(leads.last, lead1);
      },
    );

    test(
      "updateLead updates the given lead in the repository",
      () async {
        // Arrange
        const eventId = "eventId";
        final originalLead = Lead(
          eventId: eventId,
          firstName: "John",
          lastName: "Doe",
          company: "Company",
          email: "john.doe@example.com",
          scannedAt: DateTime.now(),
          hashedString: "hashedString",
        );

        await repository.saveLead(originalLead);

        const notes = "Some notes";
        final updatedLead = originalLead.copyWith(notes: notes);

        // Act
        await repository.updateLead(updatedLead);

        // Assert
        final leads = await repository.fetchLeadsByEventId(eventId);

        expect(leads.length, 1);
        expect(leads.first.notes, notes);
      },
    );

    test(
      "deleteLead removes the given lead from the repository",
      () async {
        // Arrange
        const eventId = "eventId";
        final leadToDelete = Lead(
          eventId: eventId,
          firstName: "John",
          lastName: "Doe",
          company: "Company",
          email: "john.doe@example.com",
          scannedAt: DateTime.now(),
          hashedString: "hashedString",
        );

        await repository.saveLead(leadToDelete);

        // Ensure the lead exists before deletion
        var leads = await repository.fetchLeadsByEventId(eventId);
        expect(leads.contains(leadToDelete), true);

        // Act
        await repository.deleteLead(leadToDelete);

        // Assert
        leads = await repository.fetchLeadsByEventId(eventId);
        expect(leads.contains(leadToDelete), false);
      },
    );
  });
}
