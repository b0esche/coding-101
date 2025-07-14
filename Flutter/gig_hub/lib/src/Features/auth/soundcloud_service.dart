import 'dart:convert';
import 'package:gig_hub/src/Features/auth/soundcloud_authentication.dart';
import 'package:http/http.dart' as http;

class SoundcloudTrack {
  final int id;
  final String title;
  final String? streamUrl;

  SoundcloudTrack({required this.id, required this.title, this.streamUrl});

  factory SoundcloudTrack.fromJson(Map<String, dynamic> json) {
    return SoundcloudTrack(
      id: json['id'],
      title: json['title'] ?? '',
      streamUrl: json['stream_url'],
    );
  }
}

class SoundcloudService {
  static const String clientId = SoundcloudAuth.clientId;

  Future<List<SoundcloudTrack>> fetchUserTracks(String accessToken) async {
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

  Future<String> getPublicStreamUrl(int trackId) async {
    final url = Uri.parse(
      'https://api.soundcloud.com/tracks/$trackId/stream?client_id=$clientId',
    );

    final response = await http.head(url);

    if (response.statusCode == 302) {
      final redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        return redirectUrl;
      } else {
        throw Exception('no redirect location found for stream URL.');
      }
    } else if (response.statusCode == 200) {
      return url.toString();
    } else {
      throw Exception('failed to get stream URL: ${response.statusCode}');
    }
  }
}
