import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Premium Palette ───
  static const Color darkBg = Color(0xFF0A0A1A);          
  static const Color darkSurface = Color(0xFF12122A);      
  static const Color deepCharcoal = Color(0xFF1A1A2E);     
  static const Color silverMist = Color(0xFFD0CFFF);       
  static const Color platinum = Color(0xFFF0EEFF);         
  static const Color lavenderAccent = Color(0xFF2196F3);   
  static const Color softPurple = Color(0xFF6C63FF);       
  static const Color surfaceGlass = Color(0x14FFFFFF);     
  static const Color borderSubtle = Color(0x1AFFFFFF);     

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
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
        onSurface: platinum,
        onSurfaceVariant: silverMist,
      ),
      textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(textStyle: baseTheme.textTheme.displayLarge, fontWeight: FontWeight.bold, color: platinum),
        bodyLarge: GoogleFonts.inter(textStyle: baseTheme.textTheme.bodyLarge, fontWeight: FontWeight.bold, color: platinum),
        bodyMedium: GoogleFonts.inter(textStyle: baseTheme.textTheme.bodyMedium, fontWeight: FontWeight.bold, color: silverMist),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: platinum),
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light();
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF2196F3),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF9C27B0),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: Colors.black, // Extreme black for mobile readability
        onSurfaceVariant: Color(0xFF333333),
      ),
      textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(textStyle: baseTheme.textTheme.displayLarge, fontWeight: FontWeight.bold, color: Colors.black),
        headlineLarge: GoogleFonts.outfit(textStyle: baseTheme.textTheme.headlineLarge, fontWeight: FontWeight.w900, color: Colors.black),
        bodyLarge: GoogleFonts.inter(textStyle: baseTheme.textTheme.bodyLarge, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: GoogleFonts.inter(textStyle: baseTheme.textTheme.bodyMedium, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        bodySmall: GoogleFonts.inter(textStyle: baseTheme.textTheme.bodySmall, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        labelLarge: GoogleFonts.inter(textStyle: baseTheme.textTheme.labelLarge, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
