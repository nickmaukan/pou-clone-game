// lib/data/models/food_item.dart
import 'package:flutter/material.dart';
import '../../core/enums/item_category.dart';
import '../../core/theme/app_colors.dart';

class FoodItem {
  final String id;
  final String name;
  final String emoji;
  final int price;
  final double hungerRestore;
  final double energyRestore;
  final double funRestore;
  final double cleanlinessRestore;
  final int experienceGained;
  final FoodCategory category;
  final bool isAvailable;
  final bool isSpecial;
  final Duration? cooldown;

  const FoodItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    required this.hungerRestore,
    this.energyRestore = 0,
    this.funRestore = 0,
    this.cleanlinessRestore = 0,
    this.experienceGained = 1,
    required this.category,
    this.isAvailable = true,
    this.isSpecial = false,
    this.cooldown,
  });
}

enum FoodCategory {
  fruits,
  fastFood,
  snacks,
  drinks,
  special,
}

extension FoodCategoryExtension on FoodCategory {
  String get displayName {
    switch (this) {
      case FoodCategory.fruits:
        return 'Frutas';
      case FoodCategory.fastFood:
        return 'Comida Rápida';
      case FoodCategory.snacks:
        return 'Snacks';
      case FoodCategory.drinks:
        return 'Bebidas';
      case FoodCategory.special:
        return 'Especial';
    }
  }

  String get emoji {
    switch (this) {
      case FoodCategory.fruits:
        return '🍎';
      case FoodCategory.fastFood:
        return '🍕';
      case FoodCategory.snacks:
        return '🍿';
      case FoodCategory.drinks:
        return '🥤';
      case FoodCategory.special:
        return '⭐';
    }
  }
}

class FoodCatalog {
  // === FRUTAS (8) ===
  static const List<FoodItem> fruits = [
    FoodItem(id: 'fruit_apple', name: 'Manzana', emoji: '🍎', price: 5, hungerRestore: 15, category: FoodCategory.fruits),
    FoodItem(id: 'fruit_banana', name: 'Banana', emoji: '🍌', price: 5, hungerRestore: 10, energyRestore: 5, category: FoodCategory.fruits),
    FoodItem(id: 'fruit_orange', name: 'Naranja', emoji: '🍊', price: 6, hungerRestore: 12, category: FoodCategory.fruits),
    FoodItem(id: 'fruit_grapes', name: 'Uvas', emoji: '🍇', price: 8, hungerRestore: 18, category: FoodCategory.fruits),
    FoodItem(id: 'fruit_strawberry', name: 'Fresa', emoji: '🍓', price: 7, hungerRestore: 10, funRestore: 5, category: FoodCategory.fruits),
    FoodItem(id: 'fruit_watermelon', name: 'Sandía', emoji: '🍉', price: 10, hungerRestore: 20, category: FoodCategory.fruits),
    FoodItem(id: 'fruit_pineapple', name: 'Piña', emoji: '🍍', price: 8, hungerRestore: 15, category: FoodCategory.fruits),
    FoodItem(id: 'fruit_cherry', name: 'Cerezas', emoji: '🍒', price: 6, hungerRestore: 8, funRestore: 3, category: FoodCategory.fruits),
  ];

  // === COMIDA RÁPIDA (8) ===
  static const List<FoodItem> fastFood = [
    FoodItem(id: 'fast_pizza', name: 'Pizza', emoji: '🍕', price: 15, hungerRestore: 25, category: FoodCategory.fastFood),
    FoodItem(id: 'fast_burger', name: 'Hamburguesa', emoji: '🍔', price: 18, hungerRestore: 30, category: FoodCategory.fastFood),
    FoodItem(id: 'fast_hotdog', name: 'Hotdog', emoji: '🌭', price: 12, hungerRestore: 22, category: FoodCategory.fastFood),
    FoodItem(id: 'fast_fries', name: 'Papas', emoji: '🍟', price: 10, hungerRestore: 18, category: FoodCategory.fastFood),
    FoodItem(id: 'fast_taco', name: 'Taco', emoji: '🌮', price: 14, hungerRestore: 20, category: FoodCategory.fastFood),
    FoodItem(id: 'fast_sushi', name: 'Sushi', emoji: '🍣', price: 20, hungerRestore: 15, category: FoodCategory.fastFood),
    FoodItem(id: 'fast_ramen', name: 'Ramen', emoji: '🍜', price: 18, hungerRestore: 28, category: FoodCategory.fastFood),
    FoodItem(id: 'fast_chicken', name: 'Pollo', emoji: '🍗', price: 16, hungerRestore: 26, category: FoodCategory.fastFood),
  ];

  // === SNACKS (8) ===
  static const List<FoodItem> snacks = [
    FoodItem(id: 'snack_popcorn', name: 'Palomitas', emoji: '🍿', price: 8, hungerRestore: 10, funRestore: 5, category: FoodCategory.snacks),
    FoodItem(id: 'snack_icecream', name: 'Helado', emoji: '🍦', price: 10, hungerRestore: 8, funRestore: 10, category: FoodCategory.snacks),
    FoodItem(id: 'snack_cookie', name: 'Galleta', emoji: '🍪', price: 6, hungerRestore: 10, category: FoodCategory.snacks),
    FoodItem(id: 'snack_chocolate', name: 'Chocolate', emoji: '🍫', price: 8, hungerRestore: 12, funRestore: 3, category: FoodCategory.snacks),
    FoodItem(id: 'snack_candy', name: 'Dulce', emoji: '🍬', price: 4, hungerRestore: 6, funRestore: 8, category: FoodCategory.snacks),
    FoodItem(id: 'snack_pretzel', name: 'Pretzel', emoji: '🥨', price: 7, hungerRestore: 10, funRestore: 5, category: FoodCategory.snacks),
    FoodItem(id: 'snack_chips', name: 'Chips', emoji: '🥔', price: 7, hungerRestore: 8, category: FoodCategory.snacks),
    FoodItem(id: 'snack_jellybean', name: 'Grageas', emoji: '🫘', price: 5, hungerRestore: 5, funRestore: 5, category: FoodCategory.snacks),
  ];

  // === BEBIDAS (6) ===
  static const List<FoodItem> drinks = [
    FoodItem(id: 'drink_water', name: 'Agua', emoji: '💧', price: 3, hungerRestore: 10, category: FoodCategory.drinks),
    FoodItem(id: 'drink_juice', name: 'Jugo', emoji: '🧃', price: 6, hungerRestore: 12, category: FoodCategory.drinks),
    FoodItem(id: 'drink_soda', name: 'Soda', emoji: '🥤', price: 5, hungerRestore: 8, energyRestore: 5, category: FoodCategory.drinks),
    FoodItem(id: 'drink_milkshake', name: 'Malteada', emoji: '🥛', price: 12, hungerRestore: 15, energyRestore: 8, category: FoodCategory.drinks),
    FoodItem(id: 'drink_coffee', name: 'Café', emoji: '☕', price: 8, hungerRestore: 5, energyRestore: 15, category: FoodCategory.drinks),
    FoodItem(id: 'drink_tea', name: 'Té', emoji: '🍵', price: 6, hungerRestore: 8, energyRestore: 10, category: FoodCategory.drinks),
  ];

  // === ESPECIAL (4) ===
  static const List<FoodItem> special = [
    FoodItem(id: 'special_steak', name: 'Steak', emoji: '🥩', price: 50, hungerRestore: 40, experienceGained: 5, category: FoodCategory.special, isSpecial: true, cooldown: Duration(minutes: 30)),
    FoodItem(id: 'special_lobster', name: 'Langosta', emoji: '🦞', price: 100, hungerRestore: 50, funRestore: 10, experienceGained: 10, category: FoodCategory.special, isSpecial: true, cooldown: Duration(hours: 1)),
    FoodItem(id: 'special_golden_apple', name: 'Manzana Dorada', emoji: '🍏', price: 200, hungerRestore: 100, experienceGained: 20, category: FoodCategory.special, isSpecial: true, cooldown: Duration(hours: 24)),
    FoodItem(id: 'special_rainbow_candy', name: 'Arcoíris Candy', emoji: '🌈', price: 150, hungerRestore: 30, energyRestore: 30, funRestore: 30, cleanlinessRestore: 30, experienceGained: 25, category: FoodCategory.special, isSpecial: true, cooldown: Duration(hours: 12)),
  ];

  static List<FoodItem> getAll() {
    return [...fruits, ...fastFood, ...snacks, ...drinks, ...special];
  }

  static List<FoodItem> getByCategory(FoodCategory category) {
    switch (category) {
      case FoodCategory.fruits:
        return fruits;
      case FoodCategory.fastFood:
        return fastFood;
      case FoodCategory.snacks:
        return snacks;
      case FoodCategory.drinks:
        return drinks;
      case FoodCategory.special:
        return special;
    }
  }

  static FoodItem? getById(String id) {
    try {
      return getAll().firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
}