import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Palette.forgedGold,
        brightness: Brightness.light,
        primary: Palette.forgedGold,
        onPrimary: Palette.glazedWhite,
        secondary: Palette.primalBlack,
        surface: Palette.glazedWhite,
        onSurface: Palette.primalBlack,
      ),
      scaffoldBackgroundColor: Palette.glazedWhite,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sometypeMono(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Palette.primalBlack,
        ),
        displayMedium: GoogleFonts.sometypeMono(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Palette.primalBlack,
        ),
        displaySmall: GoogleFonts.sometypeMono(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Palette.primalBlack,
        ),
        headlineLarge: GoogleFonts.sometypeMono(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Palette.primalBlack,
        ),
        headlineMedium: GoogleFonts.sometypeMono(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Palette.primalBlack,
        ),
        headlineSmall: GoogleFonts.sometypeMono(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Palette.primalBlack,
        ),
        titleLarge: GoogleFonts.sometypeMono(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Palette.primalBlack,
        ),
        titleMedium: GoogleFonts.sometypeMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Palette.primalBlack,
        ),
        bodyLarge: GoogleFonts.sometypeMono(
          fontSize: 16,
          color: Palette.primalBlack,
        ),
        bodyMedium: GoogleFonts.sometypeMono(
          fontSize: 14,
          color: Palette.primalBlack,
        ),
        bodySmall: GoogleFonts.sometypeMono(
          fontSize: 12,
          color: Palette.gigGrey,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Palette.primalBlack,
        foregroundColor: Palette.glazedWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sometypeMono(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Palette.glazedWhite,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.forgedGold,
          foregroundColor: Palette.primalBlack,
          textStyle: GoogleFonts.sometypeMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: Palette.glazedWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Palette.shadowGrey, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Palette.forgedGold,
        brightness: Brightness.dark,
        primary: Palette.forgedGold,
        onPrimary: Palette.primalBlack,
        secondary: Palette.glazedWhite,
        surface: Palette.primalBlack,
        onSurface: Palette.glazedWhite,
      ),
      scaffoldBackgroundColor: Palette.primalBlack,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sometypeMono(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Palette.glazedWhite,
        ),
        displayMedium: GoogleFonts.sometypeMono(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Palette.glazedWhite,
        ),
        displaySmall: GoogleFonts.sometypeMono(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Palette.glazedWhite,
        ),
        headlineLarge: GoogleFonts.sometypeMono(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Palette.glazedWhite,
        ),
        headlineMedium: GoogleFonts.sometypeMono(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Palette.glazedWhite,
        ),
        headlineSmall: GoogleFonts.sometypeMono(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Palette.glazedWhite,
        ),
        titleLarge: GoogleFonts.sometypeMono(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Palette.glazedWhite,
        ),
        titleMedium: GoogleFonts.sometypeMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Palette.glazedWhite,
        ),
        bodyLarge: GoogleFonts.sometypeMono(
          fontSize: 16,
          color: Palette.glazedWhite,
        ),
        bodyMedium: GoogleFonts.sometypeMono(
          fontSize: 14,
          color: Palette.glazedWhite,
        ),
        bodySmall: GoogleFonts.sometypeMono(
          fontSize: 12,
          color: Palette.gigGrey,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Palette.primalBlack,
        foregroundColor: Palette.forgedGold,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sometypeMono(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Palette.forgedGold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.forgedGold,
          foregroundColor: Palette.primalBlack,
          textStyle: GoogleFonts.sometypeMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: Palette.darkGrey,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Palette.forgedGold.o(0.3), width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
