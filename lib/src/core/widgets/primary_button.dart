import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'text_icon_row.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.width = double.infinity,
    this.height = 40.0,
    this.backgroundColor = AppConstants.primaryBlue,
    // this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.borderRadius = 10.0,
    this.useGradient = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    return useGradient
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: AppConstants.primaryGradient,
            ),
            width: width,
            height: height,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: foregroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: icon != null
                  ? TextIconRow(icon: icon, label: label)
                  : Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
            ),
          )
        : SizedBox(
            width: width,
            height: height,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: icon != null
                  ? TextIconRow(icon: icon, label: label)
                  : Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
            ),
          );
  }
}
