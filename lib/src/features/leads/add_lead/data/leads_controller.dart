import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';
import '../../../csv/csv.dart';

final leadsControllerProvider =
    StateNotifierProvider<LeadsController, AsyncValue<List<Lead>>>((ref) {
  final CsvService csvService = ref.watch(csvServiceProvider);
  final ShareService shareService = ref.watch(shareServiceProvider);
  return LeadsController(
    csvService: csvService,
    shareService: shareService,
  );
});

class LeadsController extends StateNotifier<AsyncValue<List<Lead>>> {
  LeadsController({
    required CsvService csvService,
    required ShareService shareService,
  })  : _csvService = csvService,
        _shareService = shareService,
        super(const AsyncData([]));

  final CsvService _csvService;
  final ShareService _shareService;

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

      // TODO: add to leads in event [database]

      currentLeads.insert(0, newLead);
      state = AsyncValue.data(currentLeads);

      debugPrint("✅ -> New Lead: $newLead");
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Unexpected error while adding a Lead. Error: $exception",
      );
      state = AsyncValue.error(exception.toString(), stacktrace);
    }
  }

  Future<void> updateLeadNotes(Lead updatedLead) async {
    state.maybeWhen(
      data: (currentLeads) {
        bool found = false;

        // Create a new list with updated lead
        List<Lead> updatedLeads = currentLeads.map((lead) {
          if (lead.hashedString == updatedLead.hashedString) {
            found = true;
            return lead.copyWith(notes: updatedLead.notes);
          } else {
            return lead;
          }
        }).toList();

        // Update the state if a lead was found and updated
        if (found) {
          state = AsyncValue.data(updatedLeads);
        }
      },
      orElse: () {
        debugPrint("❌ -> Unexpected state while updating a Lead's notes.");
      },
    );
  }

  Future<void> exportLeads() async {
    if (state.value == null) return;

    List<List<String>> dataRows = state.value!.toCsvDataRows();

    // TODO: fileName: "$eventId-leads"?
    File csvFile = await _csvService.exportToCSV(
      rows: dataRows,
      fileName: "leads",
    );

    await _shareService.shareFile(
      file: csvFile,
      shareSheetText: "Leads CSV",
    );
  }
}
