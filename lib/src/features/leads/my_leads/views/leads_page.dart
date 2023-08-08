import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../add_lead/views/add_lead_sheet.dart';
import '../../qr_scan/data/qr_scan_controller.dart';
import '../data/leads_controller.dart';
import '../widgets/qr_scanner_button.dart';
import '../widgets/leads_page_content.dart';
import '../widgets/share_button.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({
    super.key,
    required this.event,
  });

  final Event event;

  static MaterialPageRoute<void> route({required Event event}) =>
      MaterialPageRoute(
        builder: (context) => LeadsPage(
          event: event,
        ),
      );

  void _showAddLeadSheet(BuildContext context) {
    showCustomBottomSheet(
      context: context,
      child: AddLeadSheet(event: event),
    );
  }

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
                .addLeadByQR(qrCode: qrCode, event: event, context: context);
          },
        );
  }

  Future<void> _shareLeads(BuildContext context, WidgetRef ref) async {
    if (Platform.isIOS) {
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      final bool isIpad = await isThisDeviceIpad();

      // Only iPad devices
      if (isIpad) {
        ref.read(leadsControllerProvider.notifier).exportLeads(
              event: event,
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            );
        return;
      }
    }

    // Android and iOS devices
    ref.read(leadsControllerProvider.notifier).exportLeads(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomCupertinoAppBar(
                trailing: Consumer(builder: (context, ref, _) {
                  final List<Lead>? leads =
                      ref.watch(leadsControllerProvider).value;

                  return ShareButton(
                    onPressed: leads != null && leads.isNotEmpty
                        ? () => _shareLeads(context, ref)
                        : null,
                  );
                }),
              ),
            )
          : AppBar(
              actions: [
                Consumer(builder: (context, ref, _) {
                  final List<Lead>? leads =
                      ref.watch(leadsControllerProvider).value;

                  return ShareButton(
                    onPressed: leads != null && leads.isNotEmpty
                        ? () => _shareLeads(context, ref)
                        : null,
                  );
                }),
              ],
            ),
      bottomNavigationBar: SafeArea(
        minimum: Platform.isIOS
            ? const EdgeInsets.only(bottom: 20.0)
            : EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer(builder: (context, ref, _) {
            return QrScannerButton(
              onPressed: () => _openQrScanner(context, ref),
              label: "Scan new lead",
            );
          }),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0),
        child: LeadsPageContent(
          onAddPressed: () => _showAddLeadSheet(context),
          event: event,
        ),
      ),
    );
  }
}
