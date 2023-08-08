import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/utils.dart';

final eventsFutureProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final Map<String, dynamic> eventsJson = await loadJsonFromAssets(
    AssetsConstants.eventsJson,
  );
  return eventsJson;
});

final eventsDataProvider = Provider<List<Event>>((ref) {
  final AsyncValue<Map<String, dynamic>> eventsJson = ref.watch(
    eventsFutureProvider,
  );

  // Check if data is available
  if (eventsJson is AsyncData<Map<String, dynamic>>) {
    // Data is available
    List<Map<String, dynamic>> listOfEventMap = _processEventsDataFromJson(
      eventsJson.value,
    );

    List<Event> events = listOfEventMap
        .map((Map<String, dynamic> eventMap) => Event.fromMap(eventMap))
        .toList();

    return events;
  } else {
    // Data is not yet available
    return [];
  }
});

List<Map<String, dynamic>> _processEventsDataFromJson(
  Map<String, dynamic> json,
) {
  return json
      .map(
        (key, value) => MapEntry(key.toString(), value),
      )
      .values
      .whereType<Map<dynamic, dynamic>>()
      .map(
        (eventMap) => (eventMap).map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      )
      .toList();
}
