import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import 'ripple_animation.dart';
import 'rounded_qr_button.dart';

class InactiveQrScannerContent extends StatelessWidget {
  const InactiveQrScannerContent({
    super.key,
    required this.onStartScanner,
  });

  final VoidCallback onStartScanner;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RippleAnimation(
            color: AppConstants.primaryBlueLighter,
            child: RoundedQrButton(
              onTap: onStartScanner,
            ),
          ),
          const SizedBox(height: AppSizes.s20),
          const Text(
            "Press to get started",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
