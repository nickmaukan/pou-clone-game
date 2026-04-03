// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/enums/room_type.dart';
import '../providers/pet_provider.dart';
import '../providers/game_state_provider.dart';
import '../providers/navigation_provider.dart';
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
  @override
  void initState() {
    super.initState();
    // Initialize providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().init();
      context.read<GameStateProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        // Route to specific room screens
        if (nav.currentRoom == RoomType.kitchen) {
          return const KitchenScreen();
        }
        if (nav.currentRoom == RoomType.gameRoom) {
          return const GameRoomScreen();
        }
        if (nav.currentRoom == RoomType.bathroom) {
          return const BathroomScreen();
        }
        if (nav.currentRoom == RoomType.lab) {
          return const LabScreen();
        }
        if (nav.currentRoom == RoomType.closet) {
          return const ClosetScreen();
        }
        
        // Default: Living Room
        return _buildLivingRoom();
      },
    );
  }

  Widget _buildLivingRoom() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Main content area (Living Room)
            Expanded(
              child: _buildLivingRoomContent(),
            ),
            
            // Bottom navigation
            _buildBottomNavigation(),
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
          // Settings button
          IconButton(
            onPressed: () {
              _showSettingsDialog(context);
            },
            icon: const Icon(Icons.settings, color: AppColors.textSecondary),
          ),
          
          // Room title
          Consumer<NavigationProvider>(
            builder: (context, nav, _) => Text(
              nav.roomName.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 2,
              ),
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
                      // Pou with interaction
                      const PouCharacter(size: 200),
                      
                      const SizedBox(height: UIConstants.paddingLarge),
                      
                      // Pet name
                      Text(
                        petProvider.pet?.name ?? 'Pou',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: UIConstants.paddingSmall),
                      
                      // Evolution level
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
                          'Nivel ${petProvider.pet?.evolutionLevel.index ?? 0 + 1}',
                          style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: UIConstants.paddingMedium),
                      
                      // Tap instruction
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
      child: Consumer<NavigationProvider>(
        builder: (context, nav, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: RoomType.values.map((room) {
              final isSelected = nav.currentRoom == room;
              return GestureDetector(
                onTap: () => nav.setRoom(room),
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
                          room.emoji,
                          style: TextStyle(
                            fontSize: isSelected ? 36 : 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.name,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textMuted,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
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
            }).toList(),
          );
        },
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
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: UIConstants.paddingLarge),
            
            // Title
            const Text(
              '⚙️ Configuración',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: UIConstants.paddingLarge),
            
            // Sound toggle
            ListTile(
              leading: const Icon(Icons.volume_up, color: AppColors.textSecondary),
              title: const Text('Sonido', style: TextStyle(color: AppColors.textPrimary)),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),
            
            // Music toggle
            ListTile(
              leading: const Icon(Icons.music_note, color: AppColors.textSecondary),
              title: const Text('Música', style: TextStyle(color: AppColors.textPrimary)),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),
            
            const Divider(color: AppColors.divider),
            
            // Reset game
            ListTile(
              leading: const Icon(Icons.refresh, color: AppColors.warning),
              title: const Text('Reiniciar Juego',
                  style: TextStyle(color: AppColors.warning)),
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
              // TODO: Implement reset
              Navigator.pop(context);
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