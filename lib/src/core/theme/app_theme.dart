import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Provides a centralized app theme definition.
///
/// This class encapsulates the main theme used throughout the app to
/// ensure consistency in design and appearance. The theme is based on
/// the dark theme with custom overrides.
class AppTheme {
  /// The primary theme used across the app.
  ///
  /// This theme is based on the dark theme, with custom modifications,
  /// such as the scaffold background color and the app bar appearance.
  static ThemeData theme = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: AppConstants.primaryBlueLightest,
      ),
    ),
  );
}
