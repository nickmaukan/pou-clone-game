import 'package:uuid/uuid.dart';
import '../../core/constants/game_constants.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../models/pet_model.dart';
import '../services/database_service.dart';

class PetRepositoryImpl implements PetRepository {
  final DatabaseService _databaseService;
  final _uuid = const Uuid();

  PetRepositoryImpl(this._databaseService);

  @override
  Future<Pet?> getPet() async {
    final result = await _databaseService.query('pets');
    if (result == null) return null;
    return PetModel.fromMap(result);
  }

  @override
  Future<void> savePet(Pet pet) async {
    final model = PetModel.fromEntity(pet);
    await _databaseService.insert('pets', model.toMap());
  }

  @override
  Future<void> updatePetStats({
    double? hunger,
    double? cleanliness,
    double? fun,
    double? energy,
  }) async {
    final pet = await getPet();
    if (pet == null) return;

    final updatedPet = pet.copyWith(
      hunger: hunger?.clamp(GameConstants.minStatValue, GameConstants.maxStatValue) ?? pet.hunger,
      cleanliness: cleanliness?.clamp(GameConstants.minStatValue, GameConstants.maxStatValue) ?? pet.cleanliness,
      fun: fun?.clamp(GameConstants.minStatValue, GameConstants.maxStatValue) ?? pet.fun,
      energy: energy?.clamp(GameConstants.minStatValue, GameConstants.maxStatValue) ?? pet.energy,
      updatedAt: DateTime.now(),
    );

    await savePet(updatedPet);
  }

  @override
  Future<void> deletePet(String id) async {
    await _databaseService.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  Future<Pet> createPet(String name) async {
    final now = DateTime.now();
    final pet = Pet(
      id: _uuid.v4(),
      name: name,
      hunger: GameConstants.initialStatValue,
      cleanliness: GameConstants.initialStatValue,
      fun: GameConstants.initialStatValue,
      energy: GameConstants.initialStatValue,
      evolutionLevel: 1,
      experience: 0,
      state: pet_state.idle,
      createdAt: now,
      updatedAt: now,
    );
    await savePet(pet);
    return pet;
  }
}
