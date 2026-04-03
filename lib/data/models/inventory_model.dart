import '../../core/enums/item_category.dart';

class InventoryModel {
  final String id;
  final ItemCategory itemType;
  final String itemId;
  final int quantity;
  final bool isEquipped;
  final DateTime purchasedAt;

  const InventoryModel({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.quantity,
    required this.isEquipped,
    required this.purchasedAt,
  });

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      id: map['id'] as String,
      itemType: ItemCategory.values.firstWhere(
        (e) => e.dbValue == map['item_type'],
        orElse: () => ItemCategory.food,
      ),
      itemId: map['item_id'] as String,
      quantity: map['quantity'] as int,
      isEquipped: (map['is_equipped'] as int) == 1,
      purchasedAt: DateTime.parse(map['purchased_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_type': itemType.dbValue,
      'item_id': itemId,
      'quantity': quantity,
      'is_equipped': isEquipped ? 1 : 0,
      'purchased_at': purchasedAt.toIso8601String(),
    };
  }

  InventoryModel copyWith({
    String? id,
    ItemCategory? itemType,
    String? itemId,
    int? quantity,
    bool? isEquipped,
    DateTime? purchasedAt,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      isEquipped: isEquipped ?? this.isEquipped,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }
}
