import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/repositories/isar_database_repository.dart';
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
  // final DatabaseRepository databaseRepository = ref.watch(
  //   fakeDatabaseRepositoryProvider,
  // );
  // !: Fake Realtime database
  // final AsyncValue<Map<String, dynamic>> fakeRealtimeData = ref.watch(
  //   fakeRealtimeDataFutureProvider,
  // );
  // final RealtimeRepository realtimeRepository = ref.watch(
  //   fakeRealtimeRepositoryProvider(fakeRealtimeData),
  // );

  // !: Isar Local Database
  final DatabaseRepository databaseRepository = ref.watch(
    isarDatabaseRepositoryProvider,
  );
  // // !: Firebase Realtime database
  final RealtimeRepository realtimeRepository = ref.watch(
    firebaseRealtimeRepositoryProvider,
  );

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
      eventId: event.eventId,
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

  Future<Lead?> addLeadByQR({
    required String qrCode,
    required Event event,
    Function(String)? onError,
  }) async {
    final Lead? newLead = await _fetchLead(qrCode: qrCode, event: event);
    final String? errorMessage;

    if (newLead == null) {
      errorMessage = "That user is not registered";
    } else {
      errorMessage = await _addLead(lead: newLead);
    }

    if (errorMessage == null) return newLead;
    if (onError != null) onError(errorMessage);
    return null;
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
      await _insertLeadIntoLeads(lead);
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

  Future<void> _insertLeadIntoLeads(Lead lead) async {
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

  // endregion

  // region Update Lead Management

  // TODO: Move to UpdateLeadController
  // TODO: create two new methods. One to update in database and second in UI
  Future<void> updateLeadNotes(Lead updatedLead) async {
    await _updateLeadInDatabase(updatedLead);
    await _updateLeadInLeads(updatedLead);
  }

  Future<void> _updateLeadInDatabase(Lead updatedLead) async {
    await _databaseRepository.updateLead(updatedLead);
  }

  Future<void> _updateLeadInLeads(Lead updatedLead) async {
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

  Future<void> deleteLead(Lead lead) async {
    await _deleteLeadFromDatabase(lead);
    await _deleteLeadFromLeads(lead);
  }

  Future<void> _deleteLeadFromDatabase(Lead lead) async {
    await _databaseRepository.deleteLead(lead);
  }

  Future<void> _deleteLeadFromLeads(Lead lead) async {
    state.maybeWhen(
      data: (currentLeads) {
        currentLeads.remove(lead);
        state = AsyncValue.data(currentLeads);
      },
      orElse: () {
        debugPrint("❌ -> Unexpected state while deleting a Lead.");
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
