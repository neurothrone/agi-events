import 'package:flutter/material.dart';

/// A utility class that provides app-wide constants.
///
/// This class centralizes constants used across the app, including colors,
/// durations, and other design or functional constants. By keeping them
/// in one place, it ensures consistency and easier maintenance.
class AppConstants {
  /// A utility class, not meant to be instantiated or extended;
  /// hence the private constructor.
  const AppConstants._();

  // region Strings

  static const String appTitle = "AGI Events";

  // endregion

  // region Misc

  /// The amount of time (seconds) a request to Firebase should
  /// be allowed to take before timing out
  static const int timeoutSeconds = 5;

  // endregion

  // region Dimensions

  static const double borderRadius = 10.0;

  // endregion

  // region Colors

  static const Color darkSlateBlue = Color(0xFF483D8B);
  static const Color dodgerBlue = Color(0xFF1E90FF);

  /// Primary color used throughout the app.
  static const Color primaryBlue = darkSlateBlue;

  /// Secondary color used throughout the app.
  static const Color secondaryBlue = dodgerBlue;

  /// Represents a color used for destructive actions.
  /// Chosen to be closer to "indian-red" in order to provide good contrast
  /// against black backgrounds and harmonize with a primary color theme
  /// of "Dark Slate Blue".
  static const Color destructive = Color(0xFFCD5C5C);

  /// Represents a variation of "Dark Slate Blue" that's made lighter.
  /// This is achieved by blending the primary blue with white.
  static Color primaryBlueLighter = Color.lerp(
        // Color.lerp() will only return null if both colors passed
        // to it are null
        primaryBlue,
        Colors.white,
        0.1,
      ) ??
      primaryBlue;

  /// Represents a variation of "Dark Slate Blue" that's made even
  /// lighter than `primaryBlueLighter`. This is achieved by blending
  /// the primary blue with a higher proportion of white.
  static Color primaryBlueLightest = Color.lerp(
        primaryBlue,
        Colors.white,
        0.3,
      ) ??
      primaryBlue;

  /// Represents a variation of "Dark Slate Blue" that's darker than the
  /// original `primaryBlue`. This is achieved by reducing the lightness
  /// of the primary blue by 15%.
  static Color primaryBlueDarker = darken(primaryBlue, 0.15);

  /// Use this color for sheets (e.g., Add Lead Sheet and QR Scanner Sheet)
  /// to enhance contrast against black backgrounds. This is especially
  /// beneficial for screens on devices with larger widths.
  static Color lighterBlack = Color.lerp(
        Colors.black,
        Colors.white,
        0.1,
      ) ??
      Colors.black;

  // endregion

  // region Gradients

  /// A linear gradient of the Primary Blue and Secondary Blue colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primaryBlue,
      secondaryBlue,
    ],
  );

  // endregion

  // region Utility

  /// Darkens the provided [color] by a specified [amount].
  ///
  /// The function works by converting the RGB color to HSL format, then
  /// reducing its lightness. The lightness is decreased by the provided
  /// [amount], which defaults to `0.1` (or 10%). The resulting color is
  /// then converted back to RGB format.
  ///
  /// Parameters:
  /// - [color]: The color to be darkened.
  /// - [amount]: The amount to reduce the lightness of the color. It ranges
  /// from `0.0` to `1.0`. The default is `0.1`.
  ///
  /// Returns:
  /// A new `Color` object that represents the darkened color.
  ///
  /// Example:
  /// ```dart
  /// final newColor = darken(Colors.blue, 0.2);
  /// ```
  static Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
      (hsl.lightness - amount).clamp(
        0.0,
        1.0,
      ),
    );

    return hslDark.toColor();
  }

// endregion
}
