import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/primary_button.dart';

class LeadQrScannerButton extends StatelessWidget {
  const LeadQrScannerButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      label: "Scan new lead",
      icon: Icons.qr_code_scanner_rounded,
      height: 50.0,
      backgroundColor: AppConstants.primaryBlueLighter,
    );
  }
}
