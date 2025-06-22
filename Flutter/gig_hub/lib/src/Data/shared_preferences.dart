import 'package:gig_hub/src/Common/app_imports.dart';
import 'package:gig_hub/src/Data/oauth_consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/app_imports.dart' as http;

import 'dart:convert';

import 'package:http/http.dart' as http;

class SoundCloudLoginService {
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sc_access_token', token);
  }

  Future<String?> loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sc_access_token');
  }

  Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sc_access_token');
  }

  Future<void> checkLoginStatus() async {
    final token = await loadAccessToken();
    if (token != null) {
      await fetchUserProfile(token);
    } else {
      await launchSoundCloudLogin();
    }
  }

  Future<void> exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse(tokenEndpoint),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access_token'];
      await saveAccessToken(accessToken);
      print('🎉 Token gespeichert: $accessToken');
    } else {
      print('❌ Fehler beim Token-Austausch: ${response.body}');
    }
  }

  Future<void> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('https://api.soundcloud.com/me'),
      headers: {'Authorization': 'OAuth $token'},
    );
    print(response.body);
  }

  Future<void> launchSoundCloudLogin() async {}
}

class SharedPreferencesService {
  // preference keys
  static String darkModeKey = "isDarkMode";
  static String sortOptionKey = "selectedSortOption";

  // load preference (dark mode)
  static Future<bool> loadPreference() async {
    final preferences = await SharedPreferences.getInstance();
    bool darkModeEnabled = preferences.getBool(darkModeKey) ?? false;
    return darkModeEnabled;
  }

  // set preferences (dark mode)
  static Future<void> setPreference(bool darkModeEnabled) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(darkModeKey, darkModeEnabled);
  }
}
