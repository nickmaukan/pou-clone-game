// lib/data/models/clothing_item.dart
// Clothing items catalog for the Shop and Closet

import '../../core/enums/item_category.dart';

class ClothingItem {
  final String id;
  final String name;
  final String emoji;
  final ItemCategory category;
  final ItemRarity rarity;
  final int price;
  final bool isDefault;  // Starter items that don't need to be purchased

  const ClothingItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.rarity,
    required this.price,
    this.isDefault = false,
  });
}

class ClothingCatalog {
  // === HATS (25) ===
  static const List<ClothingItem> hats = [
    // Common (basic)
    ClothingItem(id: 'hat_cap_red', name: 'Gorra Roja', emoji: '🧢', category: ItemCategory.hat, rarity: ItemRarity.common, price: 50),
    ClothingItem(id: 'hat_cap_blue', name: 'Gorra Azul', emoji: '🧢', category: ItemCategory.hat, rarity: ItemRarity.common, price: 50),
    ClothingItem(id: 'hat_beanie', name: 'Gorro de Lana', emoji: '🧤', category: ItemCategory.hat, rarity: ItemRarity.common, price: 75),
    ClothingItem(id: 'hat_party', name: 'Sombrero de Fiesta', emoji: '🎉', category: ItemCategory.hat, rarity: ItemRarity.common, price: 60),
    ClothingItem(id: 'hat_bow', name: 'Lazo', emoji: '🎀', category: ItemCategory.hat, rarity: ItemRarity.common, price: 40),
    ClothingItem(id: 'hat_flower', name: 'Corona de Flores', emoji: '💐', category: ItemCategory.hat, rarity: ItemRarity.common, price: 80),
    ClothingItem(id: 'hat_headband', name: 'Banda Deportiva', emoji: '🏃', category: ItemCategory.hat, rarity: ItemRarity.common, price: 30),

    // Uncommon
    ClothingItem(id: 'hat_crown_small', name: 'Corona Pequeña', emoji: '👑', category: ItemCategory.hat, rarity: ItemRarity.uncommon, price: 150),
    ClothingItem(id: 'hat_chef', name: 'Sombrero de Chef', emoji: '👨‍🍳', category: ItemCategory.hat, rarity: ItemRarity.uncommon, price: 80),
    ClothingItem(id: 'hat_top_hat', name: 'Sombrero de Copa', emoji: '🎩', category: ItemCategory.hat, rarity: ItemRarity.uncommon, price: 120),
    ClothingItem(id: 'hat_cowboy', name: 'Sombrero Vaquero', emoji: '🤠', category: ItemCategory.hat, rarity: ItemRarity.uncommon, price: 100),
    ClothingItem(id: 'hat_angel', name: 'Halo de Ángel', emoji: '😇', category: ItemCategory.hat, rarity: ItemRarity.uncommon, price: 200),
    ClothingItem(id: 'hat_devil', name: 'Cuernos Demoníacos', emoji: '😈', category: ItemCategory.hat, rarity: ItemRarity.uncommon, price: 150),
    ClothingItem(id: 'hat_pirate', name: 'Sombrero de Pirata', emoji: '🏴‍☠️', category: ItemCategory.hat, rarity: ItemRarity.uncommon, price: 130),

    // Rare
    ClothingItem(id: 'hat_wizard', name: 'Sombrero de Mago', emoji: '🧙', category: ItemCategory.hat, rarity: ItemRarity.rare, price: 500),
    ClothingItem(id: 'hat_viking', name: 'Yelmo Vikingo', emoji: '🪖', category: ItemCategory.hat, rarity: ItemRarity.rare, price: 600),
    ClothingItem(id: 'hat_superhero', name: 'Máscara de Héroe', emoji: '🦸', category: ItemCategory.hat, rarity: ItemRarity.rare, price: 700),
    ClothingItem(id: 'hat_robot', name: 'Casco de Robot', emoji: '🤖', category: ItemCategory.hat, rarity: ItemRarity.rare, price: 800),

    // Epic
    ClothingItem(id: 'hat_princess', name: 'Tiara de Princesa', emoji: '👸', category: ItemCategory.hat, rarity: ItemRarity.epic, price: 1000),
    ClothingItem(id: 'hat_astronaut', name: 'Casco Espacial', emoji: '👨‍🚀', category: ItemCategory.hat, rarity: ItemRarity.epic, price: 1200),
    ClothingItem(id: 'hat_galaxy', name: 'Casco Galaxia', emoji: '🌌', category: ItemCategory.hat, rarity: ItemRarity.epic, price: 1500),

    // Legendary
    ClothingItem(id: 'hat_crown_royal', name: 'Corona Real', emoji: '👑', category: ItemCategory.hat, rarity: ItemRarity.legendary, price: 2000),
    ClothingItem(id: 'hat_crown_diamond', name: 'Corona de Diamantes', emoji: '💎', category: ItemCategory.hat, rarity: ItemRarity.legendary, price: 3000),
    ClothingItem(id: 'hat_phoenix', name: 'Fénix Dorado', emoji: '🔥', category: ItemCategory.hat, rarity: ItemRarity.legendary, price: 2500),
  ];

  // === GLASSES (20) ===
  static const List<ClothingItem> glasses = [
    // Common
    ClothingItem(id: 'glasses_round', name: 'Lentes Redondos', emoji: '👓', category: ItemCategory.glasses, rarity: ItemRarity.common, price: 80),
    ClothingItem(id: 'glasses_square', name: 'Lentes Cuadrados', emoji: '🕶️', category: ItemCategory.glasses, rarity: ItemRarity.common, price: 100),
    ClothingItem(id: 'glasses_sport', name: 'Deportivo', emoji: '🏃', category: ItemCategory.glasses, rarity: ItemRarity.common, price: 90),

    // Uncommon
    ClothingItem(id: 'glasses_aviator', name: 'Aviador', emoji: '🕵️', category: ItemCategory.glasses, rarity: ItemRarity.uncommon, price: 150),
    ClothingItem(id: 'glasses_cat', name: 'Ojos de Gato', emoji: '🐱', category: ItemCategory.glasses, rarity: ItemRarity.uncommon, price: 120),
    ClothingItem(id: 'glasses_3d', name: '3D Clásico', emoji: '🎥', category: ItemCategory.glasses, rarity: ItemRarity.uncommon, price: 300),
    ClothingItem(id: 'glasses_cyberpunk', name: 'Cyberpunk', emoji: '🤖', category: ItemCategory.glasses, rarity: ItemRarity.rare, price: 500),
    ClothingItem(id: 'glasses_heart', name: 'Forma de Corazón', emoji: '💕', category: ItemCategory.glasses, rarity: ItemRarity.rare, price: 400),
    ClothingItem(id: 'glasses_star', name: 'Estrellas', emoji: '⭐', category: ItemCategory.glasses, rarity: ItemRarity.rare, price: 350),

    // Epic
    ClothingItem(id: 'glasses_pixel', name: 'Pixeleados', emoji: '👾', category: ItemCategory.glasses, rarity: ItemRarity.epic, price: 1000),
    ClothingItem(id: 'glasses_laser', name: 'Ojos Láser', emoji: '⚡', category: ItemCategory.glasses, rarity: ItemRarity.epic, price: 1500),
    ClothingItem(id: 'glasses_rainbow', name: 'Arcoíris', emoji: '🌈', category: ItemCategory.glasses, rarity: ItemRarity.epic, price: 1200),

    // Legendary
    ClothingItem(id: 'glasses_diamond', name: 'Diamantes', emoji: '💎', category: ItemCategory.glasses, rarity: ItemRarity.legendary, price: 2000),
    ClothingItem(id: 'glasses_vr', name: 'VR Headset', emoji: '🥽', category: ItemCategory.glasses, rarity: ItemRarity.legendary, price: 1800),
  ];

  // === OUTFITS (15) ===
  static const List<ClothingItem> outfits = [
    // Common
    ClothingItem(id: 'outfit_casual', name: 'Casual', emoji: '👕', category: ItemCategory.outfit, rarity: ItemRarity.common, price: 200),
    ClothingItem(id: 'outfit_pajamas', name: 'Pijama', emoji: '🩷', category: ItemCategory.outfit, rarity: ItemRarity.common, price: 150),

    // Uncommon
    ClothingItem(id: 'outfit_formal', name: 'Traje Formal', emoji: '🤵', category: ItemCategory.outfit, rarity: ItemRarity.uncommon, price: 500),
    ClothingItem(id: 'outfit_chef', name: 'Uniforme Chef', emoji: '👨‍🍳', category: ItemCategory.outfit, rarity: ItemRarity.uncommon, price: 400),
    ClothingItem(id: 'outfit_doctor', name: 'Doctor', emoji: '👨‍⚕️', category: ItemCategory.outfit, rarity: ItemRarity.uncommon, price: 500),
    ClothingItem(id: 'outfit_ninja', name: 'Ninja', emoji: '🥷', category: ItemCategory.outfit, rarity: ItemRarity.uncommon, price: 700),

    // Rare
    ClothingItem(id: 'outfit_superhero', name: 'Héroe', emoji: '🦸', category: ItemCategory.outfit, rarity: ItemRarity.rare, price: 800),
    ClothingItem(id: 'outfit_pirate', name: 'Pirata', emoji: '🏴‍☠️', category: ItemCategory.outfit, rarity: ItemRarity.rare, price: 600),
    ClothingItem(id: 'outfit_robot', name: 'Robot', emoji: '🤖', category: ItemCategory.outfit, rarity: ItemRarity.rare, price: 1000),

    // Epic
    ClothingItem(id: 'outfit_princess', name: 'Princesa', emoji: '👸', category: ItemCategory.outfit, rarity: ItemRarity.epic, price: 1200),
    ClothingItem(id: 'outfit_astronaut', name: 'Astronauta', emoji: '👨‍🚀', category: ItemCategory.outfit, rarity: ItemRarity.epic, price: 1500),
    ClothingItem(id: 'outfit_dragon', name: 'Dragón', emoji: '🐉', category: ItemCategory.outfit, rarity: ItemRarity.epic, price: 2000),

    // Legendary
    ClothingItem(id: 'outfit_rainbow', name: 'Arcoíris', emoji: '🌈', category: ItemCategory.outfit, rarity: ItemRarity.legendary, price: 2500),
    ClothingItem(id: 'outfit_golden', name: 'Dorado', emoji: '🟡', category: ItemCategory.outfit, rarity: ItemRarity.legendary, price: 3000),
    ClothingItem(id: 'outfit_diamond', name: 'Diamante', emoji: '💎', category: ItemCategory.outfit, rarity: ItemRarity.legendary, price: 5000),
  ];

  // === ACCESSORIES (15) ===
  static const List<ClothingItem> accessories = [
    // Common
    ClothingItem(id: 'acc_mustache', name: 'Bigote', emoji: '👨', category: ItemCategory.accessory, rarity: ItemRarity.common, price: 50),
    ClothingItem(id: 'acc_blush', name: 'Colorete', emoji: '💗', category: ItemCategory.accessory, rarity: ItemRarity.common, price: 30),
    ClothingItem(id: 'acc_lipstick', name: 'Labial', emoji: '💄', category: ItemCategory.accessory, rarity: ItemRarity.common, price: 40),
    ClothingItem(id: 'acc_bowtie', name: 'Pajarita', emoji: '🎀', category: ItemCategory.accessory, rarity: ItemRarity.common, price: 80),

    // Uncommon
    ClothingItem(id: 'acc_earrings', name: 'Aretes', emoji: '💎', category: ItemCategory.accessory, rarity: ItemRarity.uncommon, price: 100),
    ClothingItem(id: 'acc_necklace', name: 'Collar', emoji: '📿', category: ItemCategory.accessory, rarity: ItemRarity.uncommon, price: 150),
    ClothingItem(id: 'acc_scarf', name: 'Bufanda', emoji: '🧣', category: ItemCategory.accessory, rarity: ItemRarity.uncommon, price: 120),
    ClothingItem(id: 'acc_cape', name: 'Capa', emoji: '🧥', category: ItemCategory.accessory, rarity: ItemRarity.uncommon, price: 300),
    ClothingItem(id: 'acc_backpack', name: 'Mochila', emoji: '🎒', category: ItemCategory.accessory, rarity: ItemRarity.uncommon, price: 150),

    // Rare
    ClothingItem(id: 'acc_wings_angel', name: 'Alas de Ángel', emoji: '😇', category: ItemCategory.accessory, rarity: ItemRarity.rare, price: 500),
    ClothingItem(id: 'acc_wings_devil', name: 'Alas Demonio', emoji: '😈', category: ItemCategory.accessory, rarity: ItemRarity.rare, price: 500),
    ClothingItem(id: 'acc_wings_fairy', name: 'Alas de Hada', emoji: '🧚', category: ItemCategory.accessory, rarity: ItemRarity.rare, price: 400),

    // Epic
    ClothingItem(id: 'acc_tail', name: 'Cola', emoji: '🔮', category: ItemCategory.accessory, rarity: ItemRarity.epic, price: 800),
    ClothingItem(id: 'acc_wings_butterfly', name: 'Alas Mariposa', emoji: '🦋', category: ItemCategory.accessory, rarity: ItemRarity.epic, price: 600),

    // Legendary
    ClothingItem(id: 'acc_rainbow_aura', name: 'Aura Arcoíris', emoji: '✨', category: ItemCategory.accessory, rarity: ItemRarity.legendary, price: 1500),
  ];

  // === BACKGROUNDS (8) ===
  static const List<ClothingItem> backgrounds = [
    ClothingItem(id: 'bg_default_blue', name: 'Azul Claro', emoji: '☁️', category: ItemCategory.background, rarity: ItemRarity.common, price: 100, isDefault: true),
    ClothingItem(id: 'bg_pink', name: 'Rosa Pastel', emoji: '🌸', category: ItemCategory.background, rarity: ItemRarity.uncommon, price: 150),
    ClothingItem(id: 'bg_green', name: 'Verde Selva', emoji: '🌿', category: ItemCategory.background, rarity: ItemRarity.uncommon, price: 150),
    ClothingItem(id: 'bg_yellow', name: 'Amarillo Solar', emoji: '🌞', category: ItemCategory.background, rarity: ItemRarity.uncommon, price: 150),
    ClothingItem(id: 'bg_space', name: 'Espacio Estelar', emoji: '🌌', category: ItemCategory.background, rarity: ItemRarity.rare, price: 300),
    ClothingItem(id: 'bg_rainbow', name: 'Arcoíris', emoji: '🌈', category: ItemCategory.background, rarity: ItemRarity.epic, price: 500),
    ClothingItem(id: 'bg_galaxy', name: 'Galaxia', emoji: '🪐', category: ItemCategory.background, rarity: ItemRarity.epic, price: 600),
    ClothingItem(id: 'bg_aurora', name: 'Aurora Boreal', emoji: '🌌', category: ItemCategory.background, rarity: ItemRarity.legendary, price: 1000),
  ];

  // Get all items
  static List<ClothingItem> getAllItems() {
    return [...hats, ...glasses, ...outfits, ...accessories, ...backgrounds];
  }

  // Get items by category
  static List<ClothingItem> getByCategory(ItemCategory category) {
    switch (category) {
      case ItemCategory.hat:
        return hats;
      case ItemCategory.glasses:
        return glasses;
      case ItemCategory.outfit:
        return outfits;
      case ItemCategory.accessory:
        return accessories;
      case ItemCategory.background:
        return backgrounds;
      default:
        return [];
    }
  }

  // Get item by ID
  static ClothingItem? getById(String id) {
    try {
      return getAllItems().firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
