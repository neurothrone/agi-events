import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../utils/utils.dart';

final fakeRealtimeDataFutureProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final Map<String, dynamic> realtimeData = await loadJsonFromAssets(
    AssetsConstants.fakeRealtimeJson,
  );
  return realtimeData;
});
