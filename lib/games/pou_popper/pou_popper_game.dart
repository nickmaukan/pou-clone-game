// lib/games/pou_popper/pou_popper_game.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class PouPopperGame extends StatefulWidget {
  final VoidCallback onGameOver;
  final Function(int score, int coins) onGameComplete;

  const PouPopperGame({
    super.key,
    required this.onGameOver,
    required this.onGameComplete,
  });

  @override
  State<PouPopperGame> createState() => _PouPopperGameState();
}

class _PouPopperGameState extends State<PouPopperGame>
    with TickerProviderStateMixin {
  // Game state
  GameState _gameState = GameState.splash;
  
  // Score
  int _score = 0;
  int _bestScore = 0;
  int _lives = 3;
  
  // Bubbles
  List<PouBubble> _bubbles = [];
  Timer? _spawnTimer;
  final Random _random = Random();
  
  // Time
  int _elapsedSeconds = 0;
  Timer? _gameTimer;
  static const int gameDuration = 60;
  
  // Screen dimensions
  double _screenWidth = 1080;
  double _screenHeight = 1920;

  @override
  void initState() {
    super.initState();
    // Start splash
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _gameState = GameState.menu);
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _gameState = GameState.playing;
      _score = 0;
      _lives = 3;
      _bubbles = [];
      _elapsedSeconds = 0;
    });

    // Start spawning bubbles
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted && _gameState == GameState.playing) {
        _spawnBubble();
      }
    });

    // Start timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        if (_elapsedSeconds >= gameDuration) {
          _triggerGameOver();
        }
      });
    });
  }

  void _spawnBubble() {
    final sizeRoll = _random.nextDouble() * 100;
    
    // Size categories with points
    double size;
    int points;
    double speed;
    
    if (sizeRoll < 30) {
      // Large - slow, low points
      size = 80 + _random.nextDouble() * 40;
      points = 10;
      speed = 1.0 + _random.nextDouble() * 0.5;
    } else if (sizeRoll < 60) {
      // Medium
      size = 55 + _random.nextDouble() * 25;
      points = 25;
      speed = 1.5 + _random.nextDouble() * 0.5;
    } else if (sizeRoll < 85) {
      // Small - fast, high points
      size = 35 + _random.nextDouble() * 20;
      points = 50;
      speed = 2.0 + _random.nextDouble() * 1.0;
    } else {
      // Tiny - very fast, bonus points
      size = 20 + _random.nextDouble() * 15;
      points = 100;
      speed = 2.5 + _random.nextDouble() * 1.5;
    }

    // Random X position
    final x = _random.nextDouble() * (_screenWidth - size);

    _bubbles.add(PouBubble(
      id: DateTime.now().millisecondsSinceEpoch,
      x: x,
      y: _screenHeight + size, // Start below screen
      size: size,
      speed: speed,
      points: points,
      wobble: (_random.nextDouble() - 0.5) * 2,
    ));
  }

  void _popBubble(PouBubble bubble) {
    setState(() {
      _score += bubble.points;
      _bubbles.removeWhere((b) => b.id == bubble.id);
    });
  }

  void _bubbleEscaped(PouBubble bubble) {
    setState(() {
      _lives--;
      _bubbles.removeWhere((b) => b.id == bubble.id);
      
      if (_lives <= 0) {
        _triggerGameOver();
      }
    });
  }

  void _triggerGameOver() {
    _spawnTimer?.cancel();
    _gameTimer?.cancel();
    
    setState(() {
      _gameState = GameState.gameOver;
      if (_score > _bestScore) _bestScore = _score;
    });

    final coins = _score ~/ 100;
    widget.onGameComplete(_score, coins);
  }

  void _updateBubbles(double dt) {
    for (final bubble in _bubbles) {
      bubble.y -= bubble.speed * 10;
      bubble.x += bubble.wobble;
      
      // Bounce off walls
      if (bubble.x <= 0 || bubble.x >= _screenWidth - bubble.size) {
        bubble.wobble *= -1;
      }

      // Check if escaped
      if (bubble.y + bubble.size < 0) {
        _bubbleEscaped(bubble);
      }
    }
  }

  void _handleTap(TapDownDetails details) {
    if (_gameState == GameState.menu) {
      _startGame();
      return;
    }

    if (_gameState == GameState.gameOver) {
      _startGame();
      return;
    }

    if (_gameState != GameState.playing) return;

    final tapX = details.localPosition.dx;
    final tapY = details.localPosition.dy;

    // Check bubble collisions (reverse order for top-most first)
    for (int i = _bubbles.length - 1; i >= 0; i--) {
      final bubble = _bubbles[i];
      
      final centerX = bubble.x + bubble.size / 2;
      final centerY = bubble.y + bubble.size / 2;
      final distance = sqrt(pow(tapX - centerX, 2) + pow(tapY - centerY, 2));

      if (distance <= bubble.size / 2 + 10) {
        _popBubble(bubble);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _screenWidth = constraints.maxWidth;
          _screenHeight = constraints.maxHeight;

          return GestureDetector(
            onTapDown: _handleTap,
            child: _buildGameScreen(),
          );
        },
      ),
    );
  }

  Widget _buildGameScreen() {
    switch (_gameState) {
      case GameState.splash:
        return _buildSplashScreen();
      case GameState.menu:
        return _buildMenuScreen();
      case GameState.playing:
        return _buildPlayingScreen();
      case GameState.paused:
        return _buildPlayingScreen();
      case GameState.gameOver:
        return _buildPlayingScreen();
    }
  }

  Widget _buildSplashScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🫧', style: TextStyle(fontSize: 100)),
          const SizedBox(height: 20),
          const Text(
            'POU POPPER',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 40),
          const CircularProgressIndicator(color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildMenuScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🫧', style: TextStyle(fontSize: 100)),
          
          const SizedBox(height: 20),
          
          const Text(
            '🫧 POU POPPER 🫧',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          
          const SizedBox(height: 15),
          
          const Text(
            '¡Estalla las burbujas de Pou!',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 10),
          
          const Text(
            '⬆️ Más pequeño = Más puntos ⬆️',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.warning,
            ),
          ),
          
          if (_bestScore > 0)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '🏆 Mejor: $_bestScore',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.warning,
                ),
              ),
            ),
          
          const SizedBox(height: 40),
          
          // Play button
          GestureDetector(
            onTap: _startGame,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                '▶ JUGAR',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          const Text(
            '🎮 Toca las burbujas para estallarlas\n⏱️ 60 segundos | ❤️ 3 vidas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayingScreen() {
    // Update bubble positions
    if (_gameState == GameState.playing) {
      for (final bubble in _bubbles) {
        bubble.y -= bubble.speed * 2;
        bubble.x += bubble.wobble;
        if (bubble.x <= 0 || bubble.x >= _screenWidth - bubble.size) {
          bubble.wobble *= -1;
        }
      }
      _bubbles.removeWhere((b) => b.y + b.size < 0 && _gameState == GameState.playing);
    }

    return Stack(
      children: [
        // Background - gradient sky
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue.shade200,
                Colors.lightBlue.shade400,
                Colors.lightBlue.shade300,
              ],
            ),
          ),
        ),

        // Bubbles
        ..._bubbles.map((bubble) => _buildBubble(bubble)),

        // HUD
        _buildHUD(),

        // Game Over overlay
        if (_gameState == GameState.gameOver) _buildGameOverOverlay(),
      ],
    );
  }

  Widget _buildBubble(PouBubble bubble) {
    // Size-based opacity and emoji
    final sizeFactor = (bubble.size / 100).clamp(0.5, 1.0);
    
    return Positioned(
      left: bubble.x,
      top: bubble.y,
      child: Container(
        width: bubble.size,
        height: bubble.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.3 + sizeFactor * 0.3),
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🫧',
                style: TextStyle(fontSize: bubble.size * 0.5),
              ),
              Text(
                '🟤',
                style: TextStyle(fontSize: bubble.size * 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHUD() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(UIConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '$_score',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Time & Lives
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Timer
                      Text(
                        '${gameDuration - _elapsedSeconds}s',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Lives
                      ...List.generate(3, (index) {
                        return Text(
                          index < _lives ? '❤️' : '🖤',
                          style: const TextStyle(fontSize: 18),
                        );
                      }),
                    ],
                  ),
                ),

                // Quit button
                GestureDetector(
                  onTap: () {
                    _spawnTimer?.cancel();
                    _gameTimer?.cancel();
                    widget.onGameOver();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.close, color: AppColors.textPrimary, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    final isNewHighScore = _score >= _bestScore && _score > 0;

    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '💥 GAME OVER',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.error),
              ),
              
              if (isNewHighScore) ...[
                const SizedBox(height: 10),
                const Text(
                  '🎉 ¡NUEVO RÉCORD! 🎉',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.warning),
                ),
              ],
              
              const SizedBox(height: 20),
              
              Text(
                '⭐ $_score',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                '🏆 Mejor: $_bestScore',
                style: const TextStyle(fontSize: 18, color: AppColors.warning),
              ),
              
              const SizedBox(height: 25),
              
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('🔄 JUGAR DE NUEVO', style: TextStyle(fontSize: 18)),
              ),
              
              const SizedBox(height: 10),
              
              TextButton(
                onPressed: widget.onGameOver,
                child: const Text('❌ Salir', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PouBubble {
  final int id;
  double x;
  double y;
  final double size;
  final double speed;
  final int points;
  double wobble;

  PouBubble({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.points,
    required this.wobble,
  });
}

enum GameState { splash, menu, playing, paused, gameOver }