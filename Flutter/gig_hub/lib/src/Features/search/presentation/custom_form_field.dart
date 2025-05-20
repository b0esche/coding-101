import 'package:flutter/material.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatelessWidget {
  final String label;

  const CustomFormField({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 32,
      child: TextFormField(
        onTap: () {
          debugPrint("Moin"); // TODO: brauche jeweils den dialog mit dem picker
          // die ihre werte dann an den TextController
          // (und die Suchfunktion) übergeben.. Future??
          switch (label) {
            case "genre": //ListView mit Radio max. 5
            case "bpm": // range bzw min und max
            case "location": // Package?? Autocomplete??
          }
        },
        readOnly: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 181, 165, 76),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.gigGrey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: Icon(Icons.chevron_right, color: Palette.glazedWhite),
          labelText: label,
          labelStyle: GoogleFonts.sometypeMono(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Palette.primalBlack,
        ),
      ),
    );
  }
}
