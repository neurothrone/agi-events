import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../qr_scan/data/qr_scan_controller.dart';
import '../../shared/data/leads_controller.dart';

class QrScannerButton extends ConsumerWidget {
  const QrScannerButton({
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
            final Lead? newLead =
                await ref.read(leadsControllerProvider.notifier).addLeadByQR(
                      qrCode: qrCode,
                      event: event,
                      onError: (String errorMessage) {
                        showSnackbar(
                          message: errorMessage,
                          context: context,
                        );
                      },
                    );

            // Pop the QrScannerSheet and navigate directly to LeadDetailPage
            // with the new Lead
            if (newLead != null && context.mounted) {
              context.pop();
              context.pushNamed(AppRoute.leadDetail.name, extra: newLead);
            }
          },
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      minimum: Platform.isIOS
          ? const EdgeInsets.only(bottom: 20.0)
          : EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PrimaryButton(
          onPressed: () => _openQrScanner(context, ref),
          label: "Scan new lead",
          icon: Icons.qr_code_scanner_rounded,
          height: 50.0,
          backgroundColor: AppConstants.primaryBlueLighter,
        ),
      ),
    );
  }
}
