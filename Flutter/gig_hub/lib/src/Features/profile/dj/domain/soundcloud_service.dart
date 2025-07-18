import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SoundcloudTrack {
  final int id;
  final String title;
  final String? streamUrl;

  SoundcloudTrack({required this.id, required this.title, this.streamUrl});

  factory SoundcloudTrack.fromJson(Map<String, dynamic> json) {
    return SoundcloudTrack(
      id: json['id'],
      title: json['title'] ?? '',
      streamUrl: json['uri'],
    );
  }
}

class SoundcloudService {
  final _storage = const FlutterSecureStorage();

  Future<String> _getAccessToken() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('no access token found, user must authenticate first!');
    }
    return token;
  }

  Future<List<SoundcloudTrack>> fetchUserTracks() async {
    final accessToken = await _getAccessToken();
    final url = Uri.parse('https://api.soundcloud.com/me/tracks');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((json) => SoundcloudTrack.fromJson(json)).toList();
    } else {
      throw Exception('failed to load tracks: ${response.statusCode}');
    }
  }

  Future<String> getPublicStreamUrl(String trackUri) async {
    final accessToken = await _getAccessToken();
    final client = http.Client();

    try {
      final uri = Uri.parse(trackUri);
      final urn = uri.pathSegments.last;

      final parts = urn.split(':');
      final trackId = parts.last;

      final streamsUrl = Uri.https(
        'api.soundcloud.com',
        '/tracks/$trackId/streams',
      );

      final response = await client.get(
        streamsUrl,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        debugPrint('❌ Failed to get streams: ${response.statusCode}');
        return '';
      }

      final data = jsonDecode(response.body);
      final streamUrl = data['http_mp3_128_url'];

      if (streamUrl != null && streamUrl.toString().isNotEmpty) {
        return streamUrl;
      }

      debugPrint('⚠️ No valid stream URL found in response');
      return '';
    } catch (e) {
      debugPrint('❌ Exception in getPublicStreamUrl: $e');
      return '';
    } finally {
      client.close();
    }
  }
}
