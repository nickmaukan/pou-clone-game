// lib/presentation/screens/bathroom/bathroom_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/enums/room_type.dart';
import '../../../data/models/bath_cleaning_action.dart';
import '../../providers/pet_provider.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/pou_character.dart';
import '../../widgets/coin_display.dart';
import '../../widgets/water_droplets.dart';
import '../../widgets/bubbles_effect.dart';
import '../../widgets/sparkle_particles.dart';

class BathroomScreen extends StatefulWidget {
  const BathroomScreen({super.key});

  @override
  State<BathroomScreen> createState() => _BathroomScreenState();
}

class _BathroomScreenState extends State<BathroomScreen>
    with TickerProviderStateMixin {
  CleaningType? _selectedCleaningType;
  bool _isCleaning = false;
  double _cleaningProgress = 0;
  bool _showSparkles = false;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _completeCleaning();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startCleaning(CleaningType type) {
    final action = BathCleaningAction.getByType(type);
    if (action == null) return;

    setState(() {
      _selectedCleaningType = type;
      _isCleaning = true;
      _cleaningProgress = 0;
    });

    // Update animation duration
    _progressController.duration = action.duration;
    _progressController.forward(from: 0);

    // Listen to progress
    _progressController.addListener(() {
      setState(() {
        _cleaningProgress = _progressController.value;
      });
    });
  }

  void _completeCleaning() {
    if (_selectedCleaningType == null) return;

    final action = BathCleaningAction.getByType(_selectedCleaningType!);
    if (action == null) return;

    // Apply stats
    final petProvider = context.read<PetProvider>();
    petProvider.clean(action.cleanlinessBonus);

    // Show sparkles
    setState(() {
      _showSparkles = true;
    });

    // Reset after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isCleaning = false;
          _selectedCleaningType = null;
          _cleaningProgress = 0;
          _showSparkles = false;
        });
        _progressController.reset();
      }
    });
  }

  void _cancelCleaning() {
    _progressController.stop();
    setState(() {
      _isCleaning = false;
      _selectedCleaningType = null;
      _cleaningProgress = 0;
    });
    _progressController.reset();
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

            // Bathroom area
            Expanded(
              child: _buildBathroomArea(),
            ),

            // Action selector
            _buildActionSelector(),
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
              if (_isCleaning) {
                _cancelCleaning();
              }
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
              Text('🛁 ', style: TextStyle(fontSize: 24)),
              Text(
                'BAÑO',
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

  Widget _buildBathroomArea() {
    return Stack(
      children: [
        // Background
        _buildBathroomBackground(),

        // Shower zone (top)
        if (_selectedCleaningType == CleaningType.shower && _isCleaning)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            height: 150,
            child: Column(
              children: [
                const ShowerHead(width: 150),
                const SizedBox(height: 10),
                WaterDroplets(
                  isActive: _isCleaning,
                  dropletCount: (_cleaningProgress * 40).toInt().clamp(10, 40),
                ),
              ],
            ),
          ),

        // Pou in the center
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cleaning zone indicator
              if (_selectedCleaningType != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.paddingMedium,
                    vertical: UIConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        BathCleaningAction.getByType(_selectedCleaningType!)?.emoji ?? '',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        BathCleaningAction.getByType(_selectedCleaningType!)?.name ?? '',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Pou character
              if (_selectedCleaningType == CleaningType.bathtub && _isCleaning)
                // Pou in bathtub
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const BathtubWidget(hasWater: true, hasBubbles: true),
                    const SizedBox(height: 60),
                    const PouCharacter(size: 120),
                  ],
                )
              else
                // Normal Pou
                const PouCharacter(size: 180),

              const SizedBox(height: 20),

              // Progress bar
              if (_isCleaning) _buildProgressBar(),
            ],
          ),
        ),

        // Sparkle particles
        if (_showSparkles)
          const Positioned.fill(
            child: SparkleParticles(),
          ),
      ],
    );
  }

  Widget _buildBathroomBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.bathroomColor.withOpacity(0.2),
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Tiles pattern
          Positioned.fill(
            child: CustomPaint(
              painter: TilePatternPainter(),
            ),
          ),

          // Mirror
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
              ),
              child: const Center(
                child: Text('🪞</', style: TextStyle(fontSize: 40)),
              ),
            ),
          ),

          // Sink
          Positioned(
            bottom: 50,
            right: 30,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: 20,
                  height: 30,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCleaningType != null
                    ? BathCleaningAction.getByType(_selectedCleaningType!)!.name
                    : '',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(_cleaningProgress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _cleaningProgress,
              backgroundColor: AppColors.cardBackground,
              valueColor: const AlwaysStoppedAnimation(AppColors.bathroomColor),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSelector() {
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

          // Title
          const Text(
            '💧 Selecciona una opción de limpieza',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: UIConstants.paddingMedium),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: BathCleaningAction.allActions.map((action) {
              final isSelected = _selectedCleaningType == action.type;
              final isDisabled = _isCleaning;

              return GestureDetector(
                onTap: isDisabled ? null : () => _startCleaning(action.type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(UIConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.bathroomColor.withOpacity(0.3)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
                    border: Border.all(
                      color: isSelected ? AppColors.bathroomColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        action.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action.name,
                        style: TextStyle(
                          color: isDisabled
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+${action.cleanlinessBonus.toInt()} 💗',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.cleanlinessColor,
                        ),
                      ),
                      Text(
                        '${action.duration.inSeconds}s',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Tile pattern painter
class TilePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke;

    const tileSize = 50.0;

    for (double x = 0; x < size.width; x += tileSize) {
      for (double y = 0; y < size.height; y += tileSize) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, tileSize, tileSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}