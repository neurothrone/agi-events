import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';

Future<Map<String, dynamic>> loadJsonFromAssets(String assetPath) async {
  try {
    String jsonString = await rootBundle.loadString(assetPath);
    return json.decode(jsonString) as Map<String, dynamic>;
  } catch (_) {
    debugPrint("❌ -> Failed to load json from file: $assetPath.");
    return {};
  }
}

void loadTestDataFromAssets() {
  final prettyPrint = JsonEncoder.withIndent(" " * 2);
  loadJsonFromAssets(AssetsConstants.fakeRealtimeJson)
      // .then((Map<String, dynamic> data) => debugPrint(data.toString()))
      .then(
        (Map<String, dynamic> data) => debugPrint(prettyPrint.convert(data)),
      )
      .onError(
        (error, stackTrace) => debugPrint("❌ -> Error loading json."),
      );
}
