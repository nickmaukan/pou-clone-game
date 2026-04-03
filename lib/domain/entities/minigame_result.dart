class MinigameResult {
  final String gameId;
  final int score;
  final int highScore;
  final bool isNewHighScore;
  final DateTime playedAt;
  final int coinsEarned;

  const MinigameResult({
    required this.gameId,
    required this.score,
    required this.highScore,
    required this.isNewHighScore,
    required this.playedAt,
    required this.coinsEarned,
  });

  MinigameResult copyWith({
    String? gameId,
    int? score,
    int? highScore,
    bool? isNewHighScore,
    DateTime? playedAt,
    int? coinsEarned,
  }) {
    return MinigameResult(
      gameId: gameId ?? this.gameId,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      isNewHighScore: isNewHighScore ?? this.isNewHighScore,
      playedAt: playedAt ?? this.playedAt,
      coinsEarned: coinsEarned ?? this.coinsEarned,
    );
  }
}
