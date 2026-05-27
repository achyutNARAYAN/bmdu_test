import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> loadTheme() async {
    final saved = await _storage.getThemeMode();
    switch (saved) {
      case 'light':
        _mode = ThemeMode.light;
        break;
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      default:
        _mode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _mode = mode;
    await _storage.saveThemeMode(_modeToString(mode));
    notifyListeners();
  }

  Future<void> toggleLightDark() async {
    if (_mode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
}
