import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Inoffizielle, öffentlich zugängliche SoundCloud client_id.
/// ⚠️ Diese kann jederzeit blockiert werden und sollte nicht produktiv eingesetzt werden.
const String _clientId = '';

/// Hilfsfunktion zur Bereinigung des SoundCloud-Links
String sanitizeSoundCloudUrl(String url) {
  return url.trim().split('?').first;
}

class SoundCloudTrack {
  final String title;
  final String artist;
  final String streamUrl;

  SoundCloudTrack({
    required this.title,
    required this.artist,
    required this.streamUrl,
  });

  factory SoundCloudTrack.fromJson(Map<String, dynamic> json) {
    return SoundCloudTrack(
      title: json['title'] ?? '',
      artist: json['user']?['username'] ?? '',
      streamUrl: '${json['stream_url']}?client_id=$_clientId',
    );
  }
}

class SoundCloudService {
  static Future<SoundCloudTrack?> fetchTrackData(String rawUrl) async {
    final String url = sanitizeSoundCloudUrl(rawUrl);
    final String resolveUrl =
        'https://api-v2.soundcloud.com/resolve?url=$url&client_id=$_clientId';

    try {
      final response = await http.get(Uri.parse(resolveUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['kind'] == 'track') {
          return SoundCloudTrack.fromJson(data);
        } else {
          throw Exception('Kein Track erkannt (evtl. Playlist oder User-Link)');
        }
      } else {
        throw Exception(
          'Fehler beim Aufruf: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      debugPrint('SoundCloud fetchTrackData error: $e');
      return null;
    }
  }
}
