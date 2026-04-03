// lib/data/models/bath_cleaning_action.dart
enum CleaningType { shower, bathtub, sink }

class BathCleaningAction {
  final CleaningType type;
  final String name;
  final String emoji;
  final Duration duration;
  final double cleanlinessBonus;
  final double energyCost;
  final double funBonus;
  final int coinCost;  // ADDED

  const BathCleaningAction({
    required this.type,
    required this.name,
    required this.emoji,
    required this.duration,
    required this.cleanlinessBonus,
    required this.energyCost,
    required this.funBonus,
    this.coinCost = 0,  // DEFAULT 0 (free)
  });

  // === PREDEFINED ACTIONS ===
  static const BathCleaningAction shower = BathCleaningAction(
    type: CleaningType.shower,
    name: 'Ducha',
    emoji: '🚿',
    duration: Duration(seconds: 5),  // REDUCIDO from 10 to 5
    cleanlinessBonus: 20,  // REDUCIDO from 40 to 20
    energyCost: 10,
    funBonus: 5,
    coinCost: 3,  // ADDED coin cost
  );

  static const BathCleaningAction bathtub = BathCleaningAction(
    type: CleaningType.bathtub,
    name: 'Bañera',
    emoji: '🛁',
    duration: Duration(seconds: 8),  // REDUCIDO from 15 to 8
    cleanlinessBonus: 30,  // REDUCIDO from 60 to 30
    energyCost: 5,
    funBonus: 10,
    coinCost: 5,  // ADDED coin cost
  );

  static const BathCleaningAction sink = BathCleaningAction(
    type: CleaningType.sink,
    name: 'Lavabo',
    emoji: '🚽',
    duration: Duration(seconds: 3),  // REDUCIDO from 5 to 3
    cleanlinessBonus: 10,  // REDUCIDO from 20 to 10
    energyCost: 0,
    funBonus: 5,
    coinCost: 2,  // ADDED coin cost
  );

  static List<BathCleaningAction> get allActions =>
      [shower, bathtub, sink];

  static BathCleaningAction? getByType(CleaningType type) {
    switch (type) {
      case CleaningType.shower:
        return shower;
      case CleaningType.bathtub:
        return bathtub;
      case CleaningType.sink:
        return sink;
    }
  }
}