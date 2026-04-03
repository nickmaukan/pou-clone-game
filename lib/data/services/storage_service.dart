// lib/data/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  late SharedPreferences _prefs;
  
  StorageService._();
  
  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    await _instance!._init();
    return _instance!;
  }
  
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // String
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);
  
  // Int
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);
  
  // Double
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);
  double? getDouble(String key) => _prefs.getDouble(key);
  
  // Bool
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);
  
  // List
  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);
  List<String>? getStringList(String key) => _prefs.getStringList(key);
  
  // JSON
  Future<bool> setJson(String key, Map<String, dynamic> value) {
    return setString(key, jsonEncode(value));
  }
  
  Map<String, dynamic>? getJson(String key) {
    final str = getString(key);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }
  
  // Remove
  Future<bool> remove(String key) => _prefs.remove(key);
  
  // Clear all
  Future<bool> clear() => _prefs.clear();
  
  // Check if contains key
  bool containsKey(String key) => _prefs.containsKey(key);
}
