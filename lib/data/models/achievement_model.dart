class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
    this.unlockedAt,
  });

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? iconPath,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
