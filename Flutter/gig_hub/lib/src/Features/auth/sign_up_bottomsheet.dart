import 'package:flutter/material.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class SignUpSheet extends StatefulWidget {
  const SignUpSheet({super.key});

  @override
  State<SignUpSheet> createState() => _SignUpSheetState();
}

class _SignUpSheetState extends State<SignUpSheet> {
  Set<String> selected = {'dj'};

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Palette.primalBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "sign up",
              style: TextStyle(
                color: Palette.glazedWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 36),
            SizedBox(
              height: 48,
              width: 270,
              child: SegmentedButton<String>(
                expandedInsets: EdgeInsets.all(2),
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<String>(
                    value: 'booker',
                    label: Text("booker", style: TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment<String>(
                    value: 'dj',
                    label: Text("    DJ    ", style: TextStyle(fontSize: 12)),
                  ),
                ],
                selected: selected,
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    selected = newSelection;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return Palette.shadowGrey;
                    }
                    return Palette.shadowGrey.o(0.35);
                  }),
                  foregroundColor: WidgetStateProperty.all(Palette.primalBlack),
                  textStyle: WidgetStateProperty.resolveWith<TextStyle?>((
                    states,
                  ) {
                    return TextStyle(
                      fontWeight:
                          states.contains(WidgetState.selected)
                              ? FontWeight.bold
                              : FontWeight.normal,
                    );
                  }),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Palette.shadowGrey, width: 2),
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 44),
            TextFormField(
              controller: _nameController,
              validator: validateName,
              style: TextStyle(color: Palette.glazedWhite),
              decoration: InputDecoration(
                hintText: "name",
                hintStyle: TextStyle(color: Palette.glazedWhite.o(0.7)),
                prefixIcon: Icon(
                  Icons.person,
                  color: Palette.glazedWhite.o(0.7),
                ),
                filled: true,
                fillColor: Palette.glazedWhite.o(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              validator: validateEmail,
              style: TextStyle(color: Palette.glazedWhite),
              decoration: InputDecoration(
                hintText: "email",
                hintStyle: TextStyle(color: Palette.glazedWhite.o(0.7)),
                prefixIcon: Icon(
                  Icons.email,
                  color: Palette.glazedWhite.o(0.7),
                ),
                filled: true,
                fillColor: Palette.glazedWhite.o(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: validatePassword,
              style: TextStyle(color: Palette.glazedWhite),
              decoration: InputDecoration(
                hintText: "password",
                hintStyle: TextStyle(color: Palette.glazedWhite.o(0.7)),
                prefixIcon: Icon(Icons.lock, color: Palette.glazedWhite.o(0.7)),
                filled: true,
                fillColor: Palette.glazedWhite.o(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              validator:
                  (value) =>
                      validateConfirmPassword(value, _passwordController.text),
              style: TextStyle(color: Palette.glazedWhite),
              decoration: InputDecoration(
                hintText: "confirm password",
                hintStyle: TextStyle(color: Palette.glazedWhite.o(0.7)),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Palette.glazedWhite.o(0.7),
                ),
                filled: true,
                fillColor: Palette.glazedWhite.o(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.forgedGold,
                  foregroundColor: Palette.primalBlack,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Palette.concreteGrey.o(0.7),
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // zur profilerstellung
                  }
                },
                child: Text(
                  "next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.glazedWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

// Validator-Funktionen

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'please enter your artist or club/event name';
  }
  if (value.trim().length > 24) {
    return 'name is too long';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'please enter your email';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 6) {
    return 'password needs at least 6 characters';
  }
  if (!RegExp(r"[+*#'_\-.:,;!§\$&/()=?`´><^°\[\]{}]").hasMatch(value)) {
    return 'password needs at least 1 special character';
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value != password) {
    return 'passwords do not match';
  }
  return null;
}
