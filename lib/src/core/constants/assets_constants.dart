class AssetsConstants {
  const AssetsConstants._();

  static const String fakeRealtimeJson = "assets/data/fake-database-data.json";
  static const String eventsJson = "assets/data/events.json";

  static const String _imagesBasePath = "assets/images";

  static String imagePath(String imageName) => "$_imagesBasePath$imageName";
}
