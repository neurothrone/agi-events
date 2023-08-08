import 'package:flutter/material.dart';

void showSnackbar({
  required String message,
  IconData icon = Icons.info_outline_rounded,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
