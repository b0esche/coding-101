import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 220, 240, 255),
        appBar: AppBar(
          title: Text(
            'Meine Visitenkarte',
            style: TextStyle(color: const Color.fromARGB(255, 248, 155, 155)),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 40, child: Text("Gruppe 2")),
              SizedBox(height: 10),
              Text(
                'Ibrahim Göksen',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
