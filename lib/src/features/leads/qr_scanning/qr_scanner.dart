import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatelessWidget {
  const QrScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      // fit: BoxFit.contain,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        // final Uint8List? image = capture.image;
        // for (final barcode in barcodes) {
        //   debugPrint("ℹ️ -> ${barcode.rawValue}");
        // }

        final String? qrData = barcodes.firstOrNull?.rawValue;
        Navigator.pop(context, qrData);
      },
    );
  }
}
