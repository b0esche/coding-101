import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlacesValidationService {
  static Future<bool> validateCity(String value) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return false;
    }

    final query = Uri.encodeComponent(trimmedValue);
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$query&types=(cities)&language=en&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'OK') {
        final predictions = data['predictions'] as List;

        if (predictions.isNotEmpty) {
          for (var prediction in predictions) {
            final String mainText =
                prediction['structured_formatting']['main_text']
                    ?.toString()
                    .trim() ??
                '';
            final List types = prediction['types'] ?? [];

            if (mainText.toLowerCase() == trimmedValue.toLowerCase() &&
                (types.contains('locality') ||
                    types.contains('administrative_area_level_3') ||
                    types.contains('political'))) {
              return true;
            }
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
