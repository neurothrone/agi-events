import 'package:flutter/foundation.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../interfaces/repositories/realtime_repository.dart';
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
  Future<bool> eventExists(String eventId) async {
    List<String> eventIds = await fetchEventIds();
    return eventIds.contains(eventId);
  }

  @override
  Future<Map<String, dynamic>?> fetchEventDataById(String eventId) async {
    final DatabaseReference reference = _database.ref(eventId);

    try {
      DataSnapshot snapshot = await reference.get();

      if (snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map;
        return data.map((key, value) => MapEntry(key.toString(), value));
      }
      return null;
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Failed to fetchEventDataById() with reference: "
        "${reference.toString()}. Error: $exception",
      );
      return null;
    }
  }

  @override
  Future<List<String>> fetchEventIds() async {
    final DatabaseReference reference = _database.ref();

    try {
      DataSnapshot snapshot = await reference.get();

      if (snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.keys.map((key) => key.toString()).toList();
      }
      return [];
    } catch (exception, stacktrace) {
      debugPrint(
        "❌ -> Failed to fetchEvents() with top-level reference. "
        "Error: $exception",
      );
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> fetchEventsData() {
    // TODO: implement fetchEventsData
    throw UnimplementedError();
  }
}
