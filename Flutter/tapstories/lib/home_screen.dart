import 'package:flutter/material.dart';
import 'package:tapstories/draw_pad.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draw Pad Example')),
      body: Center(
        child: DrawPad(
          initialColor: Colors.blue,
          initialStrokeWidth: 5.0,
          showColorPalette: true, //true gesetzt
          showStrokeWidthSlider: true, //true gesetzt
        ),
      ),
    );
  }
}
