// lib/presentation/screens/living_room/living_room_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ui_constants.dart';
import '../../providers/pet_provider.dart';
import '../../providers/game_state_provider.dart';
import '../../widgets/stat_bar.dart';
import '../../widgets/coin_display.dart';
import '../../widgets/pou_character.dart';
import '../../widgets/room_background.dart';

class LivingRoomScreen extends StatelessWidget {
  const LivingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomBackground(
      roomType: RoomType.livingRoom,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Stats section
            _buildStatsSection(context),
            
            // Pou character (main content)
            Expanded(
              child: Center(
                child: _buildPouArea(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: UIConstants.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Settings
          IconButton(
            onPressed: () {
              _showSettingsDialog(context);
            },
            icon: const Icon(
              Icons.settings,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ),
          
          // Room title
          const Text(
            '🏠 LIVING ROOM',
            style: TextStyle(
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

  Widget _buildStatsSection(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        if (petProvider.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.paddingLarge,
            vertical: UIConstants.paddingMedium,
          ),
          child: Column(
            children: [
              // Hunger
              StatBar(
                label: 'Hambre',
                value: petProvider.hunger,
                icon: '🍎',
                color: AppColors.hungerColor,
              ),
              const SizedBox(height: UIConstants.paddingSmall),
              
              // Cleanliness
              StatBar(
                label: 'Limpieza',
                value: petProvider.cleanliness,
                icon: '💗',
                color: AppColors.cleanlinessColor,
              ),
              const SizedBox(height: UIConstants.paddingSmall),
              
              // Fun
              StatBar(
                label: 'Diversión',
                value: petProvider.fun,
                icon: '⭐',
                color: AppColors.funColor,
              ),
              const SizedBox(height: UIConstants.paddingSmall),
              
              // Energy
              StatBar(
                label: 'Energía',
                value: petProvider.energy,
                icon: '⚡',
                color: AppColors.energyColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPouArea(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pou character
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
            
            // Level/Evolution
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
            
            const SizedBox(height: UIConstants.paddingLarge),
            
            // Tap instruction
            const Text(
              '💡 Toca a Pou para jugar',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
        ),
        title: const Text(
          '⚙️ Configuración',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              title: const Text('Reiniciar Juego', style: TextStyle(color: AppColors.warning)),
              onTap: () {
                Navigator.pop(context);
                _showResetConfirmation(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
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

// Dummy RoomType for now - import from actual location
enum RoomType { livingRoom }
