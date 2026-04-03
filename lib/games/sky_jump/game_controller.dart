// lib/games/sky_jump/game_controller.dart
import 'package:flutter/material.dart';

enum GameState { splash, menu, playing, paused, gameOver }

class GameConstants {
  static const double gameWidth = 1080;
  static const double gameHeight = 1920;
  
  // Physics
  static const double gravity = 0.5;
  static const double initialJumpVelocity = -15.0;
  static const double bouncyMultiplier = 1.3;
  static const double horizontalSpeed = 8.0;
  static const double maxFallSpeed = 12.0;
  static const double horizontalPadding = 50.0;
  
  // Cloud settings
  static const double cloudWidth = 150;
  static const double cloudHeight = 60;
  static const double cloudHitboxPadding = 20;
  
  // Pou settings
  static const double pouSize = 80;
  static const double pouStartY = 1600;
}

enum CloudType { normal, moving, bouncy, breaking, star }

class CloudData {
  final CloudType type;
  double x;
  double y;
  double width;
  double direction = 1;
  double speed = 2;
  bool wasHit = false;
  bool isActive = true;
  double breakProgress = 0;
  
  CloudData({
    required this.type,
    required this.x,
    required this.y,
    this.width = GameConstants.cloudWidth,
  });
  
  static CloudData createRandom(double screenWidth, double startY) {
    final rand = DateTime.now().millisecondsSinceEpoch;
    
    // Determine cloud type based on spawn rates
    final roll = (rand % 100).toDouble();
    CloudType type;
    
    if (roll < 60) {
      type = CloudType.normal;
    } else if (roll < 80) {
      type = CloudType.moving;
    } else if (roll < 90) {
      type = CloudType.bouncy;
    } else if (roll < 97) {
      type = CloudType.breaking;
    } else {
      type = CloudType.star;
    }
    
    return CloudData(
      type: type,
      x: (rand % (screenWidth.toInt() - 150)).toDouble(),
      y: startY,
      width: type == CloudType.star ? 60 : GameConstants.cloudWidth,
    );
  }
  
  String get emoji {
    switch (type) {
      case CloudType.normal:
        return '☁️';
      case CloudType.moving:
        return '🌫️';
      case CloudType.bouncy:
        return '🩷';
      case CloudType.breaking:
        return '💠';
      case CloudType.star:
        return '⭐';
    }
  }
  
  int get basePoints {
    switch (type) {
      case CloudType.normal:
        return 10;
      case CloudType.moving:
        return 15;
      case CloudType.bouncy:
        return 20;
      case CloudType.breaking:
        return 25;
      case CloudType.star:
        return 50;
    }
  }
  
  double get jumpMultiplier {
    switch (type) {
      case CloudType.bouncy:
        return GameConstants.bouncyMultiplier;
      case CloudType.star:
        return 1.0;
      default:
        return 1.0;
    }
  }
}