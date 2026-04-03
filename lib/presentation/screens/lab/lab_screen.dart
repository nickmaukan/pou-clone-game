// lib/presentation/screens/lab/lab_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/enums/room_type.dart';
import '../../../data/models/potion_item.dart';
import '../../providers/pet_provider.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/pou_character.dart';
import '../../widgets/coin_display.dart';
import '../../widgets/cauldron_effect.dart';
import '../../widgets/sparkle_particles.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen>
    with SingleTickerProviderStateMixin {
  PotionStrength _selectedStrength = PotionStrength.basic;
  PotionItem? _selectedPotion;
  bool _isDrinking = false;
  bool _showEffect = false;
  Color _effectColor = Colors.transparent;
  bool _showSparkles = false;

  late AnimationController _drinkController;
  late Animation<double> _drinkAnimation;

  @override
  void initState() {
    super.initState();
    _drinkController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _drinkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _drinkController, curve: Curves.easeInOut),
    );

    _drinkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _completeDrinking();
      }
    });
  }

  @override
  void dispose() {
    _drinkController.dispose();
    super.dispose();
  }

  void _selectPotion(PotionItem potion) {
    final game = context.read<GameStateProvider>();
    if (!game.canAfford(potion.price)) {
      _showError('No tienes suficientes monedas');
      return;
    }

    setState(() {
      _selectedPotion = potion;
    });
  }

  void _drinkPotion() async {
    if (_selectedPotion == null) return;

    final game = context.read<GameStateProvider>();
    final petProvider = context.read<PetProvider>();

    // Deduct coins
    game.spendCoins(_selectedPotion!.price);

    setState(() {
      _isDrinking = true;
      _effectColor = _selectedPotion!.color;
    });

    _drinkController.forward(from: 0);

    // Apply effects after animation midpoint
    await Future.delayed(const Duration(milliseconds: 1000));
    petProvider.usePotion(
      hunger: _selectedPotion!.hungerRestore,
      energy: _selectedPotion!.energyRestore,
      fun: _selectedPotion!.funRestore,
      cleanliness: _selectedPotion!.cleanlinessRestore,
      experience: _selectedPotion!.experienceGained,
    );
  }

  void _completeDrinking() {
    setState(() {
      _isDrinking = false;
      _showEffect = true;
      _showSparkles = true;
    });

    // Reset after effect
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showEffect = false;
          _showSparkles = false;
          _selectedPotion = null;
        });
        _drinkController.reset();
      }
    });
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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Lab area
                Expanded(
                  child: _buildLabArea(),
                ),

                // Potion selector
                _buildPotionSelector(),
              ],
            ),
          ),

          // Screen flash effect
          if (_showEffect)
            AnimatedBuilder(
              animation: _drinkController,
              builder: (context, child) {
                final progress = _drinkController.value;
                return Container(
                  color: _effectColor.withOpacity(
                    progress < 0.5 ? (progress * 0.4) : ((1 - progress) * 0.4),
                  ),
                );
              },
            ),

          // Sparkles
          if (_showSparkles)
            const Positioned.fill(
              child: SparkleParticles(),
            ),
        ],
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
              Text('🧪 ', style: TextStyle(fontSize: 24)),
              Text(
                'LABORATORIO',
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

  Widget _buildLabArea() {
    return Stack(
      children: [
        // Background
        _buildLabBackground(),

        // Cauldron in center
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cauldron
              const CauldronWidget(
                liquidColor: Color(0xFF55EFC4),
                isActive: true,
              ),

              const SizedBox(height: 20),

              // Pou character
              const PouCharacter(size: 150),

              const SizedBox(height: 20),

              // Drinking animation
              if (_isDrinking)
                AnimatedBuilder(
                  animation: _drinkAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _drinkAnimation.value < 0.5 ? 1.0 : 1.0 - (_drinkAnimation.value - 0.5) * 2,
                      child: Column(
                        children: [
                          Text(
                            _selectedPotion?.emoji ?? '🧪',
                            style: const TextStyle(fontSize: 50),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '🍽️',
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              // Selected potion indicator
              if (_selectedPotion != null && !_isDrinking)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.paddingMedium,
                    vertical: UIConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedPotion!.color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedPotion!.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedPotion!.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Lab shelves decoration
        _buildShelves(),
      ],
    );
  }

  Widget _buildLabBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.labColor.withOpacity(0.2),
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Stone wall texture
          Positioned.fill(
            child: CustomPaint(
              painter: StoneWallPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelves() {
    return Positioned(
      top: 20,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left shelf
          _buildShelf([
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
          ]),
          
          // Right shelf
          _buildShelf([
            Colors.purple,
            Colors.orange,
            Colors.pink,
            Colors.cyan,
          ]),
        ],
      ),
    );
  }

  Widget _buildShelf(List<Color> potionColors) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.brown.shade800,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: potionColors.map((color) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 25,
            height: 35,
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(3),
                bottom: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 5,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPotionSelector() {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: UIConstants.paddingMedium),

          // Strength tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: PotionStrength.values.map((strength) {
              final isSelected = _selectedStrength == strength;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStrength = strength;
                    _selectedPotion = null;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.paddingLarge,
                    vertical: UIConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.labColor.withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                    border: Border.all(
                      color: isSelected ? AppColors.labColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _getStrengthEmoji(strength),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: UIConstants.paddingMedium),

          // Potions grid
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: PotionCatalog.getByStrength(_selectedStrength).length,
              itemBuilder: (context, index) {
                final potion = PotionCatalog.getByStrength(_selectedStrength)[index];
                return _buildPotionItem(potion);
              },
            ),
          ),

          // Use button
          if (_selectedPotion != null) ...[
            const SizedBox(height: UIConstants.paddingMedium),
            _buildPotionInfo(),
          ],
        ],
      ),
    );
  }

  String _getStrengthEmoji(PotionStrength strength) {
    switch (strength) {
      case PotionStrength.basic:
        return '🧪';
      case PotionStrength.strong:
        return '💪';
      case PotionStrength.special:
        return '✨';
    }
  }

  Widget _buildPotionItem(PotionItem potion) {
    final game = context.read<GameStateProvider>();
    final canAfford = game.canAfford(potion.price);
    final isSelected = _selectedPotion?.id == potion.id;

    return GestureDetector(
      onTap: canAfford ? () => _selectPotion(potion) : () => _showError('No tienes suficientes monedas'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(UIConstants.paddingSmall),
        width: 90,
        decoration: BoxDecoration(
          color: isSelected
              ? potion.color.withOpacity(0.3)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
          border: Border.all(
            color: isSelected ? potion.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: potion.color.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: potion.color.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  potion.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              potion.name,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('💰', style: TextStyle(fontSize: 10)),
                Text(
                  '${potion.price}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: canAfford ? AppColors.warning : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPotionInfo() {
    final potion = _selectedPotion!;

    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      decoration: BoxDecoration(
        color: potion.color.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusLarge),
        ),
      ),
      child: Row(
        children: [
          // Potion icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: potion.color.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: potion.color.withOpacity(0.5),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Center(
              child: Text(
                potion.emoji,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),

          const SizedBox(width: UIConstants.paddingMedium),

          // Effects
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  potion.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    if (potion.hungerRestore > 0)
                      _buildEffectChip('🍎 +${potion.hungerRestore.toInt()}'),
                    if (potion.energyRestore > 0)
                      _buildEffectChip('⚡ +${potion.energyRestore.toInt()}'),
                    if (potion.funRestore > 0)
                      _buildEffectChip('⭐ +${potion.funRestore.toInt()}'),
                    if (potion.cleanlinessRestore > 0)
                      _buildEffectChip('💗 +${potion.cleanlinessRestore.toInt()}'),
                    if (potion.experienceGained > 0)
                      _buildEffectChip('✨ +${potion.experienceGained}XP'),
                  ],
                ),
              ],
            ),
          ),

          // Use button
          ElevatedButton(
            onPressed: _isDrinking ? null : _drinkPotion,
            style: ElevatedButton.styleFrom(
              backgroundColor: potion.color,
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.paddingLarge,
                vertical: UIConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.radiusRound),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_drink, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'USAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(UIConstants.radiusSmall),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// Stone wall painter
class StoneWallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    const brickWidth = 60.0;
    const brickHeight = 30.0;

    for (double y = 0; y < size.height; y += brickHeight) {
      final offset = (y ~/ brickHeight) % 2 == 0 ? 0.0 : brickWidth / 2;
      for (double x = -offset; x < size.width; x += brickWidth) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, brickWidth - 2, brickHeight - 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}