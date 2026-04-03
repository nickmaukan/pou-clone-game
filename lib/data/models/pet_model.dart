// lib/data/models/pet_model.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../../core/enums/pet_state.dart';

class PetModel {
  String id;
  String name;
  double hunger;
  double cleanliness;
  double fun;
  double energy;
  int experience;
  EvolutionLevel evolutionLevel;
  DateTime createdAt;
  DateTime updatedAt;
  PetState state;

  // NEW: Sick state tracking
  bool isSick = false;
  DateTime? sickSince;

  PetModel({
    required this.id,
    required this.name,
    this.hunger = 100,
    this.cleanliness = 100,
    this.fun = 100,
    this.energy = 100,
    this.experience = 0,
    this.evolutionLevel = EvolutionLevel.baby,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.state = PetState.normal,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get needsMedicalAttention =>
      hunger < 10 || cleanliness < 10 || fun < 10 || energy < 10;

  bool get isFainted =>
      hunger <= 0 || cleanliness <= 0 || fun <= 0 || energy <= 0;

  // Stat accessors for compatibility with PetProvider
  double get hungerLevel => hunger;
  double get cleanlinessLevel => cleanliness;
  double get funLevel => fun;
  double get energyLevel => energy;

  void updateStats({
    double? hunger,
    double? cleanliness,
    double? fun,
    double? energy,
  }) {
    if (hunger != null) this.hunger = hunger.clamp(0, 100);
    if (cleanliness != null) this.cleanliness = cleanliness.clamp(0, 100);
    if (fun != null) this.fun = fun.clamp(0, 100);
    if (energy != null) this.energy = energy.clamp(0, 100);
    updatedAt = DateTime.now();
  }

  void update() {
    // Existing decay logic
    applyDecay();

    // NEW: Check for sick state
    if (needsMedicalAttention && !isSick) {
      isSick = true;
      sickSince = DateTime.now();
    }

    // NEW: Check for recovery (all stats above threshold)
    if (!needsMedicalAttention && isSick) {
      isSick = false;
      sickSince = null;
    }

    // NEW: If any stat at 0 for 60 seconds, pet faints
    if (isFainted && sickSince != null) {
      final elapsed = DateTime.now().difference(sickSince!).inSeconds;
      if (elapsed > 60) {
        state = PetState.fainted;
      }
    }

    // Save progress
    save();
  }

  void applyDecay() {
    const decayRates = {
      'hunger': 0.055, // ~10% per minute (6 per 108 sec)
      'cleanliness': 0.042, // ~7.5% per minute (4.5 per 108 sec)
      'fun': 0.067, // ~12% per minute (6.5 per 108 sec)
      'energy': 0.033, // ~6% per minute (3.6 per 108 sec)
    };

    final elapsed = DateTime.now().difference(updatedAt).inSeconds;
    final decayFactor = elapsed / 108;

    hunger = (hunger - (decayRates['hunger']! * decayFactor * 100)).clamp(0, 100);
    cleanliness = (cleanliness - (decayRates['cleanliness']! * decayFactor * 100)).clamp(0, 100);
    fun = (fun - (decayRates['fun']! * decayFactor * 100)).clamp(0, 100);
    energy = (energy - (decayRates['energy']! * decayFactor * 100)).clamp(0, 100);

    updatedAt = DateTime.now();
  }

  void addExperience(int amount) {
    experience += amount;
    _checkEvolution();
    updatedAt = DateTime.now();
  }

  void _checkEvolution() {
    final thresholds = {
      EvolutionLevel.baby: 100,
      EvolutionLevel.child: 500,
      EvolutionLevel.adult: 2000,
      EvolutionLevel.royal: 10000,
    };

    final nextLevel = {
      EvolutionLevel.baby: EvolutionLevel.child,
      EvolutionLevel.child: EvolutionLevel.adult,
      EvolutionLevel.adult: EvolutionLevel.royal,
      EvolutionLevel.royal: null,
    };

    final threshold = thresholds[evolutionLevel];
    if (threshold != null && experience >= threshold) {
      final next = nextLevel[evolutionLevel];
      if (next != null) {
        evolutionLevel = next;
      }
    }
  }

  // Get current expression based on state and stats
  PouExpression get expression {
    if (state == PetState.sick || isSick) {
      return PouExpression.sick;
    }
    if (state == PetState.fainted) {
      return PouExpression.sad;
    }

    // Normal expressions based on stats
    final avgStat = (hunger + cleanliness + fun + energy) / 4;

    if (avgStat > 75) return PouExpression.happy;
    if (avgStat > 50) return PouExpression.neutral;
    if (hunger < 25) return PouExpression.hungry;
    if (energy < 25) return PouExpression.tired;
    if (cleanliness < 25) return PouExpression.dirty;
    return PouExpression.neutral;
  }

  String get emoji {
    switch (expression) {
      case PouExpression.happy:
        return '😄';
      case PouExpression.sad:
        return '😢';
      case PouExpression.surprised:
        return '😲';
      case PouExpression.tired:
        return '😴';
      case PouExpression.hungry:
        return '😋';
      case PouExpression.dirty:
        return '🤢';
      case PouExpression.sick:  // NEW - sick emoji
        return '🤒';
      case PouExpression.neutral:
      default:
        return '🟤';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hunger': hunger,
      'cleanliness': cleanliness,
      'fun': fun,
      'energy': energy,
      'experience': experience,
      'evolutionLevel': evolutionLevel.index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'state': state.index,
      'isSick': isSick,
      'sickSince': sickSince?.toIso8601String(),
    };
  }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    final pet = PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      hunger: (json['hunger'] as num).toDouble(),
      cleanliness: (json['cleanliness'] as num).toDouble(),
      fun: (json['fun'] as num).toDouble(),
      energy: (json['energy'] as num).toDouble(),
      experience: json['experience'] as int? ?? 0,
      evolutionLevel: EvolutionLevel.values[json['evolutionLevel'] as int? ?? 0],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      state: PetState.values[json['state'] as int? ?? 0],
    );

    // NEW: Restore sick state
    if (json['isSick'] == true) {
      pet.isSick = true;
      if (json['sickSince'] != null) {
        pet.sickSince = DateTime.parse(json['sickSince'] as String);
      }
    }

    return pet;
  }

  String toJsonString() => jsonEncode(toJson());

  factory PetModel.fromJsonString(String jsonString) {
    return PetModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  Future<void> save() async {
    try {
      // TODO: Implement proper persistence
      // await DatabaseService.getInstance().savePet(this);
    } catch (e) {
      debugPrint('Error saving pet: $e');
    }
  }

  static Future<PetModel> create(String name) async {
    final pet = PetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    await pet.save();
    return pet;
  }
}