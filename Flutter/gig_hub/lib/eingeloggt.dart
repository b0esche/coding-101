import 'package:flutter/material.dart';

class Eingeloggt extends StatelessWidget {
  const Eingeloggt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            "Herzlich Willkommen",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
