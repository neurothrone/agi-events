import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/utils.dart';
import '../views/qr_scanner_sheet.dart';

final qrScanControllerProvider = Provider<QrScanController>((ref) {
  return QrScanController();
});

class QrScanController {
  Future<void> showQrScanner({
    required ScanType scanType,
    required BuildContext context,
    Function(String)? onQrCodeScanned,
  }) async {
    await showCustomBottomSheet(
      context: context,
      child: QrScannerSheet(
        scanType: scanType,
        onQrCodeScanned: (String qrCode) {
          if (onQrCodeScanned != null) {
            debugPrint("ℹ️ -> QR Code scanned: $qrCode");
            onQrCodeScanned(qrCode);
          }
        },
      ),
    );
  }
}
