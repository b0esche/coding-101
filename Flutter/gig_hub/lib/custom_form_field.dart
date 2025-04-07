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
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 181, 165, 76),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: Icon(Icons.chevron_right),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          floatingLabelStyle: TextStyle(
            color: const Color.fromARGB(255, 181, 165, 76),
            fontSize: 20,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.black,
        ),
      ),
    );
  }
}
