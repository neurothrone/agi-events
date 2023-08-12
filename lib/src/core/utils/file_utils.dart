import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadJsonFromAssets(String assetPath) async {
  try {
    String jsonString = await rootBundle.loadString(assetPath);
    return json.decode(jsonString) as Map<String, dynamic>;
  } catch (_) {
    debugPrint("❌ -> Failed to load json from file: $assetPath.");
    return {};
  }
}
