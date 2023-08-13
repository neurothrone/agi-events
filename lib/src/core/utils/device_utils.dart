import 'package:flutter/foundation.dart';

import 'package:device_info_plus/device_info_plus.dart';

/// Determines if the current device is an iPad.
///
/// This function checks if the app is running on an iOS device and
/// specifically on an iPad model. If the app is running on the web
/// or another platform, it immediately returns `false`.
///
/// Returns:
/// - `true` if the device is an iPad.
/// - `false` otherwise or if the platform is web.
///
/// Example:
/// ```dart
/// final bool isIpad = await isThisDeviceIpad();
/// ```
Future<bool> isThisDeviceIpad() async {
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS)) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    return info.model.toLowerCase().contains("ipad");
  }
  return false;
}
