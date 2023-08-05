import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';

final leadsControllerProvider = StateNotifierProvider.family<LeadsController,
    AsyncValue<List<Lead>>, String>((ref, eventId) {
  return LeadsController(eventId: eventId);
});

class LeadsController extends StateNotifier<AsyncValue<List<Lead>>> {
  LeadsController({
    required String eventId,
  })  : _eventId = eventId,
        super(const AsyncData([]));

  final String _eventId;

  Future<void> addLead({
    required String firstName,
    required String lastName,
    required String company,
    required String email,
    String? phone,
    String? position,
    String? address,
    String? zipCode,
    String? city,
  }) async {
    try {
      state = const AsyncValue.loading();

      const eventId = "eventId";

      final newLead = Lead(
        firstName: firstName,
        lastName: lastName,
        company: company,
        email: email,
        phone: phone,
        address: address,
        zipCode: zipCode,
        city: city,
        scannedAt: DateTime.now(),
        hashedString: "$email$firstName$lastName$eventId",
      );

      debugPrint("✅ -> New Lead: $newLead");

      // TODO: add to leads in event [database]

      // TODO: update UI "Your leads" with [newLead] appended to top of list

      final List<Lead> leads = List.from(state.value ?? []);
      leads.add(newLead);
      state = AsyncValue.data(leads);
      debugPrint("✅ -> Successfully added a Lead.");

      // TODO: navigate to Lead Detail page with [newLead]
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Unexpected error while creating adding a Lead. Error: $exception",
      );
      state = AsyncValue.error(exception.toString(), stacktrace);
    }
  }

  Future<void> updateLeadNotes(Lead lead) async {}

  Future<void> exportLeads() async {}
}
