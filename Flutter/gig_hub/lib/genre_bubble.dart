import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 0.5),
        color: Color.fromARGB(140, 0, 0, 0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          genre,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
