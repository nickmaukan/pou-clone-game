// lib/core/utils/sprite_manager.dart
import 'package:flutter/material.dart';

/// Manages all game sprites (pixel art images)
class SpriteManager {
  // Base path for sprites
  static const String spritePath = 'assets/sprites';

  // Pou character sprites
  static const Map<String, String> pouSprites = {
    'happy': '$spritePath/pou_happy.png',
    'sad': '$spritePath/pou_sad.png',
    'hungry': '$spritePath/pou_hungry.png',
    'sick': '$spritePath/pou_sick.png',
    'tired': '$spritePath/pou_tired.png',
    'neutral': '$spritePath/pou_neutral.png',
    'eating': '$spritePath/pou_eating.png',
    'sleeping': '$spritePath/pou_sleeping.png',
  };

  // Food sprites
  static const Map<String, String> foodSprites = {
    'apple': '$spritePath/food_apple.png',
    'pizza': '$spritePath/food_pizza.png',
    'burger': '$spritePath/food_burger.png',
    'icecream': '$spritePath/food_icecream.png',
    'coffee': '$spritePath/food_coffee.png',
    'water': '$spritePath/food_water.png',
    'cake': '$spritePath/food_cake.png',
    'carrot': '$spritePath/food_carrot.png',
    'banana': '$spritePath/food_banana.png',
    'grapes': '$spritePath/food_grapes.png',
  };

  // Potion sprites
  static const Map<String, String> potionSprites = {
    'green': '$spritePath/potion_green.png',
    'blue': '$spritePath/potion_blue.png',
    'red': '$spritePath/potion_red.png',
  };

  // Room backgrounds
  static const Map<String, String> roomBackgrounds = {
    'living': '$spritePath/bg_living_room.png',
    'kitchen': '$spritePath/bg_kitchen.png',
    'bathroom': '$spritePath/bg_bathroom.png',
  };

  /// Get sprite widget with fallback to emoji
  static Widget getSprite({
    required String path,
    double size = 64,
    BoxFit fit = BoxFit.contain,
    String? fallbackEmoji,
  }) {
    // For sprites that exist, use Image.asset
    return _AssetSprite(
      path: path,
      size: size,
      fit: fit,
      fallbackEmoji: fallbackEmoji,
    );
  }

  /// Get Pou sprite for specific expression
  static Widget getPouSprite(String expression, {double size = 100}) {
    final path = pouSprites[expression] ?? pouSprites['neutral']!;
    return _AssetSprite(
      path: path,
      size: size,
      fit: BoxFit.contain,
      fallbackEmoji: _getEmojiForExpression(expression),
    );
  }

  /// Get food sprite
  static Widget getFoodSprite(String foodType, {double size = 50}) {
    final path = foodSprites[foodType.toLowerCase()];
    return _AssetSprite(
      path: path ?? '',
      size: size,
      fit: BoxFit.contain,
      fallbackEmoji: _getEmojiForFood(foodType),
    );
  }

  /// Get room background
  static Widget getRoomBackground(String room, {double? width, double? height}) {
    final path = roomBackgrounds[room];
    if (path == null) return const SizedBox();
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => const SizedBox(),
    );
  }

  static String _getEmojiForExpression(String expression) {
    const emojis = {
      'happy': '😄',
      'sad': '😢',
      'hungry': '😋',
      'sick': '🤒',
      'tired': '😴',
      'neutral': '🟤',
      'eating': '😋',
      'sleeping': '😴',
    };
    return emojis[expression] ?? '🟤';
  }

  static String _getEmojiForFood(String foodType) {
    const emojis = {
      'apple': '🍎',
      'pizza': '🍕',
      'burger': '🍔',
      'icecream': '🍦',
      'coffee': '☕',
      'water': '💧',
      'cake': '🎂',
      'carrot': '🥕',
      'banana': '🍌',
      'grapes': '🍇',
    };
    return emojis[foodType.toLowerCase()] ?? '🍽️';
  }
}

/// Internal widget for loading asset sprites with fallback
class _AssetSprite extends StatelessWidget {
  final String path;
  final double size;
  final BoxFit fit;
  final String? fallbackEmoji;

  const _AssetSprite({
    required this.path,
    required this.size,
    required this.fit,
    this.fallbackEmoji,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return _buildFallback();
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stack) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    if (fallbackEmoji != null) {
      return Text(
        fallbackEmoji!,
        style: TextStyle(fontSize: size * 0.8),
      );
    }
    return SizedBox(width: size, height: size);
  }
}