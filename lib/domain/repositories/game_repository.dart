import '../entities/minigame_result.dart';

abstract class GameRepository {
  Future<int> getCoins();
  Future<void> addCoins(int amount);
  Future<void> spendCoins(int amount);
  Future<void> saveMinigameResult(MinigameResult result);
  Future<Map<String, int>> getHighScores();
  Future<int> getTotalGamesPlayed();
  Future<void> incrementGamesPlayed();
}
