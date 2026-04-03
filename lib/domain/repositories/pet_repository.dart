import '../entities/pet.dart';

abstract class PetRepository {
  Future<Pet?> getPet();
  Future<void> savePet(Pet pet);
  Future<void> updatePetStats({
    double? hunger,
    double? cleanliness,
    double? fun,
    double? energy,
  });
  Future<void> deletePet(String id);
}
