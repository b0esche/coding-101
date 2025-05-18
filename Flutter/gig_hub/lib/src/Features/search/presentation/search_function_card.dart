import 'package:flutter/material.dart';
import 'package:gig_hub/src/Features/search/presentation/custom_form_field.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFunctionCard extends StatelessWidget {
  const SearchFunctionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 192,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        color: Palette.glazedWhite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(label: "genre..."),
              CustomFormField(label: "bpm..."),
              CustomFormField(label: "location..."),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 85),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint("Suche läuft...");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.shadowGrey,
                      splashFactory: NoSplash.splashFactory,
                      maximumSize: Size(150, 24),
                      minimumSize: Size(88, 22),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Palette.concreteGrey),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      "search",
                      style: GoogleFonts.sometypeMono(
                        textStyle: TextStyle(
                          color: Palette.primalBlack,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Palette.forgedGold;
                        }
                        return Palette.primalBlack;
                      }),
                      alignment: Alignment.bottomCenter,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      debugPrint("weg damit...");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.shadowGrey,
                        border: Border.all(color: Palette.concreteGrey),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.gigGrey,
                            blurRadius: 4,
                            offset: Offset(0.5, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Text(
                          "clear",
                          style: GoogleFonts.sometypeMono(
                            textStyle: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
