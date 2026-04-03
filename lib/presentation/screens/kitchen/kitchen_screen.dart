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

  void _showConfirmDialog(FoodItem food) {
    final gameState = context.read<GameStateProvider>();
    
    if (!gameState.canAfford(food.price)) {
      _showError('No tienes suficientes monedas');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
        ),
        title: Row(
          children: [
            Text(food.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                food.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Efectos:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (food.hungerRestore > 0)
                  _buildEffectChip('🍎 +${food.hungerRestore.toInt()}'),
                if (food.energyRestore > 0)
                  _buildEffectChip('⚡ +${food.energyRestore.toInt()}'),
                if (food.funRestore > 0)
                  _buildEffectChip('⭐ +${food.funRestore.toInt()}'),
                if (food.cleanlinessRestore > 0)
                  _buildEffectChip('💗 +${food.cleanlinessRestore.toInt()}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Costo:',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Row(
                  children: [
                    const Text('💰', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '${food.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tu balance: ${gameState.coins} coins',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _feedPou(food);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.restaurant, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Alimentar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(UIConstants.radiusSmall),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
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
            
            // Kitchen area with Pou visible
            Expanded(
              child: Stack(
                children: [
                  // Kitchen background
                  _buildKitchenBackground(),
                  
                  // Pou character - always visible
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
                                    style: const TextStyle(fontSize: 50),
                                  ),
                                ),
                              );
                            },
                          )
                        else
                          const SizedBox(height: 50),
                        
                        const SizedBox(height: 20),
                        
                        // Pou
                        const PouCharacter(size: 150),
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
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: StatBoostPopup(data: _statBoostData!),
                      ),
                    ),
                ],
              ),
            ),
            
            // Food menu - smaller bottom sheet (30% height)
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

  Widget _buildKitchenBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.kitchenColor.withOpacity(0.2),
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
              height: 120,
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
          
          // Hanging pots
          Positioned(
            top: 50,
            left: 40,
            child: Column(
              children: [
                const Text('🫕', style: TextStyle(fontSize: 35)),
                const SizedBox(height: 8),
                const Text('🫕', style: TextStyle(fontSize: 25)),
              ],
            ),
          ),
          
          Positioned(
            top: 50,
            right: 40,
            child: Column(
              children: [
                const Text('🍳', style: TextStyle(fontSize: 35)),
                const SizedBox(height: 8),
                const Text('🥘', style: TextStyle(fontSize: 25)),
              ],
            ),
          ),
          
          // Window
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 180,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('☀️', style: TextStyle(fontSize: 30)),
                    Text('☁️ ☁️', style: TextStyle(fontSize: 16)),
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
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusXLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: UIConstants.paddingSmall),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          const Padding(
            padding: EdgeInsets.all(UIConstants.paddingSmall),
            child: Text(
              '🍽️ Selecciona comida',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          
          // Food menu with confirmation
          FoodMenu(
            onFoodSelected: (food) => _showConfirmDialog(food),
          ),
        ],
      ),
    );
  }
}