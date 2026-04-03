// lib/presentation/screens/game_room/game_room_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/enums/room_type.dart';
import '../../../games/sky_jump/sky_jump_game.dart';
import '../../../games/pou_popper/pou_popper_game.dart';
import '../../../games/memory_match/memory_match_game.dart';
import '../../providers/pet_provider.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/coin_display.dart';

class GameRoomScreen extends StatefulWidget {
  const GameRoomScreen({super.key});

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  bool _isPlayingGame = false;
  String _currentGame = '';

  @override
  Widget build(BuildContext context) {
    if (_isPlayingGame) {
      return _buildMiniGame();
    }

    return _buildGameRoom();
  }

  Widget _buildGameRoom() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gameRoomColor.withOpacity(0.3),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Game selection
            Expanded(
              child: _buildGameSelection(),
            ),
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
              Text('🎮 ', style: TextStyle(fontSize: 24)),
              Text(
                'GAME ROOM',
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

  Widget _buildGameSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sky Jump
          _buildGameCard(
            emoji: '☁️',
            title: 'SKY JUMP',
            description: 'Salta entre nubes\ny alcanza el cielo!',
            difficulty: '⭐⭐⭐',
            color: Colors.lightBlue,
            onTap: () {
              setState(() {
                _currentGame = 'skyjump';
                _isPlayingGame = true;
              });
            },
          ),

          const SizedBox(height: UIConstants.paddingLarge),

          // Pou Popper
          _buildGameCard(
            emoji: '🫧',
            title: 'POU POPPER',
            description: 'Estalla las burbujas\nmás pequeño = más puntos!',
            difficulty: '⭐⭐',
            color: Colors.pink,
            onTap: () {
              setState(() {
                _currentGame = 'poupopper';
                _isPlayingGame = true;
              });
            },
          ),

          const SizedBox(height: UIConstants.paddingLarge),

          // Memory Match
          _buildGameCard(
            emoji: '🧠',
            title: 'MEMORY MATCH',
            description: 'Encuentra las parejas\nde cartas!',
            difficulty: '⭐⭐',
            color: Colors.purple,
            onTap: () {
              setState(() {
                _currentGame = 'memorymatch';
                _isPlayingGame = true;
              });
            },
          ),

          const SizedBox(height: UIConstants.paddingLarge),

          // Coming soon
          _buildComingSoonCard(
            emoji: '🧠',
            title: 'MEMORY MATCH',
          ),

          const SizedBox(height: UIConstants.paddingMedium),

          _buildComingSoonCard(
            emoji: '🎯',
            title: 'FOOD DROP',
          ),

          const SizedBox(height: UIConstants.paddingMedium),

          _buildComingSoonCard(
            emoji: '⭕',
            title: 'TIC TAC POU',
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard({
    required String emoji,
    required String title,
    required String description,
    required String difficulty,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.3),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              difficulty,
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '▶ JUGAR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonCard({
    required String emoji,
    required String title,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'Coming soon...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'SOON',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniGame() {
    switch (_currentGame) {
      case 'skyjump':
        return SkyJumpGame(
          onGameOver: _exitGame,
          onGameComplete: _onGameComplete,
        );
      case 'poupopper':
        return PouPopperGame(
          onGameOver: _exitGame,
          onGameComplete: _onGameComplete,
        );
      case 'memorymatch':
        return MemoryMatchGame(
          onGameOver: _exitGame,
          onGameComplete: _onGameComplete,
        );
      default:
        return SkyJumpGame(
          onGameOver: _exitGame,
          onGameComplete: _onGameComplete,
        );
    }
  }

  void _exitGame() {
    setState(() {
      _isPlayingGame = false;
      _currentGame = '';
    });
  }

  void _onGameComplete(int score, int coins) {
    // Add coins to player's balance
    final gameState = context.read<GameStateProvider>();
    gameState.addCoins(coins);

    // Show reward message
    if (coins > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('💰', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text('+$coins coins ganados!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}