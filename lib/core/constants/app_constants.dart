// lib/core/constants/app_constants.dart
class AppConstants {
  AppConstants._();
  
  // App Info
  static const String appName = 'Pou Game';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String dbName = 'pou_game.db';
  static const int dbVersion = 1;
  
  // Storage Keys
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyMusicEnabled = 'music_enabled';
  static const String keyPetName = 'pet_name';
  static const String keyLastPlayed = 'last_played';
  
  // API Keys (if needed)
  // static const String someApiKey = '';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // Routes
  static const String routeSplash = '/';
  static const String routeHome = '/home';
  static const String routeLivingRoom = '/living-room';
  static const String routeKitchen = '/kitchen';
  static const String routeBathroom = '/bathroom';
  static const String routeLab = '/lab';
  static const String routeGameRoom = '/game-room';
  static const String routeCloset = '/closet';
  static const String routeShop = '/shop';
}
