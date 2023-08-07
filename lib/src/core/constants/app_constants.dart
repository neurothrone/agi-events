import 'package:flutter/material.dart';

class AppConstants {
  // Strings
  static const String appTitle = "AGI Events";

  // Dimensions
  static const double borderRadius = 10.0;

  // Colors
  static const Color dodgerBlue = Color(0xFF1E90FF);
  static const Color darkSlateBlue = Color(0xFF483D8B);

  static const Color primaryBlue = darkSlateBlue;
  static const Color secondaryBlue = dodgerBlue;

  static const Color destructive = Color(0xFFCD5C5C);

  // Color.lerp() will only return null if both colors passed to it are null
  static Color primaryBlueLighter = Color.lerp(
        primaryBlue,
        Colors.white,
        0.1,
      ) ??
      primaryBlue;
  static Color primaryBlueLightest = Color.lerp(
        primaryBlue,
        Colors.white,
        0.3,
      ) ??
      primaryBlue;
  static Color lighterBlack = Color.lerp(
        Colors.black,
        Colors.white,
        0.1,
      ) ??
      Colors.black;

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primaryBlue,
      secondaryBlue,
    ],
  );
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primaryBlue,
      secondaryBlue,
    ],
  );
}
