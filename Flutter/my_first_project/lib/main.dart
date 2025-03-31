import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Titel"), centerTitle: true),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Überschrift",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Autor"), Text("Datum")],
              ),
              Divider(thickness: 2),
              Container(
                height: 200,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: Text("Bild"),
              ),
              SizedBox(height: 16),
              Text("Hier steht der Artikel...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
