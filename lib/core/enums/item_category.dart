// lib/core/enums/item_category.dart
enum ItemCategory {
  food,
  hat,
  glasses,
  outfit,
  accessory,
  potion,
  background,
}

enum ItemRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

extension ItemCategoryExtension on ItemCategory {
  String get displayName {
    switch (this) {
      case ItemCategory.food:
        return 'Food';
      case ItemCategory.hat:
        return 'Hats';
      case ItemCategory.glasses:
        return 'Glasses';
      case ItemCategory.outfit:
        return 'Outfits';
      case ItemCategory.accessory:
        return 'Accessories';
      case ItemCategory.potion:
        return 'Potions';
      case ItemCategory.background:
        return 'Backgrounds';
    }
  }
  
  String get emoji {
    switch (this) {
      case ItemCategory.food:
        return '🍎';
      case ItemCategory.hat:
        return '👒';
      case ItemCategory.glasses:
        return '👓';
      case ItemCategory.outfit:
        return '👗';
      case ItemCategory.accessory:
        return '🎭';
      case ItemCategory.potion:
        return '🧪';
      case ItemCategory.background:
        return '🖼️';
    }
  }
}

extension ItemRarityExtension on ItemRarity {
  String get displayName {
    switch (this) {
      case ItemRarity.common:
        return 'Common';
      case ItemRarity.uncommon:
        return 'Uncommon';
      case ItemRarity.rare:
        return 'Rare';
      case ItemRarity.epic:
        return 'Epic';
      case ItemRarity.legendary:
        return 'Legendary';
    }
  }
  
  int get priceMultiplier {
    switch (this) {
      case ItemRarity.common:
        return 1;
      case ItemRarity.uncommon:
        return 2;
      case ItemRarity.rare:
        return 4;
      case ItemRarity.epic:
        return 8;
      case ItemRarity.legendary:
        return 15;
    }
  }
}
