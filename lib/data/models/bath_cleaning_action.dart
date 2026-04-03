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

  const BathCleaningAction({
    required this.type,
    required this.name,
    required this.emoji,
    required this.duration,
    required this.cleanlinessBonus,
    required this.energyCost,
    required this.funBonus,
  });

  // === PREDEFINED ACTIONS ===
  static const BathCleaningAction shower = BathCleaningAction(
    type: CleaningType.shower,
    name: 'Ducha',
    emoji: '🚿',
    duration: Duration(seconds: 10),
    cleanlinessBonus: 40,
    energyCost: 10,
    funBonus: 5,
  );

  static const BathCleaningAction bathtub = BathCleaningAction(
    type: CleaningType.bathtub,
    name: 'Bañera',
    emoji: '🛁',
    duration: Duration(seconds: 15),
    cleanlinessBonus: 60,
    energyCost: 5,
    funBonus: 10,
  );

  static const BathCleaningAction sink = BathCleaningAction(
    type: CleaningType.sink,
    name: 'Lavabo',
    emoji: '🚽',
    duration: Duration(seconds: 5),
    cleanlinessBonus: 20,
    energyCost: 0,
    funBonus: 5,
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