// lib/data/models/pet_model.dart
import '../../core/constants/game_constants.dart';
import '../../core/enums/pet_state.dart';

class PetModel {
  final String id;
  String name;
  double hunger;
  double cleanliness;
  double fun;
  double energy;
  EvolutionLevel evolutionLevel;
  int experience;
  DateTime createdAt;
  DateTime updatedAt;
  
  // Equipment
  String? equippedHat;
  String? equippedGlasses;
  String? equippedOutfit;
  List<String> equippedAccessories;
  String? equippedBackground;
  String? eyeColor;
  String? bodyColor;
  
  PetModel({
    required this.id,
    required this.name,
    this.hunger = GameConstants.initialStatValue,
    this.cleanliness = GameConstants.initialStatValue,
    this.fun = GameConstants.initialStatValue,
    this.energy = GameConstants.initialStatValue,
    this.evolutionLevel = EvolutionLevel.baby,
    this.experience = 0,
    required this.createdAt,
    required this.updatedAt,
    this.equippedHat,
    this.equippedGlasses,
    this.equippedOutfit,
    List<String>? equippedAccessories,
    this.equippedBackground,
    this.eyeColor,
    this.bodyColor,
  }) : equippedAccessories = equippedAccessories ?? [];
  
  // Calculate average stats
  double get averageStats => (hunger + cleanliness + fun + energy) / 4;
  
  // Check if any stat is critical
  bool get hasCriticalStat =>
      hunger < GameConstants.criticalStatThreshold ||
      cleanliness < GameConstants.criticalStatThreshold ||
      fun < GameConstants.criticalStatThreshold ||
      energy < GameConstants.criticalStatThreshold;
  
  // Check if any stat is low
  bool get hasLowStat =>
      hunger < GameConstants.lowStatThreshold ||
      cleanliness < GameConstants.lowStatThreshold ||
      fun < GameConstants.lowStatThreshold ||
      energy < GameConstants.lowStatThreshold;
  
  // Determine current expression based on stats
  PouExpression get currentExpression {
    if (hasCriticalStat) return PouExpression.sad;
    if (hasLowStat) {
      if (hunger < GameConstants.lowStatThreshold) return PouExpression.hungry;
      if (cleanliness < GameConstants.lowStatThreshold) return PouExpression.dirty;
      if (energy < GameConstants.lowStatThreshold) return PouExpression.tired;
      return PouExpression.sad;
    }
    if (averageStats > GameConstants.highStatThreshold) return PouExpression.happy;
    return PouExpression.neutral;
  }
  
  // Apply decay to stats
  void applyDecay() {
    hunger = (hunger - GameConstants.hungerDecayAmount).clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    cleanliness = (cleanliness - GameConstants.cleanlinessDecayAmount).clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    fun = (fun - GameConstants.funDecayAmount).clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    energy = (energy - GameConstants.energyDecayAmount).clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    updatedAt = DateTime.now();
  }
  
  // Add experience and check evolution
  void addExperience(int amount) {
    experience += amount;
    _checkEvolution();
  }
  
  void _checkEvolution() {
    if (experience >= GameConstants.experienceToBaby &&
        evolutionLevel == EvolutionLevel.baby) {
      evolutionLevel = EvolutionLevel.child;
    } else if (experience >= GameConstants.experienceToChild &&
        evolutionLevel == EvolutionLevel.child) {
      evolutionLevel = EvolutionLevel.adult;
    } else if (experience >= GameConstants.experienceToAdult &&
        evolutionLevel == EvolutionLevel.adult) {
      evolutionLevel = EvolutionLevel.royal;
    }
  }
  
  // Update stats
  void updateStats({
    double? hunger,
    double? cleanliness,
    double? fun,
    double? energy,
  }) {
    if (hunger != null) this.hunger = hunger.clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    if (cleanliness != null) this.cleanliness = cleanliness.clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    if (fun != null) this.fun = fun.clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    if (energy != null) this.energy = energy.clamp(
      GameConstants.minStatValue,
      GameConstants.maxStatValue,
    );
    updatedAt = DateTime.now();
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'hunger': hunger,
    'cleanliness': cleanliness,
    'fun': fun,
    'energy': energy,
    'evolutionLevel': evolutionLevel.index,
    'experience': experience,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'equippedHat': equippedHat,
    'equippedGlasses': equippedGlasses,
    'equippedOutfit': equippedOutfit,
    'equippedAccessories': equippedAccessories,
    'equippedBackground': equippedBackground,
    'eyeColor': eyeColor,
    'bodyColor': bodyColor,
  };
  
  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
    id: json['id'],
    name: json['name'],
    hunger: (json['hunger'] as num).toDouble(),
    cleanliness: (json['cleanliness'] as num).toDouble(),
    fun: (json['fun'] as num).toDouble(),
    energy: (json['energy'] as num).toDouble(),
    evolutionLevel: EvolutionLevel.values[json['evolutionLevel']],
    experience: json['experience'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    equippedHat: json['equippedHat'],
    equippedGlasses: json['equippedGlasses'],
    equippedOutfit: json['equippedOutfit'],
    equippedAccessories: (json['equippedAccessories'] as List?)?.cast<String>(),
    equippedBackground: json['equippedBackground'],
    eyeColor: json['eyeColor'],
    bodyColor: json['bodyColor'],
  );
  
  factory PetModel.create({required String name}) {
    final now = DateTime.now();
    return PetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: now,
      updatedAt: now,
    );
  }
}
