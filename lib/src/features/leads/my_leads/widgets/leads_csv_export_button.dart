import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../../../core/models/models.dart';
import '../../add_lead/data/leads_controller.dart';

class LeadsCsvExportButton extends ConsumerWidget {
  const LeadsCsvExportButton({super.key});

  Future<void> _shareLeads(BuildContext context, WidgetRef ref) async {
    if (Platform.isIOS) {
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      final bool isIpad = await isThisDeviceIpad();

      // Only iPad devices
      if (isIpad) {
        ref.read(leadsControllerProvider.notifier).exportLeads(
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            );
        return;
      }
    }

    // Android and iOS devices
    ref.read(leadsControllerProvider.notifier).exportLeads();
  }

  Future<bool> isThisDeviceIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    return info.model.toLowerCase().contains("ipad");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Lead>? leads = ref.watch(leadsControllerProvider).value;

    return IconButton(
      onPressed: leads != null && leads.isNotEmpty
          ? () => _shareLeads(context, ref)
          : null,
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share,
      ),
    );
  }
}
