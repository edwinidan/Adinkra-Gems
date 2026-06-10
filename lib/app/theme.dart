import 'package:flutter/material.dart';

class AdinkraTheme {
  // Brand colours
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color deepPurple = Color(0xFF2D0057);
  static const Color richBlack = Color(0xFF0A0010);
  static const Color accentTeal = Color(0xFF00E5CC);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: primaryGold,
          secondary: accentTeal,
          surface: richBlack,
        ),
        scaffoldBackgroundColor: richBlack,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: primaryGold,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      );
}
