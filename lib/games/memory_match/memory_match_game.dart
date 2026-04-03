// lib/games/memory_match/memory_match_game.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class MemoryMatchGame extends StatefulWidget {
  final VoidCallback onGameOver;
  final Function(int score, int coins) onGameComplete;

  const MemoryMatchGame({
    super.key,
    required this.onGameOver,
    required this.onGameComplete,
  });

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame>
    with SingleTickerProviderStateMixin {
  // Game state
  GameState _gameState = GameState.splash;
  
  // Grid settings
  static const int gridSize = 4; // 4x4 = 16 cards
  static const int pairs = 8; // 8 pairs
  
  // Cards
  late List<MemoryCard> _cards;
  List<int> _selectedIndices = [];
  bool _isChecking = false;
  int _matchedPairs = 0;
  
  // Score
  int _score = 0;
  int _moves = 0;
  int _bestScore = 0;
  
  // Time
  int _elapsedSeconds = 0;
  Timer? _gameTimer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _generateCards();
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _gameState = GameState.menu);
    });
  }

  void _generateCards() {
    // Pairs of emojis for memory game
    const emojis = ['🍎', '🍕', '🍔', '🍟', '🧁', '🍩', '🍪', '🍫'];
    
    final List<MemoryCard> cards = [];
    final rand = Random();
    
    // Create pairs
    for (int i = 0; i < pairs; i++) {
      cards.add(MemoryCard(id: i * 2, emoji: emojis[i], isFlipped: false, isMatched: false));
      cards.add(MemoryCard(id: i * 2 + 1, emoji: emojis[i], isFlipped: false, isMatched: false));
    }
    
    // Shuffle
    cards.shuffle(rand);
    
    _cards = cards;
  }

  void _startGame() {
    setState(() {
      _gameState = GameState.playing;
      _score = 1000; // Start with 1000 points
      _moves = 0;
      _matchedPairs = 0;
      _elapsedSeconds = 0;
      _selectedIndices = [];
      _isChecking = false;
    });
    
    _generateCards();
    
    // Start timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          _elapsedSeconds++;
          // Deduct points over time (time bonus at end)
          _score = max(100, _score - 2); // Minimum 100 points
        });
      }
    });
  }

  void _onCardTap(int index) {
    if (_isChecking) return;
    if (_cards[index].isFlipped) return;
    if (_cards[index].isMatched) return;
    if (_selectedIndices.length >= 2) return;
    
    setState(() {
      _cards[index].isFlipped = true;
      _selectedIndices.add(index);
    });
    
    if (_selectedIndices.length == 2) {
      _checkMatch();
    }
  }

  void _checkMatch() async {
    _isChecking = true;
    _moves++;
    
    final index1 = _selectedIndices[0];
    final index2 = _selectedIndices[1];
    
    if (_cards[index1].emoji == _cards[index2].emoji) {
      // Match!
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _cards[index1].isMatched = true;
        _cards[index2].isMatched = true;
        _matchedPairs++;
        _score += 100; // Bonus for match
        _selectedIndices = [];
        _isChecking = false;
      });
      
      // Check win
      if (_matchedPairs == pairs) {
        _triggerWin();
      }
    } else {
      // No match
      await Future.delayed(const Duration(milliseconds: 1000));
      
      setState(() {
        _cards[index1].isFlipped = false;
        _cards[index2].isFlipped = false;
        _selectedIndices = [];
        _isChecking = false;
        _score -= 10; // Penalty
      });
    }
  }

  void _triggerWin() {
    _gameTimer?.cancel();
    
    // Time bonus
    final timeLeft = max(0, 60 - _elapsedSeconds);
    final timeBonus = timeLeft * 5;
    _score += timeBonus;
    
    setState(() {
      _gameState = GameState.gameOver;
      if (_score > _bestScore) _bestScore = _score;
    });

    final coins = _score ~/ 100;
    widget.onGameComplete(_score, coins);
  }

  void _pauseGame() {
    setState(() => _isPaused = true);
  }

  void _resumeGame() {
    setState(() => _isPaused = false);
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: _buildGameScreen(),
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
          const Text('🧠', style: TextStyle(fontSize: 100)),
          const SizedBox(height: 20),
          const Text(
            'MEMORY MATCH',
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
          const Text('🧠', style: TextStyle(fontSize: 80)),
          
          const SizedBox(height: 20),
          
          const Text(
            '🧠 MEMORY MATCH 🧠',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          
          const SizedBox(height: 15),
          
          const Text(
            'Encuentra las parejas!\nSelecciona 2 cartas para comparar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
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
            '🎮 Encuentra 8 pares\n⏱️ Pierdes puntos con el tiempo',
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
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple.shade200,
                Colors.purple.shade400,
              ],
            ),
          ),
        ),

        // HUD
        _buildHUD(),

        // Cards grid
        Center(
          child: _buildCardsGrid(),
        ),

        // Pause overlay
        if (_gameState == GameState.paused) _buildPauseOverlay(),

        // Game over overlay
        if (_gameState == GameState.gameOver) _buildGameOverOverlay(),
      ],
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

                // Pairs found
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('🧠', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '$_matchedPairs/$pairs',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Pause button
                GestureDetector(
                  onTap: _pauseGame,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.pause, color: AppColors.textPrimary, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 60) / gridSize;

    return Container(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return _buildCard(index, cardSize);
        },
      ),
    );
  }

  Widget _buildCard(int index, double size) {
    final card = _cards[index];
    
    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: card.isMatched
              ? AppColors.success.withOpacity(0.3)
              : card.isFlipped
                  ? Colors.white
                  : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: card.isMatched
                ? AppColors.success
                : card.isFlipped
                    ? Colors.white
                    : AppColors.primaryDark,
            width: 3,
          ),
          boxShadow: card.isFlipped || card.isMatched
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Text(
                  card.emoji,
                  style: TextStyle(fontSize: size * 0.5),
                )
              : const Text(
                  '🧠',
                  style: TextStyle(fontSize: 30),
                ),
        ),
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
              const Text('⏸️ PAUSA', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _resumeGame,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('▶ Continuar'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _gameTimer?.cancel();
                  widget.onGameOver();
                },
                child: const Text('❌ Salir', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    final isNewHighScore = _score >= _bestScore && _score > 100;

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
              const Text('🎉 ¡COMPLETADO!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.success)),
              
              if (isNewHighScore) ...[
                const SizedBox(height: 10),
                const Text('🏆 ¡NUEVO RÉCORD! 🏆', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.warning)),
              ],
              
              const SizedBox(height: 20),
              
              Text('⭐ $_score', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              
              const SizedBox(height: 10),
              
              Text('Movimientos: $_moves | Tiempo: ${_elapsedSeconds}s', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              
              const SizedBox(height: 25),
              
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
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

class MemoryCard {
  final int id;
  final String emoji;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.emoji,
    required this.isFlipped,
    required this.isMatched,
  });
}

enum GameState { splash, menu, playing, paused, gameOver }