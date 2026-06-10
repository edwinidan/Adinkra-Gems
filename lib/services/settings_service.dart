import 'package:shared_preferences/shared_preferences.dart';

/// Manage persistent sound and music settings using [SharedPreferences].
class SettingsService {
  SettingsService._();

  static late SharedPreferences _prefs;

  static const String _soundKey = 'soundEnabled';
  static const String _musicKey = 'musicEnabled';

  /// Initializes the service. Must be called in main() before using options.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Check if sound effects are enabled.
  static bool get soundEnabled => _prefs.getBool(_soundKey) ?? true;

  /// Update the sound effects setting.
  static Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundKey, enabled);
  }

  /// Check if music is enabled.
  static bool get musicEnabled => _prefs.getBool(_musicKey) ?? true;

  /// Update the music setting.
  static Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool(_musicKey, enabled);
  }
}
