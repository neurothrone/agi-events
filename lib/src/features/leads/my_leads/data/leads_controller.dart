import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/fake/data/providers.dart';
import '../../../../core/fake/repositories/fake_database_repository.dart';
import '../../../../core/fake/repositories/fake_realtime_repository.dart';
import '../../../../core/firebase/repositories/firebase_realtime_repository.dart';
import '../../../../core/interfaces/repositories/database_repository.dart';
import '../../../../core/interfaces/repositories/realtime_repository.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../csv/csv.dart';

final leadsControllerProvider =
    StateNotifierProvider<LeadsController, AsyncValue<List<Lead>>>((ref) {
  // !: Fake Local Database
  final DatabaseRepository databaseRepository = ref.watch(
    fakeDatabaseRepositoryProvider,
  );
  // !: Fake Realtime database
  final AsyncValue<Map<String, dynamic>> fakeRealtimeData = ref.watch(
    fakeRealtimeDataFutureProvider,
  );
  final RealtimeRepository realtimeRepository = ref.watch(
    fakeRealtimeRepositoryProvider(fakeRealtimeData),
  );

  // !: Firebase Realtime database
  // final RealtimeRepository realtimeRepository = ref.watch(
  //   firebaseRealtimeRepositoryProvider,
  // );

  final CsvService csvService = ref.watch(csvServiceProvider);
  final ShareService shareService = ref.watch(shareServiceProvider);

  return LeadsController(
    databaseRepository: databaseRepository,
    realtimeRepository: realtimeRepository,
    csvService: csvService,
    shareService: shareService,
  );
});

class LeadsController extends StateNotifier<AsyncValue<List<Lead>>> {
  LeadsController({
    required DatabaseRepository databaseRepository,
    required RealtimeRepository realtimeRepository,
    required CsvService csvService,
    required ShareService shareService,
  })  : _databaseRepository = databaseRepository,
        _realtimeRepository = realtimeRepository,
        _csvService = csvService,
        _shareService = shareService,
        super(const AsyncData([]));

  final DatabaseRepository _databaseRepository;
  final RealtimeRepository _realtimeRepository;

  final CsvService _csvService;
  final ShareService _shareService;

  // region Add Lead Management

  // TODO: pass eventId and assign it to a new property on Lead
  Future<void> addLeadManually({
    required Event event,
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String company,
    required String email,
    String? phone,
    String? position,
    String? address,
    String? zipCode,
    String? city,
    Function(String)? onError,
  }) async {
    final hashedString =
        "$email$firstName$lastName${event.eventId}".toLowerCase();

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
      hashedString: hashedString,
    );

    final String? errorMessage = await _addLead(lead: newLead);

    if (errorMessage != null && onError != null) {
      onError(errorMessage);
    }
  }

  Future<void> addLeadByQR({
    required String qrCode,
    required Event event,
    Function(String)? onError,
  }) async {
    // TODO: check that lead by that qr code is not already in leads
    // TODO: optimization
    // We can do this by modifying Lead to also have a qrCode property
    // This way we can quick check our leads without a request to firebase

    final Lead? newLead = await _fetchLead(qrCode: qrCode, event: event);

    final String? errorMessage;

    if (newLead == null) {
      debugPrint("❌ -> No Visitor or Exhibitor found.");
      errorMessage = "That user is not registered";
      return;
    } else {
      errorMessage = await _addLead(lead: newLead);
    }

    if (errorMessage != null && onError != null) {
      onError(errorMessage);
    }
  }

  Future<String?> _addLead({
    required Lead lead,
  }) async {
    final List<Lead> currentLeads = List.from(state.value ?? []);

    if (currentLeads.contains(lead)) {
      return "You have already added that Lead";
    }

    final bool hasSavedLead = await _saveLeadToDatabase(lead);

    if (hasSavedLead) {
      await _updateLeadsWithNewLead(lead);
      return null;
    }

    return "Failed to save Lead to database";
  }

  Future<Lead?> _fetchLead({
    required String qrCode,
    required Event event,
  }) async {
    final RawVisitorData? visitor = await _realtimeRepository.fetchVisitorById(
      visitorId: qrCode,
      event: event,
    );

    if (visitor != null) {
      return Lead.fromRawVisitorData(visitor: visitor, event: event);
    }

    final RawExhibitorData? exhibitor =
        await _realtimeRepository.fetchExhibitorById(
      exhibitorId: qrCode,
      event: event,
    );

    if (exhibitor != null) {
      return Lead.fromRawExhibitorData(exhibitor: exhibitor, event: event);
    }

    return null;
  }

  Future<bool> _saveLeadToDatabase(Lead lead) async {
    try {
      await _databaseRepository.saveLead(lead);
      return true;
    } catch (e) {
      debugPrint("❌ -> Failed to save Lead to database. Error: $e");
      return false;
    }
  }

  // endregion

  // region Update Lead Management

  Future<void> _updateLeadsWithNewLead(Lead lead) async {
    final List<Lead> currentLeads = List.from(state.value ?? []);

    try {
      state = const AsyncValue.loading();

      currentLeads.insert(0, lead);
      state = AsyncValue.data(currentLeads);
    } catch (e, stacktrace) {
      debugPrint(
        "❌ -> Unexpected error while adding a Lead. Error: $e",
      );
      state = AsyncValue.error(e.toString(), stacktrace);
    }
  }

  // TODO: Move to UpdateLeadController
  // TODO: create two new methods. One to update in database and second in UI
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

  // endregion

  // region Export Leads

  Future<void> exportLeads({
    required Event event,
    Rect? sharePositionOrigin,
  }) async {
    state.maybeWhen(
      data: (currentLeads) async {
        List<List<String>> dataRows = state.value!.toCsvDataRows();

        File csvFile = await _csvService.exportToCSV(
          rows: dataRows,
          fileName: "AGI Events ${event.title} Exported Leads",
        );

        await _shareService.shareFile(
          file: csvFile,
          shareSheetText: "Leads CSV",
          sharePositionOrigin: sharePositionOrigin,
        );
      },
      orElse: () {
        debugPrint("❌ -> Unexpected state while exporting leads.");
      },
    );
  }

// endregion
}
