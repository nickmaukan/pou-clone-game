// lib/data/models/potion_item.dart
import 'package:flutter/material.dart';
import '../../core/enums/item_category.dart';

class PotionItem {
  final String id;
  final String name;
  final String emoji;
  final int price;
  final double hungerRestore;
  final double energyRestore;
  final double funRestore;
  final double cleanlinessRestore;
  final int experienceGained;
  final Color color;
  final PotionStrength strength;
  final bool isAvailable;

  const PotionItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.hungerRestore = 0,
    this.energyRestore = 0,
    this.funRestore = 0,
    this.cleanlinessRestore = 0,
    this.experienceGained = 0,
    required this.color,
    required this.strength,
    this.isAvailable = true,
  });

  bool get hasAnyEffect =>
      hungerRestore > 0 || energyRestore > 0 ||
      funRestore > 0 || cleanlinessRestore > 0;
}

enum PotionStrength { basic, strong, special }

extension PotionStrengthExtension on PotionStrength {
  String get displayName {
    switch (this) {
      case PotionStrength.basic:
        return 'Basic';
      case PotionStrength.strong:
        return 'Strong';
      case PotionStrength.special:
        return 'Special';
    }
  }
}

class PotionCatalog {
  // === POCIONES BÁSICAS (4) ===
  static const List<PotionItem> basic = [
    PotionItem(
      id: 'potion_blue',
      name: 'Poción Azul',
      emoji: '🧪',
      price: 10,
      funRestore: 30,
      color: Colors.blue,
      strength: PotionStrength.basic,
    ),
    PotionItem(
      id: 'potion_red',
      name: 'Poción Roja',
      emoji: '🧪',
      price: 10,
      hungerRestore: 30,
      color: Colors.red,
      strength: PotionStrength.basic,
    ),
    PotionItem(
      id: 'potion_green',
      name: 'Poción Verde',
      emoji: '🧪',
      price: 10,
      cleanlinessRestore: 30,
      color: Colors.green,
      strength: PotionStrength.basic,
    ),
    PotionItem(
      id: 'potion_yellow',
      name: 'Poción Amarilla',
      emoji: '🧪',
      price: 10,
      energyRestore: 30,
      color: Colors.yellow,
      strength: PotionStrength.basic,
    ),
  ];

  // === POCIONES FUERTES (4) ===
  static const List<PotionItem> strong = [
    PotionItem(
      id: 'potion_blue_strong',
      name: 'Poción Azul Fuerte',
      emoji: '💙',
      price: 30,
      funRestore: 60,
      color: Colors.blue,
      strength: PotionStrength.strong,
    ),
    PotionItem(
      id: 'potion_red_strong',
      name: 'Poción Roja Fuerte',
      emoji: '❤️',
      price: 30,
      hungerRestore: 60,
      color: Colors.red,
      strength: PotionStrength.strong,
    ),
    PotionItem(
      id: 'potion_green_strong',
      name: 'Poción Verde Fuerte',
      emoji: '💚',
      price: 30,
      cleanlinessRestore: 60,
      color: Colors.green,
      strength: PotionStrength.strong,
    ),
    PotionItem(
      id: 'potion_yellow_strong',
      name: 'Poción Amarilla Fuerte',
      emoji: '💛',
      price: 30,
      energyRestore: 60,
      color: Colors.yellow,
      strength: PotionStrength.strong,
    ),
  ];

  // === POCIONES ESPECIALES (8) ===
  static const List<PotionItem> special = [
    PotionItem(
      id: 'potion_rainbow',
      name: 'Arcoíris',
      emoji: '🌈',
      price: 50,
      hungerRestore: 25,
      energyRestore: 25,
      funRestore: 25,
      cleanlinessRestore: 25,
      color: Colors.purple,
      strength: PotionStrength.special,
    ),
    PotionItem(
      id: 'potion_sleep',
      name: 'Sueño',
      emoji: '💤',
      price: 40,
      energyRestore: 100,
      color: Colors.indigo,
      strength: PotionStrength.special,
    ),
    PotionItem(
      id: 'potion_vitamin',
      name: 'Vitamina',
      emoji: '💊',
      price: 35,
      hungerRestore: 50,
      energyRestore: 50,
      funRestore: 50,
      cleanlinessRestore: 50,
      experienceGained: 10,
      color: Colors.orange,
      strength: PotionStrength.special,
    ),
    PotionItem(
      id: 'potion_miracle',
      name: 'Milagro',
      emoji: '✨',
      price: 100,
      hungerRestore: 100,
      energyRestore: 100,
      funRestore: 100,
      cleanlinessRestore: 100,
      experienceGained: 50,
      color: Colors.amber,
      strength: PotionStrength.special,
    ),
    PotionItem(
      id: 'potion_love',
      name: 'Amor',
      emoji: '❤️',
      price: 25,
      hungerRestore: 10,
      funRestore: 30,
      color: Colors.pink,
      strength: PotionStrength.special,
    ),
    PotionItem(
      id: 'potion_energy_drink',
      name: 'Bebida Energética',
      emoji: '🥤',
      price: 20,
      energyRestore: 50,
      funRestore: 10,
      color: const Color(0xFF00FF00),
      strength: PotionStrength.special,
    ),
    PotionItem(
      id: 'potion_speed',
      name: 'Velocidad',
      emoji: '⚡',
      price: 45,
      energyRestore: 30,
      funRestore: 40,
      color: Colors.cyan,
      strength: PotionStrength.special,
    ),
    PotionItem(
      id: 'potion_fruit',
      name: 'Jugo de Fruta',
      emoji: '🍹',
      price: 15,
      hungerRestore: 20,
      funRestore: 15,
      color: Colors.lightGreen,
      strength: PotionStrength.special,
    ),
  ];

  static List<PotionItem> getAll() {
    return [...basic, ...strong, ...special];
  }

  static List<PotionItem> getByStrength(PotionStrength strength) {
    switch (strength) {
      case PotionStrength.basic:
        return basic;
      case PotionStrength.strong:
        return strong;
      case PotionStrength.special:
        return special;
    }
  }

  static PotionItem? getById(String id) {
    try {
      return getAll().firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}