// lib/presentation/screens/kitchen/kitchen_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/enums/room_type.dart';
import '../../../data/models/food_item.dart';
import '../../providers/pet_provider.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/pou_character.dart';
import '../../widgets/coin_display.dart';
import '../../widgets/stat_boost_popup.dart';
import '../../widgets/hearts_particles.dart';
import '../../widgets/food_menu.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen>
    with TickerProviderStateMixin {
  bool _isFeeding = false;
  FoodItem? _currentFood;
  bool _showHearts = false;
  bool _showStatBoost = false;
  StatBoostData? _statBoostData;

  late AnimationController _foodAnimationController;
  late Animation<Offset> _foodSlideAnimation;
  late Animation<double> _foodScaleAnimation;

  @override
  void initState() {
    super.initState();
    _foodAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _foodSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _foodAnimationController,
      curve: Curves.easeOut,
    ));

    _foodScaleAnimation = Tween<double>(
      begin: 1.5,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _foodAnimationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _foodAnimationController.dispose();
    super.dispose();
  }

  void _feedPou(FoodItem food) async {
    final gameState = context.read<GameStateProvider>();
    final petProvider = context.read<PetProvider>();

    // Check if can afford
    if (!gameState.canAfford(food.price)) {
      _showError('No tienes suficientes monedas');
      return;
    }

    setState(() {
      _isFeeding = true;
      _currentFood = food;
    });

    // Deduct coins
    gameState.spendCoins(food.price);

    // Play food animation
    _foodAnimationController.forward(from: 0);

    // Wait for food to reach Pou
    await Future.delayed(const Duration(milliseconds: 600));

    // Apply effects to pet
    final hungerBefore = petProvider.hunger;
    petProvider.feed(food);

    // Show hearts
    setState(() {
      _showHearts = true;
    });

    // Show stat boost popup
    final hungerAfter = petProvider.hunger - hungerBefore;
    setState(() {
      _statBoostData = StatBoostData(
        hunger: hungerAfter,
        energy: food.energyRestore,
        fun: food.funRestore,
        cleanliness: food.cleanlinessRestore,
        emoji: food.emoji,
      );
      _showStatBoost = true;
    });

    // Wait for animations
    await Future.delayed(const Duration(milliseconds: 1500));

    // Reset
    setState(() {
      _isFeeding = false;
      _currentFood = null;
      _showHearts = false;
      _showStatBoost = false;
      _statBoostData = null;
    });

    _foodAnimationController.reset();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Kitchen background with Pou
            Expanded(
              child: _buildKitchenArea(),
            ),
            
            // Food menu (bottom sheet)
            _buildFoodMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: UIConstants.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            onPressed: () {
              context.read<NavigationProvider>().setRoom(RoomType.livingRoom);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textSecondary,
              size: 32,
            ),
          ),
          
          // Title
          const Row(
            children: [
              Text('🍳 ', style: TextStyle(fontSize: 24)),
              Text(
                'COCINA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          
          // Coins
          Consumer<GameStateProvider>(
            builder: (context, game, _) => CoinDisplay(coins: game.coins),
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenArea() {
    return Stack(
      children: [
        // Kitchen background
        _buildKitchenBackground(),
        
        // Pou character
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Food animation (when feeding)
              if (_currentFood != null && _isFeeding)
                AnimatedBuilder(
                  animation: _foodAnimationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _foodSlideAnimation,
                      child: ScaleTransition(
                        scale: _foodScaleAnimation,
                        child: Text(
                          _currentFood!.emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    );
                  },
                )
              else
                const SizedBox(height: 60),
              
              const SizedBox(height: 20),
              
              // Pou with smaller size for kitchen
              PouCharacter(size: 180),
            ],
          ),
        ),
        
        // Hearts particles
        if (_showHearts)
          const Positioned.fill(
            child: HeartsParticles(),
          ),
        
        // Stat boost popup
        if (_showStatBoost && _statBoostData != null)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: StatBoostPopup(data: _statBoostData!),
            ),
          ),
      ],
    );
  }

  Widget _buildKitchenBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.kitchenColor.withOpacity(0.3),
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Kitchen counter (bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(UIConstants.radiusXLarge),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKitchenItem('🍳', 'Estufa'),
                  _buildKitchenItem('🧊', 'Nevera'),
                  _buildKitchenItem('🍽️', 'Mesa'),
                  _buildKitchenItem('🥄', 'Utensilios'),
                ],
              ),
            ),
          ),
          
          // Decorative elements
          // Hanging pots
          Positioned(
            top: 50,
            left: 50,
            child: Column(
              children: [
                const Text('🫕', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                const Text('🫕', style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
          
          Positioned(
            top: 50,
            right: 50,
            child: Column(
              children: [
                const Text('🍳', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                const Text('🥘', style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
          
          // Window
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('☀️', style: TextStyle(fontSize: 40)),
                    Text('☁️ ☁️', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenItem(String emoji, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodMenu() {
    return FoodMenu(
      onFoodSelected: (food) => _feedPou(food),
    );
  }
}