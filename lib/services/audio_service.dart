import 'package:audioplayers/audioplayers.dart';
import 'settings_service.dart';

/// Service managing audio playback of sound effects, integrated with SharedPreferences settings.
class AudioService {
  AudioService._();

  /// Plays a sound effect by creating a short-lived [AudioPlayer] instance.
  /// Disposes the instance automatically once playback completes.
  static Future<void> _playSfx(String path) async {
    if (!SettingsService.soundEnabled) return;
    try {
      final player = AudioPlayer();
      // Use standard AssetSource for Flame/Flutter asset audio
      await player.play(AssetSource(path));
      
      // Auto-dispose when sound is done
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      // Fail silently if audio hardware is busy or unsupported on target
    }
  }

  /// Play tile swap sound effect (quick click sweep).
  static Future<void> playSwap() async {
    await _playSfx('audio/swap.wav');
  }

  /// Play tile match sound effect (bright major third chime).
  static Future<void> playMatch() async {
    await _playSfx('audio/match.wav');
  }

  /// Play special gem clear sound effect (crackle explosion chime).
  static Future<void> playSpecialClear() async {
    await _playSfx('audio/special_clear.wav');
  }

  /// Play level win sound effect (joyful major scale arpeggio).
  static Future<void> playWin() async {
    await _playSfx('audio/win.wav');
  }

  /// Play level lose sound effect (sad descending scale).
  static Future<void> playLose() async {
    await _playSfx('audio/lose.wav');
  }
}
