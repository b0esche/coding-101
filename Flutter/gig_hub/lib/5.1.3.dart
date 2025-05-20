import 'package:flutter/material.dart';
import 'package:gig_hub/eingeloggt.dart';

class InputTasksheet extends StatefulWidget {
  const InputTasksheet({super.key});

  @override
  State<InputTasksheet> createState() => _InputTasksheetState();
}

class _InputTasksheetState extends State<InputTasksheet> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String username = "Leon";
  String password = "Leon";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Input")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            spacing: 16,
            children: [
              SizedBox(height: 32),
              Text("Nutzername"),
              TextFormField(controller: _usernameController),
              Text("Passwort"),
              TextFormField(controller: _passwordController, obscureText: true),
              ElevatedButton(
                onPressed: () {
                  if (_usernameController.text == username &&
                      _passwordController.text == password) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Eingeloggt()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Falsche Eingabe!"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                child: Text("Einloggen", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
