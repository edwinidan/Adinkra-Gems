import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../app/woven_background.dart';

/// Home screen — entry point after the splash.
///
/// Shows the game title, Play, Settings, and an About section.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  void _showAbout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _AboutSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdinkraTheme.cream,
      body: WovenBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              // SizedBox.expand gives the Column a full-width constraint so
              // crossAxisAlignment: center actually works on screen.
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // ── Branded logo image ──
                    Image.asset(
                      'assets/adinkra tile homescreen pnd.png',
                      width: 364,
                      fit: BoxFit.contain,
                    ),

                    const Spacer(flex: 1),

                    // ── Buttons ──
                    _HomeButton(
                      id: 'btn_play',
                      label: 'PLAY',
                      icon: Icons.play_arrow_rounded,
                      isPrimary: true,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.levelSelect),
                    ),
                    const SizedBox(height: 14),
                    _HomeButton(
                      id: 'btn_settings',
                      label: 'SETTINGS',
                      icon: Icons.settings_rounded,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.settings),
                    ),
                    const SizedBox(height: 14),
                    _HomeButton(
                      id: 'btn_about',
                      label: 'ABOUT',
                      icon: Icons.info_outline_rounded,
                      onPressed: _showAbout,
                    ),

                    const Spacer(flex: 1),

                    // ── Footer ──
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Inspired by Ghanaian Adinkra symbols',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AdinkraTheme.cocoa,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// ─────────────────────────────────────────────
// Home screen button
// ─────────────────────────────────────────────
class _HomeButton extends StatelessWidget {
  const _HomeButton({
    required this.id,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String id;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 52,
      child: ElevatedButton.icon(
        key: ValueKey(id),
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AdinkraTheme.terracotta
              : AdinkraTheme.lightCream,
          foregroundColor: isPrimary
              ? AdinkraTheme.lightCream
              : AdinkraTheme.darkCocoa,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: AdinkraTheme.cocoa, width: 1.5),
          ),
          elevation: isPrimary ? 10 : 0,
          shadowColor: AdinkraTheme.cocoa.withOpacity(0.35),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// About bottom sheet — scrollable to prevent overflow
// ─────────────────────────────────────────────
class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        decoration: BoxDecoration(
          color: AdinkraTheme.lightCream,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AdinkraTheme.cocoa.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AdinkraTheme.cocoa.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Icon(
                Icons.diamond_rounded,
                color: AdinkraTheme.terracotta,
                size: 36,
              ),
              const SizedBox(height: 14),

              const Text(
                'ADINKRA GEMS',
                style: TextStyle(
                  color: AdinkraTheme.darkCocoa,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 14),

              const Text(
                'Adinkra Gems is a match-3 puzzle game inspired by '
                'the sacred Adinkra symbols of the Akan people of Ghana. '
                'Each gem represents a powerful symbol: wisdom, courage, '
                'love, and unity. Match them to unlock their power.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AdinkraTheme.cocoa,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // Symbol guide
              _SymbolRow(
                symbol: 'Gye Nyame',
                meaning: 'Supremacy of God',
                color: const Color(0xFF4CAF50),
              ),
              _SymbolRow(
                symbol: 'Sankofa',
                meaning: 'Learn from the past',
                color: const Color(0xFFFFD700),
              ),
              _SymbolRow(
                symbol: 'Akofena',
                meaning: 'Courage and authority',
                color: const Color(0xFF9C27B0),
              ),
              _SymbolRow(
                symbol: 'Dwennimmen',
                meaning: 'Strength and humility',
                color: const Color(0xFF2196F3),
              ),
              _SymbolRow(
                symbol: 'Nsoromma',
                meaning: 'Child of the heavens',
                color: AdinkraTheme.cocoa,
              ),
              _SymbolRow(
                symbol: 'Funtumfunefu',
                meaning: 'Unity in diversity',
                color: const Color(0xFFF44336),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolRow extends StatelessWidget {
  const _SymbolRow({
    required this.symbol,
    required this.meaning,
    required this.color,
  });

  final String symbol;
  final String meaning;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            symbol,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '— $meaning',
              style: const TextStyle(color: AdinkraTheme.cocoa, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
