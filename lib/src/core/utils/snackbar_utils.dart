import 'package:flutter/material.dart';

import '../constants/constants.dart';

void showSnackbar({
  required String message,
  IconData icon = Icons.info_outline_rounded,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppConstants.primaryBlueDarker,
      elevation: AppDimensions.elevation,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: AppSizes.s20,
          ),
          const SizedBox(width: AppSizes.s8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
