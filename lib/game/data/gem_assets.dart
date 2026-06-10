import '../models/gem_type.dart';

/// Maps each [GemType] to its Flutter asset path.
///
/// Used by both the Flutter widget preview (Phase 3) and the
/// Flame [TileComponent] sprite loader (Phase 5).
///
/// All paths are relative to the project root as registered in pubspec.yaml.
class GemAssets {
  GemAssets._();

  // ── Individual asset paths ─────────────────────────────────────────────

  static const String redFuntumfunefuDenkyemfunefu =
      'assets/tiles/red_funtumfunefu_denkyemfunefu.png';

  static const String silverNsoromma =
      'assets/tiles/silver_nsoromma.png';

  static const String yellowSankofa =
      'assets/tiles/yellow_sankofa.png';

  static const String purpleAkofena =
      'assets/tiles/purple_akofena.png';

  static const String greenGyeNyame =
      'assets/tiles/green_gye_nyame.png';

  static const String blueDwennimmen =
      'assets/tiles/blue_dwennimmen.png';

  // ── Lookup ─────────────────────────────────────────────────────────────

  /// Returns the asset path for the given [gemType].
  static String pathFor(GemType type) {
    switch (type) {
      case GemType.redFuntumfunefuDenkyemfunefu:
        return redFuntumfunefuDenkyemfunefu;
      case GemType.silverNsoromma:
        return silverNsoromma;
      case GemType.yellowSankofa:
        return yellowSankofa;
      case GemType.purpleAkofena:
        return purpleAkofena;
      case GemType.greenGyeNyame:
        return greenGyeNyame;
      case GemType.blueDwennimmen:
        return blueDwennimmen;
    }
  }

  /// Ordered list of all asset paths — same order as [GemType.values].
  static const List<String> all = [
    redFuntumfunefuDenkyemfunefu,
    silverNsoromma,
    yellowSankofa,
    purpleAkofena,
    greenGyeNyame,
    blueDwennimmen,
  ];
}
