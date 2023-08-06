abstract class RealtimeRepository {
  Future<bool> eventExists(String eventId);

  Future<Map<String, dynamic>> fetchEventsData();

  Future<List<String>> fetchEventIds();

  Future<Map<String, dynamic>?> fetchEventDataById(String eventId);
}
