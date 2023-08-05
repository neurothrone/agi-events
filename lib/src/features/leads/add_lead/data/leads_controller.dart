import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';

final leadsControllerProvider =
    StateNotifierProvider<LeadsController, AsyncValue<List<Lead>>>((ref) {
  return LeadsController();
});

class LeadsController extends StateNotifier<AsyncValue<List<Lead>>> {
  LeadsController() : super(const AsyncData([]));

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
    final List<Lead> currentLeads = List.from(state.value ?? []);

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

      currentLeads.insert(0, newLead);
      state = AsyncValue.data(currentLeads);

      // debugPrint("✅ -> Successfully added a Lead.");
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Unexpected error while adding a Lead. Error: $exception",
      );
      state = AsyncValue.error(exception.toString(), stacktrace);
    }
  }

  Future<void> updateLeadNotes(Lead lead) async {}

  Future<void> exportLeads() async {}
}
