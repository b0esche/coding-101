import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SoundcloudAuth {
  static const String clientId = '5myDaCOr1DPDiVQfmR0kAc0Sp2D36ww5';
  static const String clientSecret = 'JCnARmRDVok6HGx70LzRTLUZtTAWoYi4';
  static const String redirectUri = 'gighub://callback';
  static const String authEndpoint = 'https://soundcloud.com/connect';
  static const String tokenEndpoint = 'https://api.soundcloud.com/oauth2/token';

  final _secureStorage = FlutterSecureStorage();
  String? _codeVerifier;

  Future<void> authenticate() async {
    _codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(_codeVerifier!);

    final authUrl = Uri.parse(authEndpoint).replace(
      queryParameters: {
        'client_id': clientId,
        'response_type': 'code',
        'redirect_uri': redirectUri,
        'scope': 'non-expiring',
        'code_challenge_method': 'S256',
        'code_challenge': codeChallenge,
      },
    );

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('could not launch SoundCloud login URL.');
    }
  }

  Future<void> exchangeCodeForToken(String code) async {
    if (_codeVerifier == null) {
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'authorization_code',
          'redirect_uri': redirectUri,
          'code': code,
          'code_verifier': _codeVerifier!,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];

        await _secureStorage.write(key: 'access_token', value: accessToken);
        if (refreshToken != null) {
          await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        }
      }
    } catch (e) {
      throw ('exception during token exchange: $e');
    }
  }

  String _generateCodeVerifier([int length = 64]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (_) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}
