import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';
import '../../add_lead/data/leads_controller.dart';

class LeadsCsvExportButton extends ConsumerWidget {
  const LeadsCsvExportButton({super.key});

  Future<void> _shareLeads(WidgetRef ref) async {
    ref.read(leadsControllerProvider.notifier).exportLeads();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Lead>? leads = ref.watch(leadsControllerProvider).value;

    return IconButton(
      onPressed:
          leads != null && leads.isNotEmpty ? () => _shareLeads(ref) : null,
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share,
      ),
    );
  }
}
