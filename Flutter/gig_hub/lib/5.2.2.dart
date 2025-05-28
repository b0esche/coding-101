import 'package:flutter/material.dart';

class Aufgabe3 extends StatefulWidget {
  const Aufgabe3({super.key});

  @override
  State<Aufgabe3> createState() => _Aufgabe3State();
}

class _Aufgabe3State extends State<Aufgabe3> {
  String string = 'Go';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 96),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                final result = await stringVerdreifacher(string);

                setState(() {
                  isLoading = false;
                  string = result;
                });
              },
              child: const Text(
                "Verdreifachen!!!",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator(color: Colors.black)
                : Text(
                  string,
                  style: const TextStyle(fontSize: 60, color: Colors.black),
                ),
          ],
        ),
      ),
    );
  }
}

Future<String> stringVerdreifacher(String string) async {
  try {
    await Future.delayed(const Duration(seconds: 3));

    return string + string + string;
  } catch (e) {
    return 'Fehler beim Verdreifachen';
  }
}
