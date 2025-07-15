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
      debugPrint(response.body);
      return list.map((json) => SoundcloudTrack.fromJson(json)).toList();
    } else {
      throw Exception('failed to load tracks: ${response.statusCode}');
    }
  }

  Future<String> getPublicStreamUrl(String uri) async {
    final accessToken = await _getAccessToken();
    final trackUrl = Uri.parse(uri);

    final trackResponse = await http.get(
      trackUrl,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    // if (trackResponse.statusCode != 200) {
    //   throw Exception('Failed to get track info: ${trackResponse.statusCode}');
    // }

    final json = jsonDecode(trackResponse.body);
    debugPrint('🎧 Track JSON: $json');
    final transcodings = json['media']?['transcodings'] as List<dynamic>?;

    if (transcodings == null || transcodings.isEmpty) {
      return '';
      // throw Exception('No transcodings available for this track.');
    }

    final progressiveStream = transcodings.firstWhere(
      (t) => t['format']['protocol'] == 'progressive',
      orElse: () => transcodings.first,
    );

    final streamRequestUrl = Uri.parse(progressiveStream['url']);

    final streamResponse = await http.get(
      streamRequestUrl,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    // if (streamResponse.statusCode != 200) {
    //   throw Exception('Failed to get stream URL: ${streamResponse.statusCode}');
    // }

    final streamJson = jsonDecode(streamResponse.body);
    return streamJson['url'];
  }
}
