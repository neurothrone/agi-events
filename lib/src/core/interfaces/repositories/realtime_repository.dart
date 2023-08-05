abstract class RealtimeRepository {
  Future<bool> eventExists(String eventId);

  Future<List<String>> fetchEvents();

  Future<Map<String, dynamic>?> fetchEventDataById(String eventId);
}
