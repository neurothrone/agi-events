import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.primaryBlue,
      elevation: 5.0,
      title: const Text(
        "You have unsaved changes",
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "Do you want to save them?",
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          style: FilledButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.black,
          ),
          child: const Text(
            "Discard",
            style: TextStyle(
              color: AppConstants.destructive,
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: FilledButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.black,
          ),
          child: const Text(
            "Save",
            style: TextStyle(
              color: AppConstants.secondaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}
