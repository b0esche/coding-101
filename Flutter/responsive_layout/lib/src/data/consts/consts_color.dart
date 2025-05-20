import 'package:flutter/material.dart';

abstract class Palette {
  static final Color primalBlack = const Color.fromARGB(255, 33, 33, 33);
  static final Color glazedWhite = const Color.fromARGB(255, 248, 248, 248);
  static final Color graphiteGrey = const Color.fromARGB(255, 155, 155, 155);
  static final Color concreteGrey = const Color.fromARGB(255, 205, 205, 205);
  static final Color shadowGrey = const Color.fromARGB(255, 233, 233, 234);
  static final Color companyBlue = const Color.fromARGB(255, 86, 125, 240);
  static final Color royalAzure = const Color.fromARGB(255, 64, 112, 245);
  static final Color mintBreeze = const Color.fromARGB(255, 128, 255, 193);
  static final Color crimsonAlert = const Color.fromARGB(255, 235, 72, 72);
}

extension ColorOpacity on Color {
  Color opac(double opacity) => withValues(alpha: opacity);
}
