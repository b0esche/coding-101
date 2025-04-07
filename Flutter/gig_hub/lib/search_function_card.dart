import 'package:flutter/material.dart';
import 'package:gig_hub/custom_form_field.dart';

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
        color: const Color.fromARGB(255, 247, 247, 247),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(label: "genre"),
              CustomFormField(label: "bpm"),
              CustomFormField(label: "location"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 85),
                  ElevatedButton(
                    onPressed: () {
                      print("Suche läuft...");
                    },
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      maximumSize: Size(150, 24),
                      minimumSize: Size(88, 22),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      "search",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Color.fromARGB(255, 181, 165, 76);
                        }
                        return Colors.black;
                      }),
                      alignment: Alignment.bottomCenter,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      print("weg damit...");
                    },
                    child: Text("clear"),
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
