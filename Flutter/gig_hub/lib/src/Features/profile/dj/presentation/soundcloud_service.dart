// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// const String _clientId = '5myDaCOr1DPDiVQfmR0kAc0Sp2D36ww5';

// String sanitizeSoundCloudUrl(String url) {
//   return url.trim().split('?').first;
// }

// class SoundCloudTrack {
//   final String title;
//   final String artist;
//   final String streamUrl;

//   SoundCloudTrack({
//     required this.title,
//     required this.artist,
//     required this.streamUrl,
//   });

//   factory SoundCloudTrack.fromJson(
//     Map<String, dynamic> json,
//     String streamUrl,
//   ) {
//     return SoundCloudTrack(
//       title: json['title'] ?? '',
//       artist: json['user']?['username'] ?? '',
//       streamUrl: streamUrl,
//     );
//   }
// }

// class SoundCloudService {
//   static Future<SoundCloudTrack?> fetchTrackData(String rawUrl) async {
//     final String url = sanitizeSoundCloudUrl(rawUrl);
//     final String resolveUrl =
//         'https://api-v2.soundcloud.com/resolve?url=$url&client_id=$_clientId';

//     try {
//       final response = await http.get(Uri.parse(resolveUrl));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['kind'] == 'track') {
//           // Transcodings abrufen
//           final media = data['media'] as Map<String, dynamic>?;
//           final transcodings = media?['transcodings'] as List<dynamic>?;

//           if (transcodings == null || transcodings.isEmpty) {
//             throw Exception('Keine Transcodings gefunden.');
//           }

//           // Suche nach progressive mp3 Stream
//           final progressive = transcodings.firstWhere(
//             (t) =>
//                 t['format']?['protocol'] == 'progressive' ||
//                 (t['format']?['mime_type']?.contains('mpeg') ?? false),
//             orElse: () => null,
//           );

//           if (progressive == null) {
//             throw Exception('Kein progressiver Stream gefunden.');
//           }

//           final String transcodingUrl =
//               '${progressive['url']}?client_id=$_clientId';

//           // Hole tatsächliche Streaming-URL
//           final streamResponse = await http.get(Uri.parse(transcodingUrl));
//           if (streamResponse.statusCode != 200) {
//             throw Exception(
//               'Fehler beim Laden der Streaming-URL: ${streamResponse.statusCode}',
//             );
//           }
//           final streamData = jsonDecode(streamResponse.body);
//           final streamUrl = streamData['url'] as String;

//           return SoundCloudTrack.fromJson(data, streamUrl);
//         } else {
//           throw Exception('Kein Track erkannt (evtl. Playlist oder User-Link)');
//         }
//       } else {
//         throw Exception(
//           'Fehler beim Aufruf: ${response.statusCode}\n${response.body}',
//         );
//       }
//     } catch (e) {
//       debugPrint('SoundCloud fetchTrackData error: $e');
//       return null;
//     }
//   }
// }
