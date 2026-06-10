import 'package:flutter/material.dart';

class AdinkraTheme {
  static const Color primaryGold = Color(0xFFC58A2B);
  static const Color warmGold = Color(0xFFE2B65B);
  static const Color cream = Color(0xFFF7E4C5);
  static const Color lightCream = Color(0xFFFFF7E8);
  static const Color cocoa = Color(0xFF5B3823);
  static const Color darkCocoa = Color(0xFF2F1B12);
  static const Color terracotta = Color(0xFFA85132);
  static const Color sage = Color(0xFF667A45);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryGold,
      secondary: terracotta,
      surface: lightCream,
      onSurface: darkCocoa,
    ),
    scaffoldBackgroundColor: cream,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: darkCocoa,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      bodyMedium: TextStyle(color: cocoa),
    ),
  );
}
