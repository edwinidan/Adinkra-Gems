/// Score thresholds that determine how many stars a player earns
/// when completing a level.
///
/// Stars are always awarded by score, regardless of the objective type.
/// Reaching [threeStar] earns 3 ★★★.
/// Reaching [twoStar] but not [threeStar] earns 2 ★★☆.
/// Reaching [oneStar] (the objective completion score) earns 1 ★☆☆.
class StarThresholds {
  /// Minimum score for 1 star (usually == the objective target).
  final int oneStar;

  /// Minimum score for 2 stars.
  final int twoStar;

  /// Minimum score for 3 stars.
  final int threeStar;

  const StarThresholds({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
  });

  /// Returns 1, 2, or 3 stars based on [score]. Returns 0 if below [oneStar].
  int starsFor(int score) {
    if (score >= threeStar) return 3;
    if (score >= twoStar) return 2;
    if (score >= oneStar) return 1;
    return 0;
  }

  @override
  String toString() =>
      'StarThresholds(1★: $oneStar, 2★: $twoStar, 3★: $threeStar)';
}
