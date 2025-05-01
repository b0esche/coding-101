// ignore

import 'package:flutter/material.dart';
import 'package:jp_app/src/theme/palette.dart';

abstract class AppTheme {
  static final lightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Palette.ggreen,
    ),
  ).copyWith(
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(backgroundColor: Palette.redd),
    ),
  );

  static final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Palette.bluue,
    ),
  );
}

// set Colors in Screens/Widgets like:
// color: Theme.of(context).colorScheme.primary
