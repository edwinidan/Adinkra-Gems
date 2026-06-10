import 'package:flutter/material.dart';

import 'theme.dart';

class WovenBackground extends StatelessWidget {
  const WovenBackground({
    super.key,
    required this.child,
    this.overlayOpacity = 0.08,
  });

  final Widget child;
  final double overlayOpacity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AdinkraTheme.cream,
        image: DecorationImage(
          image: AssetImage('assets/new/adinkra gems home screen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AdinkraTheme.lightCream.withOpacity(overlayOpacity),
        ),
        child: child,
      ),
    );
  }
}
