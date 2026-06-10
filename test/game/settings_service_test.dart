import 'package:adinkra_gems/services/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsService', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SettingsService.init();
    });

    test('defaults to sound and music enabled', () {
      expect(SettingsService.soundEnabled, isTrue);
      expect(SettingsService.musicEnabled, isTrue);
    });

    test('can persistently save sound preference', () async {
      await SettingsService.setSoundEnabled(false);
      expect(SettingsService.soundEnabled, isFalse);

      await SettingsService.setSoundEnabled(true);
      expect(SettingsService.soundEnabled, isTrue);
    });

    test('can persistently save music preference', () async {
      await SettingsService.setMusicEnabled(false);
      expect(SettingsService.musicEnabled, isFalse);

      await SettingsService.setMusicEnabled(true);
      expect(SettingsService.musicEnabled, isTrue);
    });
  });
}
