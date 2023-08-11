import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isTextProminent = false,
    required this.foregroundColor,
    this.backgroundColor = Colors.black,
    this.elevation = 5.0,
    this.height = 45.0,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isTextProminent;
  final Color foregroundColor;
  final Color backgroundColor;
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
            fontWeight: isTextProminent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
