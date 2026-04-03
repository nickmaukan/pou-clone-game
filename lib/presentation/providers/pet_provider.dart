// lib/presentation/providers/pet_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../core/enums/pet_state.dart';
import '../../data/models/pet_model.dart';
import '../../data/models/food_item.dart';
import '../../data/services/database_service.dart';

class PetProvider extends ChangeNotifier {
  PetModel? _pet;
  bool _isLoading = true;
  Timer? _decayTimer;
  
  PetModel? get pet => _pet;
  bool get isLoading => _isLoading;
  
  // Getters for stats
  double get hunger => _pet?.hunger ?? 100;
  double get cleanliness => _pet?.cleanliness ?? 100;
  double get fun => _pet?.fun ?? 100;
  double get energy => _pet?.energy ?? 100;
  
  // State accessors
  bool get isSleeping => _pet?.state == PetState.sleeping;
  bool get isEating => _pet?.state == PetState.eating;

  // NEW: Sick state accessors
  bool get isSick => _pet?.isSick ?? false;
  bool get isFainted => _pet?.isFainted ?? false;
  bool get needsAttention => _pet?.needsMedicalAttention ?? false;

  // Animation state
  PouAnimation _currentAnimation = PouAnimation.idle;
  PouAnimation get currentAnimation => _currentAnimation;

  // Set animation temporarily
  
  PouExpression get expression => _pet?.expression ?? PouExpression.neutral;
  
  // Initialize
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    final db = await DatabaseService.getInstance();
    _pet = await db.getPet();
    
    if (_pet == null) {
      // Create new pet
      _pet = await PetModel.create('Pou');
      await db.savePet(_pet!);
    }
    
    _isLoading = false;
    _startDecayTimer();
    notifyListeners();
  }
  
  // Start the decay timer
  void _startDecayTimer() {
    _decayTimer?.cancel();
    _decayTimer = Timer.periodic(
      GameConstants.gameTickInterval,
      (_) => _applyDecay(),
    );
  }
  
  // Apply decay to stats
  void _applyDecay() {
    if (_pet == null) return;
    
    _pet!.applyDecay();
    notifyListeners();
    
    // Auto-save every 30 seconds
    if (DateTime.now().second % 30 == 0) {
      _savePet();
    }
  }
  
  // Feed the pet with food item effects
  void feed(FoodItem food) {
    if (_pet == null) return;
    _pet!.updateStats(
      hunger: hunger + food.hungerRestore,
      cleanliness: cleanliness + food.cleanlinessRestore,
      fun: fun + food.funRestore,
      energy: energy + food.energyRestore,
    );
    if (food.experienceGained > 0) {
      _pet!.addExperience(food.experienceGained);
    }
    _setAnimation(PouAnimation.eating);
    _savePet();
    notifyListeners();
  }
  
  // Clean the pet
  void clean(double amount) {
    if (_pet == null) return;
    _pet!.updateStats(cleanliness: cleanliness + amount);
    _setAnimation(PouAnimation.bathing);
    _savePet();
    notifyListeners();
  }
  
  // Play with pet
  void play(double amount) {
    if (_pet == null) return;
    _pet!.updateStats(fun: fun + amount);
    _setAnimation(PouAnimation.playing);
    _savePet();
    notifyListeners();
  }
  
  // Give energy
  void rest(double amount) {
    if (_pet == null) return;
    _pet!.updateStats(energy: energy + amount);
    _setAnimation(PouAnimation.sleeping);
    _savePet();
    notifyListeners();
  }
  
  // Use potion
  void usePotion({
    double? hunger,
    double? cleanliness,
    double? fun,
    double? energy,
    int experience = 0,
  }) {
    if (_pet == null) return;
    _pet!.updateStats(
      hunger: hunger,
      cleanliness: cleanliness,
      fun: fun,
      energy: energy,
    );
    if (experience > 0) {
      _pet!.addExperience(experience);
    }
    _setAnimation(PouAnimation.drinking);
    _savePet();
    notifyListeners();
  }
  
  // Set animation temporarily
  void _setAnimation(PouAnimation animation) {
    _currentAnimation = animation;
    notifyListeners();
    
    // Reset to idle after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentAnimation == animation) {
        _currentAnimation = PouAnimation.idle;
        notifyListeners();
      }
    });
  }
  
  // Reset animation to idle
  void resetAnimation() {
    _currentAnimation = PouAnimation.idle;
    notifyListeners();
  }
  
  // Save pet to database
  Future<void> _savePet() async {
    if (_pet == null) return;
    final db = await DatabaseService.getInstance();
    await db.savePet(_pet!);
  }
  
  @override
  void dispose() {
    _decayTimer?.cancel();
    super.dispose();
  }
}
