import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double tiny = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;
  static const double huge = 48.0;
  static const double edge = 20.0; // Standardized edge padding
}

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
    final textTheme = GoogleFonts.outfitTextTheme(baseTheme.textTheme);
    
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
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
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 42, fontWeight: FontWeight.w900, color: platinum, letterSpacing: -1),
        headlineLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: platinum, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: platinum),
        titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: platinum),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: platinum),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: silverMist),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: silverMist.withValues(alpha: 0.7)),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: platinum),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderSubtle)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderSubtle)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: lavenderAccent, width: 2)),
        labelStyle: GoogleFonts.inter(color: silverMist),
        hintStyle: GoogleFonts.inter(color: silverMist.withValues(alpha: 0.4)),
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light();
    final textTheme = GoogleFonts.outfitTextTheme(baseTheme.textTheme);
    
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF2196F3),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF9C27B0),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: Colors.black, 
        onSurfaceVariant: Color(0xFF333333),
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -1),
        headlineLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
        titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF666666)),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2)),
        labelStyle: GoogleFonts.inter(color: const Color(0xFF333333)),
        hintStyle: GoogleFonts.inter(color: const Color(0xFF999999)),
      ),
    );
  }
}
