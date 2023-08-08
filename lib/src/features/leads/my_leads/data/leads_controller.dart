import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/fake/data/providers.dart';
import '../../../../core/fake/repositories/fake_database_repository.dart';
import '../../../../core/fake/repositories/fake_realtime_repository.dart';
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
  final jsonData = ref.watch(fakeDataFutureProvider);
  final RealtimeRepository realtimeRepository = ref.watch(
    fakeRealtimeRepositoryProvider(jsonData),
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

  Future<void> _addLead(Lead lead) async {
    final List<Lead> currentLeads = List.from(state.value ?? []);

    if (currentLeads.contains(lead)) {
      // TODO: Show a Snackbar
      debugPrint("ℹ️ -> You have already added that Lead.");
      return;
    }

    final bool hasSavedLead = await _saveLeadToDatabase(lead);

    if (hasSavedLead) {
      await _updateLeadsWithNewLead(lead);
    }
  }

  // TODO: pass eventId and assign it to a new property on Lead
  Future<void> addLeadManually({
    required Event event,
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

    await _addLead(newLead);
  }

  Future<void> addLeadByQR({
    required String qrCode,
    required Event event,
  }) async {
    // TODO: check that lead by that qr code is not already in leads

    final Map<String, dynamic>? eventMap = await _fetchEventDataById(
      event.eventId,
    );

    if (eventMap == null) return;

    // TODO get UserData
    final RawVisitorData? visitor = await _processMapIntoExhibitorData(
      eventMap: eventMap,
      visitorId: qrCode,
    );

    if (visitor == null) {
      debugPrint("❌ -> Visitor was null.");
      return;
    }

    final hashedString = "${visitor.email}${visitor.firstName}"
            "${visitor.lastName}${event.eventId}"
        .toLowerCase();

    // Convert Visitor to Lead
    final Lead newLead = Lead(
      firstName: visitor.firstName,
      lastName: visitor.lastName,
      company: visitor.company,
      email: visitor.email,
      phone: visitor.phone,
      position: visitor.position,
      countryCode: visitor.countryCode,
      address: visitor.address,
      zipCode: visitor.zipCode,
      city: visitor.city,
      scannedAt: DateTime.now(),
      hashedString: hashedString,
    );

    await _addLead(newLead);
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

  // TODO: can be reused
  Map<String, dynamic>? _processAllUsersDataFromEventMap({
    required Map<String, dynamic> eventMap,
    required UserCategory userCategory,
  }) {
    try {
      final Map<String, dynamic> allUsersData =
          (eventMap[userCategory.name] as Map)
              .map((key, value) => MapEntry(key.toString(), value));
      return allUsersData;
    } catch (exception) {
      return null;
    }
  }

  // TODO: reusable functions like this can be moved to the repository
  Future<Map<String, dynamic>?> _fetchEventDataById(
    String eventId,
  ) async {
    Map<String, dynamic>? eventMap =
        await _realtimeRepository.fetchEventDataById(
      eventId,
    );
    return eventMap;
  }

  // TODO: can be made generic with RawUserData and reused here
  // and for the leadsController
  Future<RawVisitorData?> _processMapIntoExhibitorData({
    required Map<String, dynamic> eventMap,
    required String visitorId,
  }) async {
    final Map<String, dynamic>? allUsersMap = _processAllUsersDataFromEventMap(
      eventMap: eventMap,
      userCategory: UserCategory.visitor,
    );

    if (allUsersMap == null) return null;

    Map<String, dynamic>? userMap = _processUserDataByIdFromUsersMap(
      allUsersMap,
      visitorId,
    );

    if (userMap == null) return null;

    try {
      final visitor = RawVisitorData.fromMap(userMap);
      return visitor;
    } catch (exception) {
      return null;
    }
  }

  // TODO: can be reused
  Map<String, dynamic>? _processUserDataByIdFromUsersMap(
    Map<String, dynamic> usersMap,
    String userId,
  ) {
    if (!usersMap.containsKey(userId)) return null;

    try {
      Map<String, dynamic> userData =
          usersMap[userId]["data"] as Map<String, dynamic>;
      return userData;
    } catch (exception) {
      return null;
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
}
