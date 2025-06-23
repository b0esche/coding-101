import 'package:flutter/material.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

List<String> genres = [
  "Techno",
  "Tekno",
  "Tekk",
  "Hard Techno",
  "Hardtekk",
  "Darktechno",
  "Melodic Techno",
  "Industrial",
  "Schranz",
  "Peaktime",
  "Groove / Hardgroove",
  "Trance",
  "Hard Trance",
  "Psytrance",
  "Progressive Psytrance",
  "Darkpsy",
  "Eurotrance",
  "Uptempo",
  "Hitech",
  "Rawstyle",
  "Hardstyle",
  "Hardcore",
  "Frenchcore",
  "House",
  "Hard House",
  "Tech House",
  "Deep House",
  "G-House",
  "Minimal",
  "Progressive House",
  "Garage",
  "Speed Garage",
  "Jungle",
  "Ragga Jungle",
  "DnB",
  "Darkstep",
  "Ghetto Tech",
  "Miami Bass",
  "ACID",
  "Acid House",
  "Electro",
  "Dubstep",
  "Terror",
  "Hyperpop",
  "Gabber",
  "Synthwave",
  "Vaporwave",
  "Trap",
  "Dub",
  "Detroit",
  "Raggatek",
  "Downtempo",
  "EDM",
];

class GenreBubble extends StatelessWidget {
  const GenreBubble({required this.genre, super.key});
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LiquidGlass(
          shape: LiquidRoundedRectangle(borderRadius: Radius.circular(16)),
          clipBehavior: Clip.hardEdge,
          glassContainsChild: true,
          settings: LiquidGlassSettings(
            blur: 1,
            chromaticAberration: 6,
            refractiveIndex: 1.2,
            thickness: 6,
            lightIntensity: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.shadowGrey, width: 0.85),
              color: Palette.gigGrey.o(0.8),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0.8, 0.8),
                  color: Palette.gigGrey.o(0.8),
                  blurStyle: BlurStyle.inner,
                  spreadRadius: 0.8,
                  blurRadius: 16,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                genre,
                style: GoogleFonts.sometypeMono(
                  textStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Palette.glazedWhite,
                    decoration: TextDecoration.underline,
                    decorationColor: Palette.forgedGold.o(0.35),
                    decorationThickness: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
