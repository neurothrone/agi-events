import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../add_lead/data/leads_controller.dart';
import '../../qr_scan/data/qr_scan_controller.dart';
import '../widgets/lead_qr_scanner_button.dart';
import '../widgets/leads_csv_export_button.dart';
import '../widgets/leads_page_content.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({
    super.key,
    required this.event,
  });

  final Event event;

  Future<void> _openQrScanner(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await ref.read(qrScanControllerProvider).showQrScanner(
        scanType: ScanType.visitor,
        context: context,
        onQrCodeScanned: (String qrCode) async {
          await ref
              .read(leadsControllerProvider.notifier)
              .addLeadByQR(qrCode: qrCode, eventId: event.eventId);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          LeadsCsvExportButton(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: Platform.isIOS
            ? const EdgeInsets.only(bottom: 20.0)
            : EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer(
            builder: (context, ref, _) {
              return LeadQrScannerButton(
                onPressed: () => _openQrScanner(context, ref),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0),
        child: LeadsPageContent(
          event: event,
        ),
      ),
    );
  }
}
