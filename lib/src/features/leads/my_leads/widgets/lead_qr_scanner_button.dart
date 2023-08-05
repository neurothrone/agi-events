import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/primary_button.dart';
import '../../qr_scanning/qr_scanner.dart';

class LeadQrScannerButton extends ConsumerWidget {
  const LeadQrScannerButton({super.key});

  Future<void> _scanNewLead(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final String? qrCode = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.9,
          child: QrScanner(),
        );
      },
    );

    // TODO: validate if QR Code is compatible
    // if not null and valid
    if (qrCode != null) {
      // TODO: fetch Visitor from Event data
      // TODO: convert to Lead and save
    }

    // Scanned Exhibitor id: 0038045b6a04c9fe5172b1e950be054bb438e4af
    // Scanned Visitor id: 01a16aec47fcdec439b7499c85a50fbf774085d7
    debugPrint("ℹ️ -> QR Code: $qrCode");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      onPressed: () => _scanNewLead(context, ref),
      label: "Scan new lead",
      height: 50.0,
    );
  }
}
