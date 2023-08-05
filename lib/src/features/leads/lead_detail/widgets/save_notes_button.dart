import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../add_lead/data/leads_controller.dart';

class SaveNotesButton extends ConsumerWidget {
  const SaveNotesButton({
    super.key,
    required this.lead,
    required this.notesController,
  });

  final Lead lead;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(leadsControllerProvider.notifier).updateLeadNotes(
              lead.copyWith(notes: notesController.text),
            );
        Navigator.of(context).pop();
      },
      child: Text(
        "Save",
        style: TextStyle(
          fontSize: 18.0,
          color: AppConstants.primaryBlueLightest,
        ),
      ),
    );
  }
}
