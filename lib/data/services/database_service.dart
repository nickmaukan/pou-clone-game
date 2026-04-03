// lib/data/services/database_service.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pet_model.dart';
import '../models/game_progress_model.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;
  
  DatabaseService._();
  
  static Future<DatabaseService> getInstance() async {
    _instance ??= DatabaseService._();
    _database ??= await _instance!._init();
    return _instance!;
  }
  
  Future<Database> _init() async {
    return await openDatabase(
      'pou_game.db',
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Pets table
    await db.execute('''
      CREATE TABLE pets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        hunger REAL DEFAULT 100.0,
        cleanliness REAL DEFAULT 100.0,
        fun REAL DEFAULT 100.0,
        energy REAL DEFAULT 100.0,
        evolutionLevel INTEGER DEFAULT 0,
        experience INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        equippedHat TEXT,
        equippedGlasses TEXT,
        equippedOutfit TEXT,
        equippedAccessories TEXT,
        equippedBackground TEXT,
        eyeColor TEXT,
        bodyColor TEXT
      )
    ''');
    
    // Game progress table
    await db.execute('''
      CREATE TABLE game_progress (
        id TEXT PRIMARY KEY,
        coins INTEGER DEFAULT 100,
        highScoreSkyJump INTEGER DEFAULT 0,
        highScoreMemory INTEGER DEFAULT 0,
        highScoreConnect INTEGER DEFAULT 0,
        highScorePouPopper INTEGER DEFAULT 0,
        highScoreFoodDrop INTEGER DEFAULT 0,
        totalGamesPlayed INTEGER DEFAULT 0,
        unlockedAchievements TEXT DEFAULT '[]',
        ownedItems TEXT DEFAULT '["food_apple"]'
      )
    ''');
  }
  
  // Pet operations
  Future<void> savePet(PetModel pet) async {
    final db = _database!;
    await db.insert(
      'pets',
      pet.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<PetModel?> getPet() async {
    final db = _database!;
    final results = await db.query('pets', limit: 1);
    if (results.isEmpty) return null;
    return PetModel.fromJson(results.first);
  }
  
  // Game progress operations
  Future<void> saveGameProgress(GameProgressModel progress) async {
    final db = _database!;
    await db.insert(
      'game_progress',
      progress.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<GameProgressModel?> getGameProgress() async {
    final db = _database!;
    final results = await db.query('game_progress', limit: 1);
    if (results.isEmpty) return null;
    return GameProgressModel.fromJson(results.first);
  }
  
  Future<void> clearAll() async {
    final db = _database!;
    await db.delete('pets');
    await db.delete('game_progress');
  }
}
