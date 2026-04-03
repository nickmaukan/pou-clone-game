// lib/presentation/providers/game_state_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/game_progress_model.dart';
import '../../data/services/database_service.dart';

class GameStateProvider extends ChangeNotifier {
  GameProgressModel? _progress;
  bool _isLoading = true;
  
  GameProgressModel? get progress => _progress;
  bool get isLoading => _isLoading;
  int get coins => _progress?.coins ?? 0;
  
  // Initialize
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    final db = await DatabaseService.getInstance();
    _progress = await db.getGameProgress();
    
    if (_progress == null) {
      _progress = GameProgressModel.create();
      await db.saveGameProgress(_progress!);
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Add coins
  void addCoins(int amount) {
    if (_progress == null) return;
    _progress!.addCoins(amount);
    _saveProgress();
    notifyListeners();
  }
  
  // Spend coins
  bool spendCoins(int amount) {
    if (_progress == null) return false;
    final success = _progress!.spendCoins(amount);
    if (success) {
      _saveProgress();
      notifyListeners();
    }
    return success;
  }
  
  // Check if can afford
  bool canAfford(int amount) {
    return (_progress?.coins ?? 0) >= amount;
  }
  
  // Update high score
  void updateHighScore(String game, int score) {
    if (_progress == null) return;
    _progress!.updateHighScore(game, score);
    _saveProgress();
    notifyListeners();
  }
  
  // Add owned item
  void addOwnedItem(String itemId) {
    if (_progress == null) return;
    _progress!.addOwnedItem(itemId);
    _saveProgress();
    notifyListeners();
  }
  
  // Check if owns item
  bool ownsItem(String itemId) {
    return _progress?.hasItem(itemId) ?? false;
  }
  
  // Save progress to database
  Future<void> _saveProgress() async {
    if (_progress == null) return;
    final db = await DatabaseService.getInstance();
    await db.saveGameProgress(_progress!);
  }
}
