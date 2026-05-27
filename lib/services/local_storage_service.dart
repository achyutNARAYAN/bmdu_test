import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _isLoggedInKey = 'is_logged_in';
  static const _recentProductIdsKey = 'recent_product_ids';
  static const _themeModeKey = 'theme_mode';

  Future<bool> getLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> saveLoginSession(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, loggedIn);
  }

  Future<List<int>> getRecentProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_recentProductIdsKey) ?? <String>[];
    return saved.map(int.parse).toList();
  }

  Future<void> saveRecentProductIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _recentProductIdsKey,
      ids.map((id) => id.toString()).toList(),
    );
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey) ?? 'system';
  }

  Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }
}
