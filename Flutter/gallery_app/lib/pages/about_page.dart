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
              border: Border.all(color: Colors.indigoAccent.shade200, width: 4),
            ),
            child: CircleAvatar(
              radius: 96,
              backgroundImage: AssetImage("assets/images/IMG_1475 Kopie.jpg"),
            ),
          ),

          SizedBox(
            width: 260,
            child: Text(
              "Hi, ich bin Leon Bösche (geb. 11.02.1999) und auf dem Weg, als Junior App-Entwickler durchzustarten – mit Fokus auf Flutter. Nach meinem Abitur 2018 an einem Wirtschaftsgymnasium, bei dem ich Informatik als Prüfungsfach hatte, war für mich klar: Technik und kreatives Problemlösen sind genau mein Ding. Aktuell mache ich eine Umschulung zum App-Entwickler und vertiefe mein Wissen rund um Flutter, Dart und moderne App-Architekturen. Ich bringe eine Mischung aus wirtschaftlichem Verständnis, technischem Know-how und viel Motivation mit. Sauberer Code, gutes UI/UX und der Wille, stetig besser zu werden, stehen bei mir ganz oben. Mein Ziel: mobile Apps entwickeln, die nicht nur funktionieren, sondern begeistern.",
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
