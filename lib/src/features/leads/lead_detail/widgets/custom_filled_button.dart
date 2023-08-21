import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isTextProminent = false,
    this.backgroundColor = Colors.black,
    required this.foregroundColor,
    this.elevation = AppDimensions.elevation,
    this.height = AppSizes.s48,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isTextProminent;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          elevation: elevation,
          backgroundColor: backgroundColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 16.0,
            fontWeight: isTextProminent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
