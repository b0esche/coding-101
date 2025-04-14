import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 32,
        children: [
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.indigo.shade300, width: 4),
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                "https://www.essenchecker.de/wp-content/uploads/go-x/u/b3211dd6-1430-4600-8de8-2d93d8490970/l1,t1,w1498,h1998/image-768x1024.jpg",
              ),
            ),
          ),

          SizedBox(
            width: 260,
            child: Text(
              "Mein Name ist Kaya Müller, ein Fotograf im Alter von 32 Jahren, der die Welt durch die Linse entdeckt. Mit einem Hintergrund in der visuellen Kunst und jahrelanger Erfahrung in der Fotografie habe ich einen Blick für die Schönheit im Alltäglichen entwickelt. Meine Spezialität liegt in der Sport- und Naturfotografie, wo ich das Spiel von Licht und Schatten einfange, um emotionale und aussagekräftige Bilder zu schaffen.\n\nIch glaube daran, dass jeder Moment einzigartig ist und seine eigene Geschichte erzählt. In meinen Arbeiten strebe ich danach, diese Geschichten visuell zu interpretieren und sie durch kreative Kompositionen und Nuancen zum Leben zu erwecken. Meine fotografische Reise hat mich durch verschiedene Länder geführt, wo ich die Vielfalt der Kulturen und Landschaften festhalte, immer auf der Suche nach neuen Perspektiven und Herausforderungen.\n\nMein Anspruch ist es, mit meinen Bildern nicht nur zu dokumentieren, sondern auch zu inspirieren und zu berühren. Jeder Auftrag und jedes Projekt ist für mich eine Möglichkeit, meine Leidenschaft und mein Können zu zeigen und eine Verbindung zwischen dem Betrachter und dem Bild herzustellen.",
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
