// lib/data/models/game_progress_model.dart
class GameProgressModel {
  final String id;
  int coins;
  int highScoreSkyJump;
  int highScoreMemory;
  int highScoreConnect;
  int highScorePouPopper;
  int highScoreFoodDrop;
  int totalGamesPlayed;
  List<String> unlockedAchievements;
  List<String> ownedItems;
  
  GameProgressModel({
    required this.id,
    this.coins = 100,  // Start with some coins
    this.highScoreSkyJump = 0,
    this.highScoreMemory = 0,
    this.highScoreConnect = 0,
    this.highScorePouPopper = 0,
    this.highScoreFoodDrop = 0,
    this.totalGamesPlayed = 0,
    List<String>? unlockedAchievements,
    List<String>? ownedItems,
  }) : unlockedAchievements = unlockedAchievements ?? [],
       ownedItems = ownedItems ?? ['food_apple'];
  
  void addCoins(int amount) {
    coins += amount;
  }
  
  bool spendCoins(int amount) {
    if (coins >= amount) {
      coins -= amount;
      return true;
    }
    return false;
  }
  
  void updateHighScore(String game, int score) {
    switch (game) {
      case 'skyjump':
        if (score > highScoreSkyJump) highScoreSkyJump = score;
        break;
      case 'memory':
        if (score > highScoreMemory) highScoreMemory = score;
        break;
      case 'connect':
        if (score > highScoreConnect) highScoreConnect = score;
        break;
      case 'poupopper':
        if (score > highScorePouPopper) highScorePouPopper = score;
        break;
      case 'fooddrop':
        if (score > highScoreFoodDrop) highScoreFoodDrop = score;
        break;
    }
  }
  
  void addOwnedItem(String itemId) {
    if (!ownedItems.contains(itemId)) {
      ownedItems.add(itemId);
    }
  }
  
  bool hasItem(String itemId) => ownedItems.contains(itemId);
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'coins': coins,
    'highScoreSkyJump': highScoreSkyJump,
    'highScoreMemory': highScoreMemory,
    'highScoreConnect': highScoreConnect,
    'highScorePouPopper': highScorePouPopper,
    'highScoreFoodDrop': highScoreFoodDrop,
    'totalGamesPlayed': totalGamesPlayed,
    'unlockedAchievements': unlockedAchievements,
    'ownedItems': ownedItems,
  };
  
  factory GameProgressModel.fromJson(Map<String, dynamic> json) => GameProgressModel(
    id: json['id'],
    coins: json['coins'] ?? 100,
    highScoreSkyJump: json['highScoreSkyJump'] ?? 0,
    highScoreMemory: json['highScoreMemory'] ?? 0,
    highScoreConnect: json['highScoreConnect'] ?? 0,
    highScorePouPopper: json['highScorePouPopper'] ?? 0,
    highScoreFoodDrop: json['highScoreFoodDrop'] ?? 0,
    totalGamesPlayed: json['totalGamesPlayed'] ?? 0,
    unlockedAchievements: (json['unlockedAchievements'] as List?)?.cast<String>(),
    ownedItems: (json['ownedItems'] as List?)?.cast<String>(),
  );
  
  factory GameProgressModel.create() => GameProgressModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
  );
}
