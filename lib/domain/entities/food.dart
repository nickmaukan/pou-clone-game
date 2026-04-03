class Food {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final double hungerRestore;
  final bool isAvailable;

  const Food({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.hungerRestore,
    required this.isAvailable,
  });

  Food copyWith({
    String? id,
    String? name,
    String? imagePath,
    int? price,
    double? hungerRestore,
    bool? isAvailable,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      hungerRestore: hungerRestore ?? this.hungerRestore,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
