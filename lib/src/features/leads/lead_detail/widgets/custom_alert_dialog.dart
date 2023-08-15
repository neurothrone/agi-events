import 'package:flutter/material.dart';

import 'custom_filled_button.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.cancelText,
    required this.confirmText,
    required this.cancelColor,
    required this.confirmColor,
    this.isCancelProminent = false,
    this.isConfirmProminent = false,
    required this.onCancel,
    required this.onConfirm,
  });

  final String title;
  final String content;
  final Color backgroundColor;

  final String cancelText;
  final String confirmText;
  final Color cancelColor;
  final Color confirmColor;
  final bool isCancelProminent;
  final bool isConfirmProminent;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
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
      contentPadding: const EdgeInsets.all(20.0),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomFilledButton(
                onPressed: () {
                  onCancel();
                  Navigator.pop(context);
                },
                text: cancelText,
                backgroundColor: cancelColor,
                foregroundColor: Colors.white,
                isTextProminent: isCancelProminent,
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: CustomFilledButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                text: confirmText,
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                isTextProminent: isConfirmProminent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
