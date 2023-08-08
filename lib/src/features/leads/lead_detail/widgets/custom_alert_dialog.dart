import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
    required this.cancelColor,
    required this.confirmColor,
    required this.onCancel,
    required this.onConfirm,
  });

  final String title;
  final String content;

  final String cancelText;
  final String confirmText;
  final Color cancelColor;
  final Color confirmColor;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.primaryBlue,
      elevation: 5.0,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 18.0,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        FilledButton(
          onPressed: () {
            onCancel();
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.black,
          ),
          child: Text(
            cancelText,
            style: TextStyle(
              color: cancelColor,
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.black,
          ),
          child: Text(
            confirmText,
            style: TextStyle(
              color: confirmColor,
            ),
          ),
        ),
      ],
    );
  }
}
