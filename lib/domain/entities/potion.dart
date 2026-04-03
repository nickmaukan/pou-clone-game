enum PotionType {
  blue,
  red,
  green,
  yellow,
}

class Potion {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final PotionType type;
  final String effect;
  final bool isAvailable;

  const Potion({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.type,
    required this.effect,
    required this.isAvailable,
  });

  Potion copyWith({
    String? id,
    String? name,
    String? imagePath,
    int? price,
    PotionType? type,
    String? effect,
    bool? isAvailable,
  }) {
    return Potion(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      type: type ?? this.type,
      effect: effect ?? this.effect,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
