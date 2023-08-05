import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/assets_constants.dart';
import '../../utils/file_utils.dart';

final fakeDataFutureProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final localJsonData = await loadJsonFromAssets(AssetsConstants.localJsonData);
  return localJsonData;
});
