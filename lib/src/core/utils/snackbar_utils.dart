import 'package:flutter/material.dart';

import '../constants/constants.dart';

void showSnackbar({
  required String message,
  IconData icon = Icons.info_outline_rounded,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppConstants.primaryBlueDarker,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
