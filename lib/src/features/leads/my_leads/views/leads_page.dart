import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import '../widgets/lead_qr_scanner_button.dart';
import '../widgets/leads_csv_export_button.dart';
import '../widgets/leads_page_content.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({
    super.key,
    required this.event,
  });

  final Event event;

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
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: LeadQrScannerButton(),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0),
        child: LeadsPageContent(
          eventId: event.eventId,
          imageAsset: "assets/images/${event.image}.svg",
        ),
      ),
    );
  }
}
