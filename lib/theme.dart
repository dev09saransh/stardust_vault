import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Vibrant Purple / Indigo palette ───
  static const Color darkBg = Color(0xFF0A0A1A);          // Deep indigo-black
  static const Color darkSurface = Color(0xFF12122A);      // Dark indigo surface
  static const Color deepCharcoal = Color(0xFF1A1A2E);     // Card / sidebar bg
  static const Color silverMist = Color(0xFFD0CFFF);       // Light lavender text
  static const Color platinum = Color(0xFFF0EEFF);         // Bright white-lavender
  static const Color lavenderAccent = Color(0xFF7C4DFF);   // Primary vivid purple
  static const Color softPurple = Color(0xFF6C63FF);       // Secondary indigo
  static const Color surfaceGlass = Color(0x14FFFFFF);     // Glass card fill
  static const Color borderSubtle = Color(0x1AFFFFFF);     // Subtle border

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF0A0A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark();
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: lavenderAccent,
      colorScheme: const ColorScheme.dark(
        primary: lavenderAccent,
        secondary: softPurple,
        surface: deepCharcoal,
        onPrimary: Colors.white,
        onSurface: silverMist,
      ),
      textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme).copyWith(
        bodyLarge: GoogleFonts.inter(textStyle: baseTheme.textTheme.bodyLarge),
        bodyMedium: GoogleFonts.inter(textStyle: baseTheme.textTheme.bodyMedium),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepCharcoal,
        contentTextStyle: GoogleFonts.inter(color: platinum),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lavenderAccent, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: silverMist.withValues(alpha: 0.4)),
        labelStyle: GoogleFonts.inter(color: silverMist.withValues(alpha: 0.7)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
