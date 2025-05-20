import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_layout/src/data/consts/consts_color.dart';
import 'package:responsive_layout/src/data/consts/consts_style.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Palette.royalAzure,
  scaffoldBackgroundColor: Palette.primalBlack,
  appBarTheme: AppBarTheme(
    backgroundColor: Palette.primalBlack,
    elevation: 0,
    iconTheme: IconThemeData(color: Palette.glazedWhite, size: 20),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.sometypeMono(
      textStyle: TextStyle(color: Palette.glazedWhite, fontSize: 24),
    ),
    bodyMedium: GoogleFonts.roboto(
      textStyle: TextStyle(color: Palette.glazedWhite, fontSize: 14),
    ),
    bodySmall: GoogleFonts.roboto(
      textStyle: TextStyle(color: Palette.shadowGrey, fontSize: 11),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Palette.royalAzure,
      shape: RoundedRectangleBorder(borderRadius: AppRad.radius2),
      textStyle: TextStyle(color: Palette.glazedWhite),
      padding: AppPad.padding0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Palette.graphiteGrey,
    border: OutlineInputBorder(borderRadius: AppRad.radius1),
    contentPadding: AppPad.padding0,
  ),
);
