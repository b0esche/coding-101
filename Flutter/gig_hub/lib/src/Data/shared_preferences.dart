import 'package:shared_preferences/shared_preferences.dart';

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
