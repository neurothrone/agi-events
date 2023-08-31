import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import 'custom_filled_button.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.cancelText,
    required this.confirmText,
    this.cancelForegroundColor = Colors.white,
    this.confirmForegroundColor = Colors.white,
    required this.cancelBackgroundColor,
    required this.confirmBackgroundColor,
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
  final Color cancelForegroundColor;
  final Color confirmForegroundColor;
  final Color cancelBackgroundColor;
  final Color confirmBackgroundColor;
  final bool isCancelProminent;
  final bool isConfirmProminent;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      shadowColor: backgroundColor,
      elevation: AppDimensions.elevation,
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
      contentPadding: const EdgeInsets.all(AppSizes.s20),
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
                backgroundColor: cancelBackgroundColor,
                foregroundColor: cancelForegroundColor,
                isTextProminent: isCancelProminent,
              ),
            ),
            const SizedBox(width: AppSizes.s20),
            Expanded(
              child: CustomFilledButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                text: confirmText,
                backgroundColor: confirmBackgroundColor,
                foregroundColor: confirmForegroundColor,
                isTextProminent: isConfirmProminent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
