class AssetsConstants {
  const AssetsConstants._();

  static const String _dataBasePath = "assets/data";
  static const String _imagesBasePath = "assets/images";

  static const String fakeRealtimeJson =
      "$_dataBasePath/fake-database-data.json";
  static const String eventsJson = "$_dataBasePath/events.json";

  static String imagePath(String imageName) =>
      "$_imagesBasePath/$imageName.svg";
}
