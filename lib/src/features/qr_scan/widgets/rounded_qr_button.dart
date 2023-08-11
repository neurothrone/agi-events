import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class RoundedQrButton extends StatelessWidget {
  const RoundedQrButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppConstants.primaryBlue,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        splashColor: AppConstants.primaryBlue,
        // borderRadius needs to be half of Container's width and height
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          width: 100.0,
          height: 100.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
