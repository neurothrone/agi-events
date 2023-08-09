import '../../models/models.dart';

abstract class RealtimeRepository {
  Future<T?> fetchUserById<T extends RawUserData>({
    required String userId,
    required Event event,
  });

  Future<RawExhibitorData?> fetchExhibitorById({
    required String exhibitorId,
    required Event event,
  });
  Future<RawVisitorData?> fetchVisitorById({
    required String visitorId,
    required Event event,
  });
}
