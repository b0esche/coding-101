import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;

  const CustomFormField({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 32,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.chevron_right),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          floatingLabelStyle: TextStyle(
            color: const Color.fromARGB(200, 255, 255, 255),
          ),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 2),
          ),
          filled: true,
          fillColor: Colors.black,
        ),
      ),
    );
  }
}

// selected field purple border???
