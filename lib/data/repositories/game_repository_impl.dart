import '../../domain/entities/minigame_result.dart';
import '../../domain/repositories/game_repository.dart';
import '../models/game_progress_model.dart';
import '../services/database_service.dart';

class GameRepositoryImpl implements GameRepository {
  final DatabaseService _databaseService;

  GameRepositoryImpl(this._databaseService);

  @override
  Future<int> getCoins() async {
    final result = await _databaseService.query('game_progress');
    if (result == null) return 100;
    final progress = GameProgressModel.fromMap(result);
    return progress.coins;
  }

  @override
  Future<void> addCoins(int amount) async {
    final current = await getCoins();
    await _databaseService.update(
      'game_progress',
      {'coins': current + amount},
      where: 'id = ?',
      whereArgs: ['game_progress'],
    );
  }

  @override
  Future<void> spendCoins(int amount) async {
    final current = await getCoins();
    if (current >= amount) {
      await _databaseService.update(
        'game_progress',
        {'coins': current - amount},
        where: 'id = ?',
        whereArgs: ['game_progress'],
      );
    }
  }

  @override
  Future<void> saveMinigameResult(MinigameResult result) async {
    final progress = await _databaseService.query('game_progress');
    if (progress == null) {
      await _databaseService.insert('game_progress', {
        'id': 'game_progress',
        'coins': 0,
        'high_score_skyjump': result.gameId == 'sky_jump' ? result.score : 0,
        'high_score_memory': result.gameId == 'memory' ? result.score : 0,
        'high_score_connect': result.gameId == 'connect' ? result.score : 0,
        'total_games_played': 1,
        'achievements': '[]',
        'unlocked_items': '[]',
      });
    } else {
      final currentProgress = GameProgressModel.fromMap(progress);
      final updated = currentProgress.copyWith(
        highScoreSkyjump: result.gameId == 'sky_jump' && result.isNewHighScore
            ? result.score
            : currentProgress.highScoreSkyjump,
        highScoreMemory: result.gameId == 'memory' && result.isNewHighScore
            ? result.score
            : currentProgress.highScoreMemory,
        highScoreConnect: result.gameId == 'connect' && result.isNewHighScore
            ? result.score
            : currentProgress.highScoreConnect,
        totalGamesPlayed: currentProgress.totalGamesPlayed + 1,
      );
      await _databaseService.update('game_progress', updated.toMap());
    }
  }

  @override
  Future<Map<String, int>> getHighScores() async {
    final result = await _databaseService.query('game_progress');
    if (result == null) return {};
    final progress = GameProgressModel.fromMap(result);
    return {
      'sky_jump': progress.highScoreSkyjump,
      'memory': progress.highScoreMemory,
      'connect': progress.highScoreConnect,
    };
  }

  @override
  Future<int> getTotalGamesPlayed() async {
    final result = await _databaseService.query('game_progress');
    if (result == null) return 0;
    final progress = GameProgressModel.fromMap(result);
    return progress.totalGamesPlayed;
  }

  @override
  Future<void> incrementGamesPlayed() async {
    final result = await _databaseService.query('game_progress');
    if (result != null) {
      final progress = GameProgressModel.fromMap(result);
      await _databaseService.update(
        'game_progress',
        {'total_games_played': progress.totalGamesPlayed + 1},
        where: 'id = ?',
        whereArgs: ['game_progress'],
      );
    }
  }
}
