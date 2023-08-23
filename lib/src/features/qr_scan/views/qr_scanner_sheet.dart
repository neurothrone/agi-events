import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/inactive_qr_scanner_content.dart';

const int kQrCodeRequiredLength = 40;

class QrScannerSheet extends StatefulWidget {
  const QrScannerSheet({
    super.key,
    required this.scanType,
    this.showAppBar = true,
    this.showPlaceholder = false,
    required this.onQrCodeScanned,
  });

  final ScanType scanType;
  final bool showAppBar;
  final bool showPlaceholder;
  final Function(String) onQrCodeScanned;

  @override
  State<QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<QrScannerSheet> {
  MobileScanner? _scanner;
  bool _isLoading = true;
  late bool _showPlaceholder;

  @override
  void initState() {
    super.initState();

    _showPlaceholder = widget.showPlaceholder;

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

  void _openScanner() {
    setState(() => _showPlaceholder = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.lighterBlack,
      appBar: widget.showAppBar && !_showPlaceholder
          ? AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                widget.scanType.title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
      body: _showPlaceholder
          ? InactiveQrScannerContent(onStartScanner: _openScanner)
          : _scanner == null || _isLoading
              ? const CenteredProgressIndicator()
              : _scanner,
    );
  }
}
