// lib/presentation/providers/inventory_provider.dart
import 'package:flutter/material.dart';
import '../../core/enums/item_category.dart';
import '../../data/models/clothing_item.dart';
import '../../data/models/food_item.dart';
import '../../data/models/potion_item.dart';
import 'game_state_provider.dart';

class InventoryProvider extends ChangeNotifier {
  final GameStateProvider _gameStateProvider;
  
  // Equipped items
  String? _equippedHat;
  String? _equippedGlasses;
  String? _equippedOutfit;
  List<String> _equippedAccessories = [];
  String? _equippedBackground;
  
  InventoryProvider(this._gameStateProvider);
  
  // Getters
  String? get equippedHat => _equippedHat;
  String? get equippedGlasses => _equippedGlasses;
  String? get equippedOutfit => _equippedOutfit;
  List<String> get equippedAccessories => _equippedAccessories;
  String? get equippedBackground => _equippedBackground;
  
  // Check if owns item
  bool ownsItem(String itemId) {
    return _gameStateProvider.ownsItem(itemId);
  }
  
  // Check if can afford
  bool canAfford(int price) {
    return _gameStateProvider.canAfford(price);
  }
  
  // Buy food item
  bool buyFood(FoodItem food) {
    if (!_gameStateProvider.canAfford(food.price)) return false;
    if (_gameStateProvider.spendCoins(food.price)) {
      _gameStateProvider.addOwnedItem(food.id);
      notifyListeners();
      return true;
    }
    return false;
  }
  
  // Buy potion item
  bool buyPotion(PotionItem potion) {
    if (!_gameStateProvider.canAfford(potion.price)) return false;
    if (_gameStateProvider.spendCoins(potion.price)) {
      _gameStateProvider.addOwnedItem(potion.id);
      notifyListeners();
      return true;
    }
    return false;
  }
  
  // Buy clothing item
  bool buyClothing(ClothingItem item) {
    if (!_gameStateProvider.canAfford(item.price)) return false;
    if (_gameStateProvider.spendCoins(item.price)) {
      _gameStateProvider.addOwnedItem(item.id);
      notifyListeners();
      return true;
    }
    return false;
  }
  
  // Equip hat
  void equipHat(String? hatId) {
    if (hatId == null || ownsItem(hatId)) {
      _equippedHat = hatId;
      notifyListeners();
    }
  }
  
  // Equip glasses
  void equipGlasses(String? glassesId) {
    if (glassesId == null || ownsItem(glassesId)) {
      _equippedGlasses = glassesId;
      notifyListeners();
    }
  }
  
  // Equip outfit
  void equipOutfit(String? outfitId) {
    if (outfitId == null || ownsItem(outfitId)) {
      _equippedOutfit = outfitId;
      notifyListeners();
    }
  }
  
  // Equip accessory
  void equipAccessory(String accessoryId) {
    if (!ownsItem(accessoryId)) return;
    if (_equippedAccessories.length >= 3) {
      _equippedAccessories.removeAt(0);  // Remove first equipped
    }
    _equippedAccessories.add(accessoryId);
    notifyListeners();
  }
  
  // Unequip accessory
  void unequipAccessory(String accessoryId) {
    _equippedAccessories.remove(accessoryId);
    notifyListeners();
  }
  
  // Equip background
  void equipBackground(String? backgroundId) {
    if (backgroundId == null || ownsItem(backgroundId)) {
      _equippedBackground = backgroundId;
      notifyListeners();
    }
  }
  
  // Unequip all
  void unequipAll() {
    _equippedHat = null;
    _equippedGlasses = null;
    _equippedOutfit = null;
    _equippedAccessories = [];
    _equippedBackground = null;
    notifyListeners();
  }
  
  // Clear all (for reset)
  void clearAll() {
    _equippedHat = null;
    _equippedGlasses = null;
    _equippedOutfit = null;
    _equippedAccessories = [];
    _equippedBackground = null;
    notifyListeners();
  }
  
  // Get equipped items as list
  List<String> get allEquippedItems {
    final List<String> items = [];
    if (_equippedHat != null) items.add(_equippedHat!);
    if (_equippedGlasses != null) items.add(_equippedGlasses!);
    if (_equippedOutfit != null) items.add(_equippedOutfit!);
    items.addAll(_equippedAccessories);
    if (_equippedBackground != null) items.add(_equippedBackground!);
    return items;
  }
}
