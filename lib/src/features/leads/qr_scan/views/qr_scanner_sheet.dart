import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/enums/snackbar_type.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/widgets.dart';

const int kQrCodeRequiredLength = 40;

class QrScannerSheet extends StatefulWidget {
  const QrScannerSheet({
    super.key,
    required this.scanType,
    required this.onQrCodeScanned,
  });

  final ScanType scanType;
  final Function(String) onQrCodeScanned;

  @override
  State<QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<QrScannerSheet> {
  MobileScanner? _scanner;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScanner();
    });
  }

  void _loadScanner() {
    _scanner = MobileScanner(
      controller: MobileScannerController(
        facing: CameraFacing.back,
        detectionSpeed: DetectionSpeed.normal,
        detectionTimeoutMs: 1000,
      ),
      onDetect: (BarcodeCapture capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        final String? qrCode = barcodes.firstOrNull?.rawValue;

        if (qrCode == null || qrCode.length != kQrCodeRequiredLength) {
          showSnackbar(
            message: "That is not a valid QR Code",
            snackbarType: SnackbarType.warning,
            context: context,
          );
          return;
        }

        _disposeAfterScan(qrCode);
      },
    );

    setState(() => _isLoading = false);
  }

  Future<void> _disposeAfterScan(String qrCode) async {
    setState(() => _scanner = null);

    final navigator = Navigator.of(context);
    await Future.delayed(const Duration(milliseconds: 500));

    widget.onQrCodeScanned(qrCode);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.scanType.title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _scanner == null || _isLoading
          ? const CenteredProgressIndicator()
          : _scanner,
    );
  }
}
