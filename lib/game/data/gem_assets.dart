import '../../services/settings_service.dart';
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

  /// Returns the asset path for the given [gemType] and optional [version].
  /// Defaults to [SettingsService.tileVersion].
  static String pathFor(GemType type, {int? version}) {
    final v = version ?? SettingsService.tileVersion;
    if (v == 2) {
      switch (type) {
        case GemType.redFuntumfunefuDenkyemfunefu:
          return 'assets/tiles_v2/red_v2.png';
        case GemType.silverNsoromma:
          return 'assets/tiles_v2/silver_v2.png';
        case GemType.yellowSankofa:
          return 'assets/tiles_v2/yellow_v2.png';
        case GemType.purpleAkofena:
          return 'assets/tiles_v2/purple_v2.png';
        case GemType.greenGyeNyame:
          return 'assets/tiles_v2/green_gye_nyame_v2.png';
        case GemType.blueDwennimmen:
          return 'assets/tiles_v2/blue_v2.png';
      }
    } else {
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
  }

  /// Returns the asset path for the horizontal stripped special tile of the given [type].
  static String horizontalPathFor(GemType type) {
    switch (type) {
      case GemType.redFuntumfunefuDenkyemfunefu:
        return 'assets/stripped_tile_horizontal/red_stripped.png';
      case GemType.silverNsoromma:
        return 'assets/stripped_tile_horizontal/silver_stripped-removebg-preview.png';
      case GemType.yellowSankofa:
        return 'assets/stripped_tile_horizontal/yellow_stripped_v2-removebg-preview.png';
      case GemType.purpleAkofena:
        return 'assets/stripped_tile_horizontal/purple_stripped_-removebg-preview.png';
      case GemType.greenGyeNyame:
        return 'assets/stripped_tile_horizontal/green_stripped_-removebg-preview.png';
      case GemType.blueDwennimmen:
        return 'assets/stripped_tile_horizontal/blue_stripped_horizontal_-removebg-preview.png';
    }
  }

  /// Returns the asset path for the vertical stripped special tile of the given [type].
  static String verticalPathFor(GemType type) {
    switch (type) {
      case GemType.redFuntumfunefuDenkyemfunefu:
        return 'assets/stripped_tile_vertical/red_vertical_stripped_-removebg-preview.png';
      case GemType.silverNsoromma:
        return 'assets/stripped_tile_vertical/silver_vertical_stripped-removebg-preview.png';
      case GemType.yellowSankofa:
        return 'assets/stripped_tile_vertical/yellow_vertical_stripped-removebg-preview.png';
      case GemType.purpleAkofena:
        return 'assets/stripped_tile_vertical/purple_vertical_stripped_-removebg-preview.png';
      case GemType.greenGyeNyame:
        return 'assets/stripped_tile_vertical/green_vertical_strpped_-removebg-preview.png';
      case GemType.blueDwennimmen:
        return 'assets/stripped_tile_vertical/blue_vertical_stripped-removebg-preview.png';
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
