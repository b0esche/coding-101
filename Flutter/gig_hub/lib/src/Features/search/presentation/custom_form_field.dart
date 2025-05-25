import 'package:flutter/material.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const CustomFormField({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 32,
      child: TextFormField(
        onTap: onPressed,
        // () {
        //   debugPrint("Moin"); // TODO: brauche jeweils den dialog mit dem picker
        //   // die ihre werte dann an den TextController
        //   // (und die Suchfunktion) übergeben.. Future??
        //   switch (label) {
        //     case "genre": //ListView mit Radio max. 5
        //     case "bpm": // range bzw min und max
        //     case "location": // Package?? Autocomplete??
        //   }
        // },
        readOnly: true,
        style: TextStyle(color: Palette.glazedWhite),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.forgedGold, width: 2),
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
              color: Palette.glazedWhite,
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
