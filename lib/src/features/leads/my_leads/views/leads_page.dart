import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/lead.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../add_lead/data/leads_controller.dart';
import '../../qr_scanning/qr_scanner.dart';
import '../widgets/leads_page_content.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({
    super.key,
    required this.eventId,
    required this.imageAsset,
  });

  final String eventId;
  final String imageAsset;

  void _shareLeads() {}

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

    // Scanned Exhibitor id: 0038045b6a04c9fe5172b1e950be054bb438e4af
    // Scanned Visitor id: 01a16aec47fcdec439b7499c85a50fbf774085d7
    debugPrint("ℹ️ -> QR Code: $qrCode");

    // TODO: ref.read(provider)... getById and add to leads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (context, WidgetRef ref, child) {
              final List<Lead>? leads =
                  ref.watch(leadsControllerProvider).value;

              return IconButton(
                onPressed:
                    leads != null && leads.isNotEmpty ? _shareLeads : null,
                icon: Icon(
                  Platform.isIOS ? CupertinoIcons.share : Icons.share,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: Platform.isIOS
            ? const EdgeInsets.only(bottom: 20.0)
            : EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer(
            builder: (context, WidgetRef ref, child) {
              return PrimaryButton(
                onPressed: () => _scanNewLead(context, ref),
                label: "Scan new lead",
                height: 50.0,
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0),
        child: LeadsPageContent(
          eventId: eventId,
          imageAsset: imageAsset,
        ),
      ),
    );
  }
}
