import 'package:flutter/material.dart';
import 'package:gig_hub/second_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

bool isSelected1 = true;
bool isSelected2 = true;
bool isSelected3 = true;
bool isSelected4 = true;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              const Text("Hello AppAkademie"),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                  });
                },
                child: Text("Go to next page"),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    isSelected1 = !isSelected1;
                  });
                },
                icon: Icon(
                  Icons.star,
                  color: isSelected1 ? Colors.green : Colors.grey,
                  size: 30,
                ),
              ),
              Row(
                spacing: 40,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSelected2 = !isSelected2;
                      });
                    },
                    icon: Icon(
                      Icons.circle,
                      color: isSelected2 ? Colors.red : Colors.grey,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSelected3 = !isSelected3;
                      });
                    },
                    icon: Icon(
                      Icons.share,
                      color: isSelected3 ? Colors.blue : Colors.grey,
                      size: 30,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isSelected4 = !isSelected4;
                  });
                },
                icon: Icon(
                  Icons.square,
                  color: isSelected4 ? Colors.yellow : Colors.grey,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
