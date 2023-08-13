import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Loads and decodes a JSON file from the app's assets.
///
/// This function reads the content of a JSON file located at the specified
/// [assetPath], decodes it, and returns the resulting  [Map<String, dynamic>].
/// If an error occurs during the loading or decoding process, an empty map
/// is returned.
///
/// Parameters:
/// - [assetPath]: A string representing the path to the JSON asset file.
///
/// Returns:
/// - A [Map<String, dynamic>] containing the parsed JSON data.
///
/// Throws:
/// - An error if the file is not found or if the JSON is invalid.
/// However, in production mode, this error is caught and suppressed,
/// and an empty map is returned instead.
///
/// Example:
/// ```dart
/// final Map<String, dynamic> jsonData = await loadJsonFromAssets(
///   'assets/data.json',
/// );
/// ```
Future<Map<String, dynamic>> loadJsonFromAssets(String assetPath) async {
  try {
    String jsonString = await rootBundle.loadString(assetPath);
    return json.decode(jsonString) as Map<String, dynamic>;
  } catch (e) {
    if (kDebugMode) {
      debugPrint("❌ -> Failed to load json from file: $assetPath. Error: $e");
    }
    return {};
  }
}
