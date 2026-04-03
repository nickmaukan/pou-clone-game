// lib/data/services/audio_service.dart
import 'package:flutter/foundation.dart';

class AudioService {
  static AudioService? _instance;
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  AudioService._();

  static AudioService getInstance() {
    _instance ??= AudioService._();
    return _instance!;
  }

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    debugPrint('AudioService: Sound ${enabled ? "enabled" : "disabled"}');
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    debugPrint('AudioService: Music ${enabled ? "enabled" : "disabled"}');
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
  }

  // Placeholder methods - implement with audioplayers package
  Future<void> playSound(String assetPath) async {
    if (!_soundEnabled) return;
    debugPrint('AudioService: Playing sound $assetPath');
    // TODO: Implement with audioplayers
  }

  Future<void> playMusic(String assetPath) async {
    if (!_musicEnabled) return;
    debugPrint('AudioService: Playing music $assetPath');
    // TODO: Implement with audioplayers
  }

  Future<void> stopMusic() async {
    debugPrint('AudioService: Stopping music');
    // TODO: Implement
  }

  Future<void> pauseMusic() async {
    debugPrint('AudioService: Pausing music');
    // TODO: Implement
  }

  Future<void> resumeMusic() async {
    debugPrint('AudioService: Resuming music');
    // TODO: Implement
  }

  // Play specific sound effects
  Future<void> playEat() async {
    if (_soundEnabled) {
      debugPrint('🔊 Playing eat sound');
    }
  }

  Future<void> playClean() async {
    if (_soundEnabled) {
      debugPrint('🔊 Playing clean sound');
    }
  }

  Future<void> playSuccess() async {
    if (_soundEnabled) {
      debugPrint('🔊 Playing success sound');
    }
  }

  Future<void> playError() async {
    if (_soundEnabled) {
      debugPrint('🔊 Playing error sound');
    }
  }

  Future<void> playJump() async {
    if (_soundEnabled) {
      debugPrint('🔊 Playing jump sound');
    }
  }

  Future<void> playPop() async {
    if (_soundEnabled) {
      debugPrint('🔊 Playing pop sound');
    }
  }

  void dispose() {
    // Cleanup
  }
}