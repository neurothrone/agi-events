import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

// "Scan your exhibitor badge"
// "Scan a visitor badge"

class QrScannerSheet extends StatelessWidget {
  const QrScannerSheet({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final String? qrData = barcodes.firstOrNull?.rawValue;
          Navigator.pop(context, qrData);
        },
      ),
    );
  }
}
