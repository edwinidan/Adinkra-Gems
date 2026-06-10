import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../app/woven_background.dart';
import '../../services/settings_service.dart';

/// Settings screen — toggles persistent sound and music settings.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = SettingsService.soundEnabled;
  bool _musicEnabled = SettingsService.musicEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdinkraTheme.cream,
      appBar: AppBar(
        backgroundColor: AdinkraTheme.cream,
        title: const Text(
          'Settings',
          style: TextStyle(color: AdinkraTheme.darkCocoa, letterSpacing: 2),
        ),
        iconTheme: const IconThemeData(color: AdinkraTheme.darkCocoa),
        elevation: 0,
      ),
      body: WovenBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Audio',
              style: TextStyle(
                color: AdinkraTheme.terracotta,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              id: 'toggle_sound',
              label: 'Sound Effects',
              icon: Icons.volume_up_rounded,
              value: _soundEnabled,
              onChanged: (v) async {
                await SettingsService.setSoundEnabled(v);
                setState(() => _soundEnabled = v);
              },
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              id: 'toggle_music',
              label: 'Music',
              icon: Icons.music_note_rounded,
              value: _musicEnabled,
              onChanged: (v) async {
                await SettingsService.setMusicEnabled(v);
                setState(() => _musicEnabled = v);
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Note: Settings are saved automatically.',
              style: TextStyle(color: AdinkraTheme.cocoa, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.id,
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String id;
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AdinkraTheme.lightCream.withOpacity(0.88),
        border: Border.all(color: AdinkraTheme.cocoa.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AdinkraTheme.terracotta, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AdinkraTheme.darkCocoa,
                fontSize: 15,
              ),
            ),
          ),
          Switch(
            key: ValueKey(id),
            value: value,
            onChanged: onChanged,
            activeColor: AdinkraTheme.terracotta,
          ),
        ],
      ),
    );
  }
}
