import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

class QrScannerButton extends StatelessWidget {
  const QrScannerButton({
    super.key,
    this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      label: label,
      icon: Icons.qr_code_scanner_rounded,
      height: 50.0,
      backgroundColor: AppConstants.primaryBlueLighter,
    );
  }
}
