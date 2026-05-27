import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafeStepsTheme {
  static const Color primary = Color(0xFF1A237E);
  static const Color mint = Color(0xFF2E7D32);
  static const Color coral = Color(0xFFF06292);
  static const Color backgroundColor = Color(0xFFE8F1FF);
  static const Color cardBackground = Color(0x99FFFFFF);
  static const Color danger = Color(0xFFF06292);

  static final ThemeData theme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: mint,
      surface: cardBackground,
      error: danger,
    ),
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: GoogleFonts.nunitoTextTheme(
      Typography.blackMountainView,
    ).copyWith(
      bodyLarge: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
      bodyMedium: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
      titleLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: cardBackground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        minimumSize: const Size(160, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.92),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
