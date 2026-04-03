// lib/presentation/screens/bathroom/bathroom_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/room_type.dart';
import '../../../data/models/bath_cleaning_action.dart';
import '../../providers/pet_provider.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/stat_bar.dart';
import '../../widgets/coin_display.dart';
import '../../widgets/pou_character.dart';

class BathroomScreen extends StatefulWidget {
  const BathroomScreen({super.key});

  @override
  State<BathroomScreen> createState() => _BathroomScreenState();
}

class _BathroomScreenState extends State<BathroomScreen>
    with SingleTickerProviderStateMixin {
  bool _isCleaning = false;
  CleaningType? _selectedCleaningType;
  double _cleaningProgress = 0;
  bool _showSparkles = false;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _progressController.addListener(() {
      setState(() {
        _cleaningProgress = _progressController.value;
      });
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

    // Check if can afford
    final game = context.read<GameStateProvider>();
    if (action.coinCost > 0 && !game.canAfford(action.coinCost)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes suficientes monedas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Deduct coins if there's a cost
    if (action.coinCost > 0) {
      game.spendCoins(action.coinCost);
    }

    setState(() {
      _isCleaning = true;
      _selectedCleaningType = type;
    });

    _progressController.duration = action.duration;
    _progressController.forward(from: 0);

    Future.delayed(action.duration, () {
      _completeCleaning(action);
    });
  }

  void _completeCleaning(BathCleaningAction action) {
    if (!mounted) return;

    final petProvider = context.read<PetProvider>();
    petProvider.clean(action.cleanlinessBonus);

    setState(() {
      _showSparkles = true;
    });

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
            _buildHeader(),
            Expanded(child: _buildBathroomArea()),
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
          IconButton(
            onPressed: () {
              if (_isCleaning) _cancelCleaning();
              context.read<NavigationProvider>().setRoom(RoomType.livingRoom);
            },
            icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary, size: 32),
          ),
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
        _buildBathroomBackground(),
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
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedCleaningType != null && _isCleaning)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cleanlinessColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  BathCleaningAction.getByType(_selectedCleaningType!)?.name ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            const SizedBox(height: 20),
            const PouCharacter(size: 200),
            if (_isCleaning) ...[
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: _cleaningProgress,
                  backgroundColor: AppColors.cardBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cleanlinessColor),
                ),
              ),
            ],
          ],
        )),
        if (_showSparkles) Positioned.fill(child: _buildSparkles()),
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
            AppColors.bathroomColor.withOpacity(0.3),
            AppColors.background,
          ],
        ),
      ),
      child: CustomPaint(
        painter: TilePatternPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildSparkles() {
    return Container(
      color: Colors.white.withOpacity(0.2),
      child: Center(
        child: Text('✨✨✨', style: TextStyle(fontSize: 60))
            .animate(onPlay: (c) => c.repeat())
            .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2), duration: 500.ms)
            .then()
            .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.5, 0.5), duration: 500.ms),
      ),
    );
  }

  Widget _buildActionSelector() {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(UIConstants.radiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isCleaning)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Limpiando... ${(_cleaningProgress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(CleaningType.shower, '🚿', 3),
              _buildActionButton(CleaningType.bathtub, '🛁', 5),
              _buildActionButton(CleaningType.sink, '🚽', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(CleaningType type, String emoji, int coinCost) {
    final action = BathCleaningAction.getByType(type);
    final canAfford = context.read<GameStateProvider>().canAfford(coinCost);

    return GestureDetector(
      onTap: _isCleaning ? null : () => _startCleaning(type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedCleaningType == type ? AppColors.cleanlinessColor.withOpacity(0.5) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedCleaningType == type ? AppColors.cleanlinessColor : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(action?.name ?? '', style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 4),
            Text('$coinCost 🪙', style: const TextStyle(color: AppColors.warning, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class ShowerHead extends StatelessWidget {
  final double width;
  const ShowerHead({super.key, this.width = 100});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, 50),
      painter: _ShowerHeadPainter(),
    );
  }
}

class _ShowerHeadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterDroplets extends StatelessWidget {
  final bool isActive;
  final int dropletCount;
  const WaterDroplets({super.key, required this.isActive, required this.dropletCount});

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dropletCount, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text('💧', style: TextStyle(fontSize: 12 + (i % 5).toDouble()))
            .animate(onPlay: (c) => c.repeat())
            .moveY(begin: 0, end: 50 + (i % 20), duration: (500 + i * 50).ms)
            .fadeOut(delay: 400.ms),
      )),
    );
  }
}

class TilePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke;

    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}