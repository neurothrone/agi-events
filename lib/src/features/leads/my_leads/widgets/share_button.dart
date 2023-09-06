import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/utils.dart';
import '../../shared/data/leads_controller.dart';

class ShareButton extends ConsumerWidget {
  const ShareButton({
    super.key,
    required this.event,
  });

  final Event event;

  Future<void> _shareLeads(
    BuildContext context,
    WidgetRef ref,
  ) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Lead>? leads = ref.watch(leadsControllerProvider).value;

    return IconButton(
      onPressed: leads != null && leads.isNotEmpty
          ? () => _shareLeads(context, ref)
          : null,
      padding: EdgeInsets.zero,
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share_rounded,
        color: AppConstants.primaryBlueLightest,
        semanticLabel: "Share CSV",
      ),
      tooltip: "Share CSV",
    );
  }
}
