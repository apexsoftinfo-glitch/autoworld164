import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE0D8D0), // Ciepły, stonowany odcień
        surface: const Color(0xFFFBFBF9), // Ciepła biel tła
        onSurface: const Color(0xFF2C2A29), // Głęboka, ciepła szarość na tekst
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F3F0), // Ciepły popiel pod tło
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2C2A29),
        ),
        headlineSmall: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2C2A29),
        ),
        titleLarge: GoogleFonts.inter(
          color: const Color(0xFF63605E),
        ),
        labelLarge: GoogleFonts.inter(
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF8E8B88),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2C2A29),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2C2A29),
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: Color(0xFFE0D8D0), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: base.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE0D8D0), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelStyle: TextStyle(color: base.colorScheme.onSurfaceVariant),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF2C2A29)),
        titleTextStyle: TextStyle(
          color: Color(0xFF2C2A29),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
