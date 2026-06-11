import 'package:adinkra_gems/services/tutorial_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('tutorial hints can be marked seen and reset', () async {
    expect(await TutorialService.hasSeen('level_1'), isFalse);

    await TutorialService.markSeen('level_1');
    expect(await TutorialService.hasSeen('level_1'), isTrue);

    await TutorialService.reset('level_1');
    expect(await TutorialService.hasSeen('level_1'), isFalse);
  });
}
