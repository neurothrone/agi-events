/// A utility class that provides constants and helper methods related
/// to asset paths.
///
/// This class centralizes paths and constants for easier management and
/// access of assets, especially images and data files in the project.
class AssetsConstants {
  /// A utility class, not meant to be instantiated or extended;
  /// hence the private constructor.
  const AssetsConstants._();

  static const String _dataBasePath = "assets/data";
  static const String _imagesBasePath = "assets/images/events";

  /// The path to the `mock-realtime-data.json` file in assets
  static const String mockRealtimeJson =
      "$_dataBasePath/mock-realtime-data.json";

  /// The path to the `events.json` file in assets
  static const String eventsJson = "$_dataBasePath/events.json";

  /// Returns the asset path for a given image name.
  ///
  /// Parameters:
  /// - [imageName]: The name of the image (without the file extension).
  ///
  /// Returns:
  /// A string representing the full asset path to the image.
  ///
  /// Example:
  /// ```dart
  /// // This would return 'assets/images/exampleImage.svg'
  /// final assetPath = imagePath("exampleImage");
  /// ```
  static String imagePath(String imageName) =>
      "$_imagesBasePath/$imageName.svg";
}
