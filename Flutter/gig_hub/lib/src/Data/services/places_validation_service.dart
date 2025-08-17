import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlacesValidationService {
  static Future<bool> validateCity(String value) async {
    // Get platform-specific API key
    String? apiKey;
    if (Platform.isIOS) {
      apiKey = dotenv.env['GOOGLE_API_KEY_IOS'];
      print('🍎 Using iOS API key: ${apiKey != null ? 'Found' : 'Missing'}');
    } else if (Platform.isAndroid) {
      apiKey = dotenv.env['GOOGLE_API_KEY_ANDROID'];
      print(
        '🤖 Using Android API key: ${apiKey != null ? 'Found' : 'Missing'}',
      );
    } else {
      // Fallback to generic key for other platforms
      apiKey = dotenv.env['GOOGLE_API_KEY'];
      print(
        '💻 Using generic API key: ${apiKey != null ? 'Found' : 'Missing'}',
      );
    }

    final trimmedValue = value.trim();
    print('🔍 Validating city: "$trimmedValue"');

    if (trimmedValue.isEmpty || apiKey == null) {
      print('❌ Validation failed: empty value or missing API key');
      return false;
    }

    final query = Uri.encodeComponent(trimmedValue);
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=$query&key=$apiKey',
    );

    try {
      print('🌐 Making API request to: $url');
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data status: ${data['status']}');

      if (response.statusCode == 200 && data['status'] == 'OK') {
        final results = data['results'] as List;
        print('🎯 Found ${results.length} results');

        if (results.isNotEmpty) {
          // For geocoding API, we just check if we got any results
          // and if they contain locality information
          for (var result in results) {
            final List types = result['types'] ?? [];
            final addressComponents = result['address_components'] as List?;

            print('🏷️ Types: $types');

            // Check if this result contains location types we're interested in
            bool hasValidType = types.any(
              (type) => [
                'locality',
                'administrative_area_level_1',
                'administrative_area_level_2',
                'administrative_area_level_3',
                'political',
              ].contains(type),
            );

            if (hasValidType && addressComponents != null) {
              // Check if any address component matches our input
              for (var component in addressComponents) {
                final longName = component['long_name']?.toString() ?? '';
                final shortName = component['short_name']?.toString() ?? '';
                final componentTypes = component['types'] as List? ?? [];

                print('🏙️ Checking component: "$longName" / "$shortName"');

                if (componentTypes.contains('locality') ||
                    componentTypes.contains('administrative_area_level_1')) {
                  if (longName.toLowerCase().contains(
                        trimmedValue.toLowerCase(),
                      ) ||
                      shortName.toLowerCase().contains(
                        trimmedValue.toLowerCase(),
                      ) ||
                      trimmedValue.toLowerCase().contains(
                        longName.toLowerCase(),
                      )) {
                    print('✅ Match found for: $longName');
                    return true;
                  }
                }
              }
            }
          }
        }
      } else {
        print(
          '❌ API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}',
        );
      }
      print('❌ No valid match found');
      return false;
    } catch (e) {
      print('💥 Exception during validation: $e');
      return false;
    }
  }
}
