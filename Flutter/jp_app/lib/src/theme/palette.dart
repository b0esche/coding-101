import 'package:flutter/material.dart';

abstract class Palette {
  static final Color bluue = const Color.fromARGB(255, 5, 99, 177);
  static final Color ggreen = const Color.fromARGB(255, 176, 255, 179);
  static final Color redd = const Color.fromARGB(255, 166, 36, 27);
  static final Color jpWhite = Color.fromARGB(255, 238, 238, 238);
  static final Color jpPink = Color.fromARGB(255, 218, 119, 192);
  static final Color jpOrange = Color.fromARGB(255, 233, 162, 165);
  static final Color bgGrey = Color.fromARGB(255, 47, 43, 34);
  static final Color bgBlue = Color.fromARGB(255, 67, 127, 151);
}

extension ColorOpacity on Color {
  Color o(double opacity) => withOpacity(opacity);
}
