import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isThisDeviceIpad() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo info = await deviceInfo.iosInfo;
  return info.model.toLowerCase().contains("ipad");
}
