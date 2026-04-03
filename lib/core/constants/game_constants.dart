// lib/core/constants/game_constants.dart
class GameConstants {
  GameConstants._();
  
  // === STAT DECAY ===
  // Decay intervals (in seconds)
  static const int hungerDecayInterval = 180;    // Every 3 min
  static const int cleanlinessDecayInterval = 240; // Every 4 min
  static const int funDecayInterval = 150;       // Every 2.5 min
  static const int energyDecayInterval = 300;    // Every 5 min
  
  // Decay amounts
  static const double hungerDecayAmount = 5.0;
  static const double cleanlinessDecayAmount = 3.0;
  static const double funDecayAmount = 4.0;
  static const double energyDecayAmount = 2.0;
  
  // === STAT VALUES ===
  static const double initialStatValue = 100.0;
  static const double maxStatValue = 100.0;
  static const double minStatValue = 0.0;
  
  // === THRESHOLDS ===
  static const double lowStatThreshold = 25.0;
  static const double criticalStatThreshold = 10.0;
  static const double highStatThreshold = 75.0;
  
  // === POINTS ===
  static const int coinPerScore = 1;  // 1 coin per 100 points in mini-games
  
  // === EVOLUTION ===
  static const int experienceToBaby = 1000;
  static const int experienceToChild = 5000;
  static const int experienceToAdult = 20000;
  static const int experienceToRoyal = 50000;
  
  // === FOOD EFFECTS ===
  static const double minFoodEffect = 5.0;
  static const double maxFoodEffect = 50.0;
  
  // === POTION EFFECTS ===
  static const double minPotionEffect = 20.0;
  static const double maxPotionEffect = 100.0;
  
  // === GAME TIMERS ===
  static const Duration autoSaveInterval = Duration(seconds: 30);
  static const Duration gameTickInterval = Duration(seconds: 1);
}
