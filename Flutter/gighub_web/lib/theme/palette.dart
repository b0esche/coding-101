import 'package:flutter/material.dart';

abstract class Palette {
  // Main colors inspired by gig_hub
  static const Color primalBlack = Color.fromARGB(255, 33, 33, 33);
  static const Color glazedWhite = Color.fromARGB(255, 248, 248, 248);
  static const Color gigGrey = Color.fromARGB(255, 155, 155, 155);
  static const Color concreteGrey = Color.fromARGB(255, 205, 205, 205);
  static const Color shadowGrey = Color.fromARGB(255, 233, 233, 234);
  static const Color forgedGold = Color.fromARGB(255, 187, 175, 99);
  static const Color alarmRed = Color.fromARGB(255, 235, 72, 72);
  static const Color okGreen = Color.fromARGB(255, 25, 255, 144);

  // Additional colors for web
  static const Color darkGrey = Color.fromARGB(255, 66, 66, 66);
  static const Color lightGrey = Color.fromARGB(255, 244, 244, 244);
  static const Color accentBlue = Color.fromARGB(255, 100, 149, 237);
}

extension ColorExtension on Color {
  Color o(double opacity) {
    return withOpacity(opacity);
  }
}
