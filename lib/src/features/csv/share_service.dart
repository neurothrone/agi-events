import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService();
});

class ShareService {
  Future<void> shareFile({
    required File file,
    required String shareSheetText,
    Rect? sharePositionOrigin,
  }) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: shareSheetText,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
