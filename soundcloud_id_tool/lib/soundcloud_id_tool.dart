import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  // === Konfiguration ===
  final clientId = '5myDaCOr1DPDiVQfmR0kAc0Sp2D36ww5';

  // Beispiel-URL oder per Eingabe:
  stdout.write('SoundCloud Track-URL eingeben: ');
  final inputUrl = stdin.readLineSync();

  if (inputUrl == null || inputUrl.isEmpty) {
    print('❌ Ungültige URL.');
    exit(1);
  }

  final apiUrl = Uri.parse(
    'https://api.soundcloud.com/resolve?url=$inputUrl&client_id=$clientId',
  );

  try {
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final id = data['id'];
      final kind = data['kind'];

      if (kind == 'track' && id != null) {
        print('✅ Track-ID gefunden: soundcloud:tracks:$id');
      } else {
        print('⚠️ Kein gültiger Track gefunden.');
      }
    } else {
      print('❌ Fehler beim Abrufen: HTTP ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('❌ Ausnahme: $e');
  }
}
