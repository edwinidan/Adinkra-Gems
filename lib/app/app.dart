import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../screens/game/game_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/level_select/level_select_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';

class AdinkraGemsApp extends StatelessWidget {
  const AdinkraGemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adinkra Gems',
      debugShowCheckedModeBanner: false,
      theme: AdinkraTheme.theme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.levelSelect: (_) => const LevelSelectScreen(),
        AppRoutes.game: (_) => const GameScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
