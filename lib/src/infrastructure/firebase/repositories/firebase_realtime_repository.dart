import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/interfaces/realtime_repository.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/utils.dart';
import '../data/providers.dart';

final firebaseRealtimeRepositoryProvider = Provider<RealtimeRepository>((ref) {
  final FirebaseDatabase database = ref.watch(firebaseDatabaseProvider);
  return FirebaseRealtimeRepository(database: database);
});

class FirebaseRealtimeRepository implements RealtimeRepository {
  FirebaseRealtimeRepository({
    required FirebaseDatabase database,
  }) : _database = database;

  final FirebaseDatabase _database;

  @override
  Future<RawExhibitorData?> fetchExhibitorById({
    required String exhibitorId,
    required Event event,
  }) async {
    try {
      final data = await _fetchDataById(
        userCategory: UserCategory.exhibitor,
        userId: exhibitorId,
        event: event,
      );

      if (data != null) {
        return RawExhibitorData.fromMap(data);
      }
    } catch (e) {
      if (e is RealtimeException) {
        rethrow;
      }
    }

    return null;
  }

  @override
  Future<RawVisitorData?> fetchVisitorById({
    required String visitorId,
    required Event event,
  }) async {
    try {
      final data = await _fetchDataById(
        userCategory: UserCategory.visitor,
        userId: visitorId,
        event: event,
      );

      if (data != null) {
        return RawVisitorData.fromMap(data);
      }
    } catch (e) {
      if (e is RealtimeException) {
        rethrow;
      }
    }

    return null;
  }

  Future<Map<String, dynamic>?> _fetchDataById({
    required UserCategory userCategory,
    required String userId,
    required Event event,
  }) async {
    final DatabaseReference reference =
        _database.ref(event.eventId).child(userCategory.name).child(userId);

    try {
      DataSnapshot snapshot = await reference.get();

      if (snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map;

        final Map<String, dynamic> dataMap = (data["data"] as Map).map(
          (key, value) => MapEntry(key.toString(), value),
        );
        final userMap = dataMap.map(
          (key, value) => MapEntry(key.toString(), value),
        );

        return userMap;
      }
      return null;
    } catch (e) {
      if (e is FirebaseException && e.code == "permission-denied") {
        throw RealtimeException(
          error: RealtimeError.noInternetConnection,
          message: RealtimeError.noInternetConnection.message,
        );
      }

      if (kDebugMode) {
        debugPrint(
          "❌ -> Failed to fetch data with reference: "
          "${reference.toString()}. Error: $e",
        );
      }
      return null;
    }
  }
}
