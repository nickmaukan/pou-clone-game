// lib/core/constants/ui_constants.dart
import 'package:flutter/material.dart';

class UIConstants {
  UIConstants._();
  
  // === CANVAS BASE ===
  static const double baseWidth = 1080;
  static const double baseHeight = 1920;
  
  // === RESPONSIVE SCALE ===
  static double scaleX = 1.0;
  static double scaleY = 1.0;
  
  // === BUTTONS ===
  static const double buttonHeight = 120;
  static const double buttonWidth = 300;
  static const double iconSize = 64;
  static const double iconSizeSmall = 40;
  static const double iconSizeLarge = 80;
  
  // === STAT BAR ===
  static const double statBarHeight = 45;
  static const double statBarWidth = 900;
  
  // === PADDINGS ===
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double paddingXLarge = 32;
  
  // === BORDER RADIUS ===
  static const double radiusSmall = 8;
  static const double radiusMedium = 16;
  static const double radiusLarge = 24;
  static const double radiusXLarge = 32;
  static const double radiusRound = 999;
  
  // === HEADER ===
  static const double headerHeight = 100;
  static const double bottomNavHeight = 150;
  
  // === CARD ===
  static const double cardElevation = 4;
  static const double cardRadius = 20;
  
  // === POU ===
  static const double pouSize = 400;
  static const double pouSizeSmall = 80;
  static const double pouSizeMedium = 200;
  
  // === NAVIGATION ===
  static const double navIconSize = 80;
  static const double navSpacing = 12;
  
  // === SHOP ===
  static const double itemCardSize = 150;
  static const double itemGridSpacing = 16;
  
  // === SCREEN PADDING ===
  static EdgeInsets screenPadding = const EdgeInsets.all(paddingMedium);
  static EdgeInsets horizontalPadding = const EdgeInsets.symmetric(horizontal: paddingLarge);
}
