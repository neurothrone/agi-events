import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
    ),
  );
}
