import 'package:flutter/material.dart';
import 'package:gallery_app/main_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen()); // pages[index]
  }
}
