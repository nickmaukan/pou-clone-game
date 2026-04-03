import '../entities/food.dart';
import '../entities/clothing_item.dart';
import '../entities/potion.dart';

abstract class InventoryRepository {
  Future<List<Food>> getFoods();
  Future<List<ClothingItem>> getClothingItems();
  Future<List<Potion>> getPotions();
  Future<void> addItem(String itemId, int quantity);
  Future<void> removeItem(String itemId, int quantity);
  Future<void> equipItem(String itemId);
  Future<void> unequipItem(String itemId);
}
