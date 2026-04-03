// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  
  // === PRIMARY COLORS ===
  static const Color primary = Color(0xFF6C5CE7);      // Purple
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color primaryDark = Color(0xFF5B4CCE);
  
  // === SECONDARY COLORS ===
  static const Color secondary = Color(0xFF00CEC9);     // Teal
  static const Color secondaryLight = Color(0xFF81ECEC);
  
  // === ACCENT ===
  static const Color accent = Color(0xFFFD79A8);       // Pink
  
  // === STAT COLORS ===
  static const Color hungerColor = Color(0xFFE74C3C);     // Red
  static const Color cleanlinessColor = Color(0xFFE91E63); // Pink
  static const Color funColor = Color(0xFFF1C40F);        // Yellow
  static const Color energyColor = Color(0xFF3498DB);     // Blue
  
  // === BACKGROUND ===
  static const Color background = Color(0xFF1A1A2E);
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF25253A);
  static const Color surfaceLight = Color(0xFF2D2D4A);
  
  // === TEXT ===
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textMuted = Color(0xFF6C6C7A);
  
  // === UI ===
  static const Color divider = Color(0xFF3A3A4A);
  static const Color border = Color(0xFF4A4A5A);
  static const Color cardBackground = Color(0xFF2A2A3E);
  
  // === COIN ===
  static const Color coinGold = Color(0xFFFFD700);
  static const Color coinSilver = Color(0xFFC0C0C0);
  
  // === ROOM COLORS ===
  static const Color kitchenColor = Color(0xFFFF7675);     // Coral for kitchen
  static const Color bathroomColor = Color(0xFF74B9FF);     // Blue for bathroom
  static const Color labColor = Color(0xFF55EFC4);          // Teal for lab
  static const Color gameRoomColor = Color(0xFFFD79A8);     // Pink for game room
  static const Color closetColor = Color(0xFFB2BEC3);      // Grey for closet
  static const Color shopColor = Color(0xFFFDCB6E);         // Gold for shop
  
  // === RARITY COLORS ===
  static const Color common = Color(0xFF9E9E9E);
  static const Color uncommon = Color(0xFF4CAF50);
  static const Color rare = Color(0xFF2196F3);
  static const Color epic = Color(0xFF9C27B0);
  static const Color legendary = Color(0xFFFFD700);
  static const Color rarityCommon = Color(0xFF9E9E9E);
  static const Color rarityUncommon = Color(0xFF4CAF50);
  static const Color rarityRare = Color(0xFF2196F3);
  static const Color rarityEpic = Color(0xFF9C27B0);
  static const Color rarityLegendary = Color(0xFFFFD700);
  
  // === STATUS ===
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFE17055);
  static const Color info = Color(0xFF74B9FF);
  
  // === GRADIENTS ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient coinGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, backgroundDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
