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
        backgroundColor: const Color.fromARGB(255, 255, 228, 228),
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
          shape: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey),
                child: Text(
                  "Menü",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ],
          ),
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/hqdefault.jpg"),
                    fit: BoxFit.cover,
                  ),

                  border: Border.all(
                    color: const Color.fromARGB(155, 40, 187, 255),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(""),
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
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          border: Border(
                            top: BorderSide(color: Colors.black, width: 1),
                            left: BorderSide(color: Colors.black, width: 1),
                            right: BorderSide(color: Colors.black, width: 1),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
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
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 235, 129, 47),
                          borderRadius: BorderRadius.circular(16),
                        ),
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
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 100, 29),
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text("C"),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 2),
              SizedBox(height: 16),
              Placeholder(fallbackHeight: 150),
            ],
          ),
        ),
      ),
    );
  }
}
