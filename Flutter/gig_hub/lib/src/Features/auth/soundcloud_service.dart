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
    final clientId = '5myDaCOr1DPDiVQfmR0kAc0Sp2D36ww5';
    final accessToken = await _getAccessToken();
    final trackUrl = Uri.parse(uri);

    final trackResponse = await http.get(
      trackUrl,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (trackResponse.statusCode != 200) {
      debugPrint('⚠️ Failed to fetch track info: ${trackResponse.statusCode}');
      return '';
    }

    final json = jsonDecode(trackResponse.body);
    debugPrint('🎧 Track JSON: $json');

    // 1. Versuch: stream_url direkt
    final streamUrl = json['stream_url'];
    if (streamUrl != null && streamUrl.toString().isNotEmpty) {
      final fullUrl = '$streamUrl?client_id=$clientId';
      debugPrint('✅ Using direct stream_url');
      return fullUrl;
    }

    // 2. Fallback: transcodings
    final transcodings = json['media']?['transcodings'] as List<dynamic>?;
    if (transcodings == null || transcodings.isEmpty) {
      debugPrint('❌ No transcodings available');
      return '';
    }

    final progressiveStream = transcodings.firstWhere(
      (t) => t['format']['protocol'] == 'progressive',
      orElse: () => transcodings.first,
    );

    final streamRequestUrl = Uri.parse(
      '${progressiveStream['url']}?client_id=$clientId',
    );

    final streamResponse = await http.get(
      streamRequestUrl,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (streamResponse.statusCode != 200) {
      debugPrint('❌ Failed to get stream URL from transcodings');
      return '';
    }

    final streamJson = jsonDecode(streamResponse.body);
    final fallbackUrl = streamJson['url'];

    if (fallbackUrl == null || fallbackUrl.toString().isEmpty) {
      debugPrint('❌ Final fallback stream URL is empty');
      return '';
    }

    debugPrint('✅ Using fallback transcoding stream_url');
    return fallbackUrl;
  }
}
