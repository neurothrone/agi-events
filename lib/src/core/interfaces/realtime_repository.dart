import '../models/models.dart';

/// An abstract repository defining the necessary operations for
/// fetching real-time data.
///
/// This class serves as a contract that concrete implementations
/// must adhere to, ensuring consistent behavior across different
/// real-time data sources.
abstract class RealtimeRepository {
  /// Fetches the data of an exhibitor based on their unique ID and
  /// the associated event.
  ///
  /// Parameters:
  /// - [exhibitorId]: The unique identifier for the exhibitor.
  /// - [event]: The event context within which the exhibitor data
  /// should be fetched.
  ///
  /// Returns:
  /// A `Future` resolving to [RawExhibitorData] or `null` if no
  /// data is found.
  Future<RawExhibitorData?> fetchExhibitorById({
    required String exhibitorId,
    required Event event,
  });

  /// Fetches the data of a visitor based on their unique ID and the
  /// associated event.
  ///
  /// Parameters:
  /// - [visitorId]: The unique identifier for the visitor.
  /// - [event]: The event context within which the visitor data
  /// should be fetched.
  ///
  /// Returns:
  /// A `Future` resolving to [RawVisitorData] or `null` if no
  /// data is found.
  Future<RawVisitorData?> fetchVisitorById({
    required String visitorId,
    required Event event,
  });
}
