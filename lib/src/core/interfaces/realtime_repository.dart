import '../models/models.dart';

abstract class RealtimeRepository {
  Future<RawExhibitorData?> fetchExhibitorById({
    required String exhibitorId,
    required Event event,
  });

  Future<RawVisitorData?> fetchVisitorById({
    required String visitorId,
    required Event event,
  });
}
