import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'enums/snackbar_type.dart';

extension UI on SnackbarType {
  Color get color => switch (this) {
        SnackbarType.info => Colors.white,
        SnackbarType.success => Colors.greenAccent,
        SnackbarType.warning => Colors.yellowAccent,
        SnackbarType.error => AppConstants.destructive,
      };

  IconData get icon => switch (this) {
        SnackbarType.success => Icons.check_circle_outline_rounded,
        _ => Icons.info_outline,
      };
}

void showSnackbar({
  required String message,
  SnackbarType snackbarType = SnackbarType.info,
  Color backgroundColor = Colors.black,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: snackbarType.color, width: 0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3.0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            snackbarType.icon,
            color: snackbarType.color,
            size: 20.0,
          ),
          const SizedBox(width: 6.0),
          Text(
            message,
            style: TextStyle(
              color: snackbarType.color,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    ),
  );
}
