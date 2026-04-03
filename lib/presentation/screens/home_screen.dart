// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/enums/room_type.dart';
import '../../data/services/audio_service.dart';
import '../../data/services/database_service.dart';
import '../providers/pet_provider.dart';
import '../providers/game_state_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/inventory_provider.dart';
import '../widgets/stat_bar.dart';
import '../widgets/coin_display.dart';
import '../widgets/pou_character.dart';
import '../widgets/room_background.dart';
import 'kitchen/kitchen_screen.dart';
import 'game_room/game_room_screen.dart';
import 'bathroom/bathroom_screen.dart';
import 'lab/lab_screen.dart';
import 'closet/closet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  int _currentIndex = 0; // 0=Living, 1=Kitchen, 2=Bathroom, 3=Lab, 4=GameRoom, 5=Closet

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().init();
      context.read<GameStateProvider>().init();
      
      final audio = AudioService.getInstance();
      _soundEnabled = audio.soundEnabled;
      _musicEnabled = audio.musicEnabled;
    });
  }

  void _toggleSound(bool value) {
    setState(() {
      _soundEnabled = value;
    });
    AudioService.getInstance().setSoundEnabled(value);
  }

  void _toggleMusic(bool value) {
    setState(() {
      _musicEnabled = value;
    });
    AudioService.getInstance().setMusicEnabled(value);
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Also sync with NavigationProvider
    context.read<NavigationProvider>().setRoom(RoomType.values[index]);
  }

  Future<void> _resetGame() async {
    try {
      final db = await DatabaseService.getInstance();
      await db.clearAll();

      if (mounted) {
        context.read<PetProvider>().init();
        context.read<GameStateProvider>().init();
        if (mounted) {
          context.read<InventoryProvider>().clearAll();
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Juego reiniciado'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      debugPrint('Error resetting game: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al reiniciar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to navigation changes from other sources (like back buttons in screens)
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        // Sync index if navigation came from elsewhere
        final roomIndex = RoomType.values.indexOf(nav.currentRoom);
        if (roomIndex != _currentIndex && roomIndex >= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _currentIndex = roomIndex;
              });
            }
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header - changes based on current room
                _buildHeader(nav),

                // Main content - IndexedStack keeps all rooms in memory
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildLivingRoomContent(),
                      const KitchenScreen(),
                      const BathroomScreen(),
                      const LabScreen(),
                      const GameRoomScreen(),
                      const ClosetScreen(),
                    ],
                  ),
                ),

                // Bottom navigation - ALWAYS visible
                _buildBottomNavigation(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(NavigationProvider nav) {
    return Container(
      height: UIConstants.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Settings button
          IconButton(
            onPressed: () {
              _showSettingsDialog(context);
            },
            icon: const Icon(Icons.settings, color: AppColors.textSecondary),
          ),

          // Room title - changes based on current room
          Text(
            _getRoomTitle(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),

          // Coins
          Consumer<GameStateProvider>(
            builder: (context, game, _) => CoinDisplay(coins: game.coins),
          ),
        ],
      ),
    );
  }

  String _getRoomTitle() {
    switch (_currentIndex) {
      case 0:
        return '🏠 LIVING ROOM';
      case 1:
        return '🍳 KITCHEN';
      case 2:
        return '🛁 BATHROOM';
      case 3:
        return '🧪 LABORATORY';
      case 4:
        return '🎮 GAME ROOM';
      case 5:
        return '👗 CLOSET';
      default:
        return '🏠 HOME';
    }
  }

  Widget _buildLivingRoomContent() {
    return RoomBackground(
      roomType: RoomType.livingRoom,
      child: Consumer<PetProvider>(
        builder: (context, petProvider, _) {
          if (petProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Column(
            children: [
              // Stats section
              Padding(
                padding: const EdgeInsets.all(UIConstants.paddingMedium),
                child: Column(
                  children: [
                    const SizedBox(height: UIConstants.paddingSmall),
                    StatBar(
                      label: 'Hambre',
                      value: petProvider.hunger,
                      icon: '🍎',
                      color: AppColors.hungerColor,
                    ),
                    const SizedBox(height: UIConstants.paddingSmall),
                    StatBar(
                      label: 'Limpieza',
                      value: petProvider.cleanliness,
                      icon: '💗',
                      color: AppColors.cleanlinessColor,
                    ),
                    const SizedBox(height: UIConstants.paddingSmall),
                    StatBar(
                      label: 'Diversión',
                      value: petProvider.fun,
                      icon: '⭐',
                      color: AppColors.funColor,
                    ),
                    const SizedBox(height: UIConstants.paddingSmall),
                    StatBar(
                      label: 'Energía',
                      value: petProvider.energy,
                      icon: '⚡',
                      color: AppColors.energyColor,
                    ),
                  ],
                ),
              ),

              // Pou character
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PouCharacter(size: 200),

                      const SizedBox(height: UIConstants.paddingLarge),

                      Text(
                        petProvider.pet?.name ?? 'Pou',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: UIConstants.paddingSmall),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: UIConstants.paddingMedium,
                          vertical: UIConstants.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                        ),
                        child: Text(
                          'Nivel ${(petProvider.pet?.evolutionLevel.index ?? 0) + 1}',
                          style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: UIConstants.paddingMedium),

                      const Text(
                        '💡 Toca a Pou para jugar (+5 diversión)',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: UIConstants.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConstants.radiusLarge),
          topRight: Radius.circular(UIConstants.radiusLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, '🏠', 'Home'),
          _buildNavItem(1, '🍳', 'Kitchen'),
          _buildNavItem(2, '🛁', 'Bath'),
          _buildNavItem(3, '🧪', 'Lab'),
          _buildNavItem(4, '🎮', 'Games'),
          _buildNavItem(5, '👗', 'Closet'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String emoji, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(UIConstants.paddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
              ),
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: isSelected ? 36 : 28,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusXLarge),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(UIConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: UIConstants.paddingLarge),

            const Text(
              '⚙️ Configuración',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: UIConstants.paddingLarge),

            ListTile(
              leading: Icon(
                _soundEnabled ? Icons.volume_up : Icons.volume_off,
                color: AppColors.textSecondary,
              ),
              title: const Text('Sonido', style: TextStyle(color: AppColors.textPrimary)),
              trailing: Switch(
                value: _soundEnabled,
                onChanged: _toggleSound,
                activeColor: AppColors.primary,
              ),
            ),

            ListTile(
              leading: Icon(
                _musicEnabled ? Icons.music_note : Icons.music_off,
                color: AppColors.textSecondary,
              ),
              title: const Text('Música', style: TextStyle(color: AppColors.textPrimary)),
              trailing: Switch(
                value: _musicEnabled,
                onChanged: _toggleMusic,
                activeColor: AppColors.primary,
              ),
            ),

            const Divider(color: AppColors.divider),

            ListTile(
              leading: const Icon(Icons.refresh, color: AppColors.warning),
              title: const Text(
                'Reiniciar Juego',
                style: TextStyle(color: AppColors.warning),
              ),
              onTap: () {
                Navigator.pop(context);
                _showResetConfirmation(context);
              },
            ),

            const SizedBox(height: UIConstants.paddingLarge),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
        ),
        title: const Text(
          '⚠️ ¿Reiniciar Juego?',
          style: TextStyle(color: AppColors.warning),
        ),
        content: const Text(
          'Esto borrará todo tu progreso. ¿Estás seguro?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}