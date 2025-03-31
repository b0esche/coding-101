import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Titel",
            style: TextStyle(
              color: const Color.fromARGB(255, 194, 194, 194),
              letterSpacing: 2.0,
              decoration: TextDecoration.underline,
              decorationColor: const Color.fromARGB(255, 194, 194, 194),
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 88, 78, 226),
        ),
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
                spacing: 8,
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
              Divider(thickness: 2),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 24,

                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: 200,
                        width: 100,
                        alignment: Alignment.center,
                        color: Colors.amber,
                        child: Text("A"),
                      ),
                      Positioned(top: 0, child: Text("Text A")),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Text B"),
                      Container(
                        height: 144,
                        width: 100,
                        alignment: Alignment.center,
                        color: const Color.fromARGB(255, 235, 129, 47),
                        child: Text("B"),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: Text("Text C"),
                      ),
                      Container(
                        height: 108,
                        width: 100,
                        alignment: Alignment.center,
                        color: const Color.fromARGB(255, 255, 100, 29),
                        child: Text("C"),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 2),
            ],
          ),
        ),
      ),
    );
  }
}
