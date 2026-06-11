import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  TutorialService._();

  static const _seenPrefix = 'tutorial_seen_';

  static Future<bool> hasSeen(String levelId) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool('$_seenPrefix$levelId') ?? false;
  }

  static Future<void> markSeen(String levelId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('$_seenPrefix$levelId', true);
  }

  static Future<void> reset(String levelId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('$_seenPrefix$levelId');
  }
}
