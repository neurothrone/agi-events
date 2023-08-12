class AssetsConstants {
  const AssetsConstants._();

  static const String _dataBasePath = "assets/data";
  static const String _imagesBasePath = "assets/images/events";

  static const String mockRealtimeJson =
      "$_dataBasePath/mock-realtime-data.json";
  static const String eventsJson = "$_dataBasePath/events.json";

  static String imagePath(String imageName) =>
      "$_imagesBasePath/$imageName.svg";
}
