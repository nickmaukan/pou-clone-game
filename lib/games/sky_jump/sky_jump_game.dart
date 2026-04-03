// lib/games/sky_jump/sky_jump_game.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';
import 'game_controller.dart';

class SkyJumpGame extends StatefulWidget {
  final VoidCallback onGameOver;
  final Function(int score, int coins) onGameComplete;

  const SkyJumpGame({
    super.key,
    required this.onGameOver,
    required this.onGameComplete,
  });

  @override
  State<SkyJumpGame> createState() => _SkyJumpGameState();
}

class _SkyJumpGameState extends State<SkyJumpGame>
    with TickerProviderStateMixin {
  // Game state
  GameState _gameState = GameState.splash;
  
  // Pou state
  double _pouX = 540 - GameConstants.pouSize / 2;
  double _pouY = GameConstants.pouStartY;
  double _pouVelocityY = 0;
  double _pouVelocityX = 0;
  
  // Camera (for scrolling effect)
  double _cameraY = 0;
  
  // Clouds
  List<CloudData> _clouds = [];
  
  // Score
  int _score = 0;
  int _bestScore = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _cloudsHit = 0;
  
  // Input
  bool _movingLeft = false;
  bool _movingRight = false;
  
  // Timers
  Timer? _gameTimer;
  int _elapsedSeconds = 0;
  late AnimationController _splashController;
  
  // Screen dimensions
  double _screenWidth = 1080;
  double _screenHeight = 1920;
  
  @override
  void initState() {
    super.initState();
    _bestScore = 0; // Load from storage in real app
    
    _splashController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    // Start splash animation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _gameState = GameState.menu;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    _splashController.dispose();
    super.dispose();
  }
  
  void _startGame() {
    setState(() {
      _gameState = GameState.playing;
      _score = 0;
      _combo = 0;
      _maxCombo = 0;
      _cloudsHit = 0;
      _pouX = _screenWidth / 2 - GameConstants.pouSize / 2;
      _pouY = _screenHeight - 300;
      _pouVelocityY = GameConstants.initialJumpVelocity;
      _pouVelocityX = 0;
      _cameraY = 0;
      _clouds = [];
      _elapsedSeconds = 0;
    });
    
    // Spawn initial clouds
    _spawnInitialClouds();
    
    // Start game loop
    _startGameLoop();
    
    // Start timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }
  
  void _spawnInitialClouds() {
    // Create a path of clouds leading up
    for (int i = 0; i < 8; i++) {
      final cloud = CloudData.createRandom(_screenWidth, _screenHeight - 400 - (i * 200));
      _clouds.add(cloud);
    }
  }
  
  void _startGameLoop() {
    Future.doWhile(() async {
      if (_gameState != GameState.playing) return false;
      
      await Future.delayed(const Duration(milliseconds: 16)); // ~60fps
      
      if (mounted && _gameState == GameState.playing) {
        _updateGame();
        return true;
      }
      return false;
    });
  }
  
  void _updateGame() {
    setState(() {
      // Apply gravity
      _pouVelocityY += GameConstants.gravity;
      _pouVelocityY = _pouVelocityY.clamp(-20, GameConstants.maxFallSpeed);
      
      // Horizontal movement
      if (_movingLeft) {
        _pouVelocityX = -GameConstants.horizontalSpeed;
      } else if (_movingRight) {
        _pouVelocityX = GameConstants.horizontalSpeed;
      } else {
        _pouVelocityX = 0;
      }
      
      // Update position
      _pouX += _pouVelocityX;
      _pouY += _pouVelocityY;
      
      // Screen bounds
      _pouX = _pouX.clamp(
        GameConstants.horizontalPadding,
        _screenWidth - GameConstants.horizontalPadding - GameConstants.pouSize,
      );
      
      // Camera follows Pou when going up
      final targetCameraY = _screenHeight / 3 - _pouY;
      if (targetCameraY > _cameraY) {
        _cameraY = targetCameraY;
      }
      
      // Check collisions
      _checkCollisions();
      
      // Spawn new clouds
      _spawnCloudsIfNeeded();
      
      // Check game over
      if (_pouY > _screenHeight + 100) {
        _triggerGameOver();
      }
      
      // Update moving clouds
      _updateMovingClouds();
    });
  }
  
  void _checkCollisions() {
    final pouBottom = _pouY + GameConstants.pouSize;
    final pouCenterX = _pouX + GameConstants.pouSize / 2;
    
    for (final cloud in _clouds) {
      if (!cloud.isActive) continue;
      if (cloud.wasHit && cloud.type != CloudType.breaking) continue;
      
      // Check if Pou is falling and intersects cloud
      if (_pouVelocityY > 0) {
        final cloudTop = cloud.y;
        final cloudLeft = cloud.x;
        final cloudRight = cloud.x + cloud.width;
        
        // Collision check
        if (pouBottom >= cloudTop &&
            pouBottom <= cloudTop + GameConstants.cloudHitboxPadding + 20 &&
            pouCenterX >= cloudLeft &&
            pouCenterX <= cloudRight) {
          
          _handleCloudHit(cloud);
        }
      }
    }
  }
  
  void _handleCloudHit(CloudData cloud) {
    // Only bounce if falling
    if (_pouVelocityY <= 0) return;
    
    cloud.wasHit = true;
    _cloudsHit++;
    _combo++;
    if (_combo > _maxCombo) _maxCombo = _combo;
    
    // Calculate points with multiplier
    int multiplier = 1;
    if (_combo >= 15) multiplier = 5;
    else if (_combo >= 10) multiplier = 4;
    else if (_combo >= 7) multiplier = 3;
    else if (_combo >= 5) multiplier = 2;
    
    final points = cloud.basePoints * multiplier;
    _score += points;
    
    // Apply bounce
    double jumpForce = GameConstants.initialJumpVelocity * cloud.jumpMultiplier;
    _pouVelocityY = jumpForce;
    
    // Handle breaking cloud
    if (cloud.type == CloudType.breaking) {
      cloud.breakProgress = 0.01;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && cloud.isActive) {
          setState(() {
            cloud.isActive = false;
          });
        }
      });
    }
    
    // Handle star collection
    if (cloud.type == CloudType.star) {
      cloud.isActive = false;
    }
  }
  
  void _updateMovingClouds() {
    for (final cloud in _clouds) {
      if (cloud.type == CloudType.moving && cloud.isActive) {
        cloud.x += cloud.direction * cloud.speed;
        
        // Bounce at edges
        if (cloud.x <= 0 || cloud.x >= _screenWidth - cloud.width) {
          cloud.direction *= -1;
        }
      }
    }
  }
  
  void _spawnCloudsIfNeeded() {
    // Get the highest cloud
    double highestY = 0;
    for (final cloud in _clouds) {
      if (cloud.y < highestY) highestY = cloud.y;
    }
    
    // Spawn new clouds above camera
    final spawnThreshold = _cameraY - 200;
    if (highestY > spawnThreshold) {
      // Spawn 1-2 new clouds
      final rand = Random();
      final count = 1 + rand.nextInt(2);
      
      for (int i = 0; i < count; i++) {
        final cloud = CloudData.createRandom(
          _screenWidth,
          highestY - 150 - rand.nextInt(100),
        );
        _clouds.add(cloud);
      }
    }
    
    // Remove clouds that are way below
    _clouds.removeWhere(
      (c) => c.y > _cameraY + _screenHeight + 500,
    );
  }
  
  void _triggerGameOver() {
    _gameTimer?.cancel();
    setState(() {
      _gameState = GameState.gameOver;
      if (_score > _bestScore) {
        _bestScore = _score;
      }
    });
    
    // Calculate coins earned
    final coins = _score ~/ 100;
    widget.onGameComplete(_score, coins);
  }
  
  void _pauseGame() {
    setState(() {
      _gameState = GameState.paused;
    });
  }
  
  void _resumeGame() {
    setState(() {
      _gameState = GameState.playing;
    });
    _startGameLoop();
  }
  
  void _handleTapDown(TapDownDetails details) {
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
    final screenThird = _screenWidth / 3;
    
    if (tapX < screenThird) {
      _movingLeft = true;
    } else if (tapX > screenThird * 2) {
      _movingRight = true;
    } else {
      // Center tap - quick jump if already high
      if (_pouVelocityY > -5) {
        _pouVelocityY = GameConstants.initialJumpVelocity * 0.8;
      }
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    _movingLeft = false;
    _movingRight = false;
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
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: () {
              _movingLeft = false;
              _movingRight = false;
            },
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
        return _buildPlayingScreen(); // Show game behind
      case GameState.gameOver:
        return _buildPlayingScreen(); // Show game behind
    }
  }
  
  Widget _buildSplashScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '☁️',
            style: TextStyle(fontSize: 100),
          ),
          const SizedBox(height: 20),
          const Text(
            'SKY JUMP',
            style: TextStyle(
              fontSize: 48,
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
          // Animated Pou
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -sin(value * 3.14159 * 2) * 30),
                child: const Text('🟤', style: TextStyle(fontSize: 100)),
              );
            },
          ),
          
          const SizedBox(height: 30),
          
          const Text(
            '☁️ SKY JUMP ☁️',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          
          const SizedBox(height: 20),
          
          if (_bestScore > 0)
            Text(
              '🏆 Best: $_bestScore',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.warning,
              ),
            ),
          
          const SizedBox(height: 60),
          
          // Play button
          GestureDetector(
            onTap: _startGame,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 20,
              ),
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
          
          // Instructions
          const Text(
            '🎮 Tap left/right to move\n⬆️ Center to jump higher',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlayingScreen() {
    return Stack(
      children: [
        // Background
        _buildBackground(),
        
        // Clouds
        ..._clouds.map((cloud) => _buildCloud(cloud)),
        
        // Pou
        _buildPou(),
        
        // HUD
        _buildHUD(),
        
        // Pause overlay
        if (_gameState == GameState.paused) _buildPauseOverlay(),
        
        // Game over overlay
        if (_gameState == GameState.gameOver) _buildGameOverOverlay(),
      ],
    );
  }
  
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue.shade200,
            Colors.lightBlue.shade400,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Distant clouds
          Positioned(
            top: 100 - (_cameraY * 0.1) % 500,
            left: 50,
            child: const Text('☁️', style: TextStyle(fontSize: 60, color: Colors.white54)),
          ),
          Positioned(
            top: 300 - (_cameraY * 0.1) % 500,
            right: 80,
            child: const Text('☁️', style: TextStyle(fontSize: 80, color: Colors.white38)),
          ),
          Positioned(
            top: 600 - (_cameraY * 0.1) % 500,
            left: 200,
            child: const Text('☁️', style: TextStyle(fontSize: 50, color: Colors.white30)),
          ),
          
          // Stars
          if (_cameraY > 2000)
            Positioned(
              top: 50,
              left: 100,
              child: const Text('⭐', style: TextStyle(fontSize: 30)),
            ),
        ],
      ),
    );
  }
  
  Widget _buildCloud(CloudData cloud) {
    if (!cloud.isActive) return const SizedBox();
    
    final screenY = cloud.y - _cameraY;
    if (screenY > _screenHeight || screenY < -100) {
      return const SizedBox();
    }
    
    Color? cloudColor;
    switch (cloud.type) {
      case CloudType.normal:
        cloudColor = Colors.white;
        break;
      case CloudType.moving:
        cloudColor = Colors.white70;
        break;
      case CloudType.bouncy:
        cloudColor = Colors.pink.shade200;
        break;
      case CloudType.breaking:
        cloudColor = Colors.lightBlue.shade200;
        break;
      case CloudType.star:
        cloudColor = Colors.amber;
        break;
    }
    
    return Positioned(
      left: cloud.x,
      top: screenY,
      child: Opacity(
        opacity: cloud.breakProgress > 0 ? 1 - cloud.breakProgress : 1,
        child: Transform.scale(
          scale: cloud.type == CloudType.star ? 0.6 : 1,
          child: Container(
            width: cloud.width,
            height: GameConstants.cloudHeight,
            decoration: BoxDecoration(
              color: cloudColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: cloud.type == CloudType.bouncy
                  ? [BoxShadow(color: Colors.pink.withOpacity(0.5), blurRadius: 15)]
                  : null,
            ),
            child: Center(
              child: Text(
                cloud.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPou() {
    final screenY = _pouY - _cameraY;
    
    String emoji;
    if (_pouVelocityY < -5) {
      emoji = '🟤'; // Jumping up
    } else if (_pouVelocityY > 5) {
      emoji = '🟤'; // Falling
    } else {
      emoji = '🟤';
    }
    
    return Positioned(
      left: _pouX,
      top: screenY,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: GameConstants.pouSize),
      ),
    );
  }
  
  Widget _buildHUD() {
    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Container(
            padding: const EdgeInsets.all(UIConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '$_score',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Best score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Best: $_bestScore',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Pause button
                GestureDetector(
                  onTap: _pauseGame,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.pause, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          
          // Combo indicator
          if (_combo >= 3)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'x$_combo COMBO!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⏸️ PAUSED', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _resumeGame,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('▶ Resume'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _startGame,
                child: const Text('🔄 Restart'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: widget.onGameOver,
                child: const Text('❌ Quit', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ),
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
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '💥 GAME OVER',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.error),
              ),
              
              if (isNewHighScore) ...[
                const SizedBox(height: 10),
                const Text(
                  '🎉 NEW HIGH SCORE! 🎉',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.warning),
                ),
              ],
              
              const SizedBox(height: 20),
              
              Text(
                '⭐ $_score',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                '🏆 Best: $_bestScore',
                style: const TextStyle(fontSize: 18, color: AppColors.warning),
              ),
              
              const SizedBox(height: 20),
              
              // Stats
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text('☁️ Clouds: $_cloudsHit'),
                    Text('🔥 Max Combo: $_maxCombo'),
                    Text('⏱️ Time: ${_elapsedSeconds}s'),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text('🔄 PLAY AGAIN', style: TextStyle(fontSize: 20)),
              ),
              
              const SizedBox(height: 10),
              
              TextButton(
                onPressed: widget.onGameOver,
                child: const Text('❌ Quit', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}