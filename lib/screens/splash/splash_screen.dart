import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../app/woven_background.dart';

/// Splash screen — shown on app launch.
///
/// Plays a fade + scale-in animation then navigates to Home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn);

    // Text animation (delayed)
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    // Chain animations
    _logoCtrl.forward().then((_) {
      if (mounted) _textCtrl.forward();
    });

    // Navigate after 2.8s
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdinkraTheme.cream,
      body: WovenBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Gem logo ──
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(scale: _logoScale, child: _SplashGem()),
              ),

              const SizedBox(height: 32),

              // ── Title ──
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      const Text(
                        'ADINKRA GEMS',
                        style: TextStyle(
                          color: AdinkraTheme.darkCocoa,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Match the Sacred Symbols',
                        style: TextStyle(
                          color: AdinkraTheme.cocoa,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashGem extends StatefulWidget {
  @override
  State<_SplashGem> createState() => _SplashGemState();
}

class _SplashGemState extends State<_SplashGem>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _glow = Tween<double>(
      begin: 18.0,
      end: 38.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) => Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              AdinkraTheme.lightCream,
              AdinkraTheme.warmGold,
              AdinkraTheme.terracotta,
            ],
            stops: [0.0, 0.45, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AdinkraTheme.cocoa.withOpacity(0.3),
              blurRadius: _glow.value,
              spreadRadius: _glow.value * 0.25,
            ),
          ],
        ),
        child: const Icon(
          Icons.diamond_rounded,
          size: 64,
          color: AdinkraTheme.darkCocoa,
        ),
      ),
    );
  }
}
