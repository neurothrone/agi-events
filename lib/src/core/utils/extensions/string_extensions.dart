import 'package:flutter/foundation.dart';

extension DateTimeFromString on String {
  /// Returns the [String] converted to a [DateTime] if possible to parse
  /// else the current date & time using the `now` constructor of [DateTime].
  DateTime toDateTime() {
    if (isEmpty) return DateTime.now();

    // Modify String to conform to a subset of ISO 8601,
    // which the DateTime.parse method recognizes.
    final conformingString = replaceAll("/", "-");

    try {
      DateTime dateTime = DateTime.parse(conformingString);
      return dateTime;
    } catch (e) {
      debugPrint("❌ -> Failed to parse date String into a DateTime");
      return DateTime.now();
    }
  }
}
