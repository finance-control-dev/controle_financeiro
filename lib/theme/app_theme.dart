import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF10B981);
  static const Color primaryLight = Color(0xFF34D399);
  static const Color primaryDark = Color(0xFF059669);
  static const Color accent = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color success = Color(0xFF10B981);
  
  // Dark Theme Colors
  static const Color darkBg = Color(0xFF070B14);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1A2236);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Light Theme Colors
  static const Color lightBg = Color(0xFFE5E5EA);
  static const Color lightSurface = Color(0xFFF2F2F7);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF3C3C43);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: lightBg,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: accent,
      error: danger,
      surface: lightSurface,
      background: lightBg,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightText,
      onBackground: lightText,
    ),
    cardTheme: CardTheme(
      color: lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: lightText,
      displayColor: lightText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: lightText),
      titleTextStyle: GoogleFonts.inter(
        color: lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: darkBg,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: accent,
      error: danger,
      surface: darkSurface,
      background: darkBg,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkText,
      onBackground: darkText,
    ),
    cardTheme: CardTheme(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: darkText,
      displayColor: darkText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: darkText),
      titleTextStyle: GoogleFonts.inter(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
