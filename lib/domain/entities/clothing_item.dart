import '../enums/item_category.dart';

class ClothingItem {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final ItemCategory category;
  final bool isEquipped;
  final bool isUnlocked;

  const ClothingItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.isEquipped,
    required this.isUnlocked,
  });

  ClothingItem copyWith({
    String? id,
    String? name,
    String? imagePath,
    int? price,
    ItemCategory? category,
    bool? isEquipped,
    bool? isUnlocked,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      category: category ?? this.category,
      isEquipped: isEquipped ?? this.isEquipped,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
