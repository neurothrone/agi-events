import 'package:flutter/foundation.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../interfaces/repositories/realtime_repository.dart';
import '../../models/models.dart';
import '../../utils/enums/enums.dart';
import '../data/providers.dart';

final firebaseRealtimeRepositoryProvider =
    Provider<FirebaseRealtimeRepository>((ref) {
  final FirebaseDatabase database = ref.watch(firebaseDatabaseProvider);
  return FirebaseRealtimeRepository(database: database);
});

class FirebaseRealtimeRepository implements RealtimeRepository {
  FirebaseRealtimeRepository({required FirebaseDatabase database})
      : _database = database;

  final FirebaseDatabase _database;

  @override
  Future<RawExhibitorData?> fetchExhibitorById({
    required String exhibitorId,
    required Event event,
  }) async {
    final data = await _fetchDataById(
      userCategory: UserCategory.exhibitor,
      userId: exhibitorId,
      event: event,
    );

    if (data != null) {
      return RawExhibitorData.fromMap(data);
    }
    return null;
  }

  @override
  Future<RawVisitorData?> fetchVisitorById({
    required String visitorId,
    required Event event,
  }) async {
    final data = await _fetchDataById(
      userCategory: UserCategory.visitor,
      userId: visitorId,
      event: event,
    );

    if (data != null) {
      return RawVisitorData.fromMap(data);
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
      debugPrint(
        "❌ -> Failed to fetch data with reference: "
        "${reference.toString()}. Error: $e",
      );
      return null;
    }
  }
}
