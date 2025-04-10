import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Aufgabe_443());
  }
}

class Aufgabe_443 extends StatelessWidget {
  const Aufgabe_443({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Willkommen zur App!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Image.network("https://picsum.photos/101", fit: BoxFit.fill),
          ),
          Expanded(flex: 1, child: Text("Hier wird schön gefünftelt")),
        ],
      ),
    );
  }
}
