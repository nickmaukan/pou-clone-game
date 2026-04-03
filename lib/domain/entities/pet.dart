import '../enums/pet_state.dart';

class Pet {
  final String id;
  final String name;
  final double hunger;
  final double cleanliness;
  final double fun;
  final double energy;
  final int evolutionLevel;
  final int experience;
  final PetState state;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Pet({
    required this.id,
    required this.name,
    required this.hunger,
    required this.cleanliness,
    required this.fun,
    required this.energy,
    required this.evolutionLevel,
    required this.experience,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  Pet copyWith({
    String? id,
    String? name,
    double? hunger,
    double? cleanliness,
    double? fun,
    double? energy,
    int? evolutionLevel,
    int? experience,
    PetState? state,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      hunger: hunger ?? this.hunger,
      cleanliness: cleanliness ?? this.cleanliness,
      fun: fun ?? this.fun,
      energy: energy ?? this.energy,
      evolutionLevel: evolutionLevel ?? this.evolutionLevel,
      experience: experience ?? this.experience,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isHungry => hunger < 25;
  bool get isDirty => cleanliness < 25;
  bool get isTired => energy < 25;
  bool get isSad => fun < 25;

  double get overallHealth =>
      (hunger + cleanliness + fun + energy) / 4;
}
