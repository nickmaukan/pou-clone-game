// lib/presentation/widgets/sick_warning_overlay.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';
import '../providers/pet_provider.dart';
import '../providers/navigation_provider.dart';
import '../../core/enums/room_type.dart';

class SickWarningOverlay extends StatelessWidget {
  const SickWarningOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        // Only show if pet is sick or fainted
        if (petProvider.pet == null) return const SizedBox();
        if (!petProvider.isSick && !petProvider.isFainted) {
          return const SizedBox();
        }

        return Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(UIConstants.paddingLarge),
              padding: const EdgeInsets.all(UIConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
                border: Border.all(
                  color: petProvider.isFainted ? AppColors.error : AppColors.warning,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Emoji
                  Text(
                    petProvider.isFainted ? '💀' : '🤒',
                    style: const TextStyle(fontSize: 60),
                  ),
                  
                  const SizedBox(height: UIConstants.paddingMedium),
                  
                  // Title
                  Text(
                    petProvider.isFainted 
                        ? '¡Pou se desmayó!' 
                        : '¡Pou está enfermo!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: petProvider.isFainted 
                          ? AppColors.error 
                          : AppColors.warning,
                    ),
                  ),
                  
                  const SizedBox(height: UIConstants.paddingSmall),
                  
                  // Description
                  Text(
                    petProvider.isFainted
                        ? 'Los stats críticos causaron que Pou se desmayara.\nNecesita atención médica inmediata.'
                        : 'Los stats están muy bajos.\nTu Pou necesita atención.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: UIConstants.paddingLarge),
                  
                  // Critical stats
                  if (!petProvider.isFainted) _buildCriticalStats(petProvider),
                  
                  const SizedBox(height: UIConstants.paddingLarge),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Go to Lab (Medicine)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<NavigationProvider>().setRoom(RoomType.lab);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.labColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.paddingMedium,
                            vertical: UIConstants.paddingSmall,
                          ),
                        ),
                        icon: const Icon(Icons.local_drink, color: Colors.white),
                        label: const Text('Dar Medicina'),
                      ),
                      
                      // Go to Kitchen (Feed)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<NavigationProvider>().setRoom(RoomType.kitchen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.hungerColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.paddingMedium,
                            vertical: UIConstants.paddingSmall,
                          ),
                        ),
                        icon: const Icon(Icons.restaurant, color: Colors.white),
                        label: const Text('Alimentar'),
                      ),
                    ],
                  ),
                  
                  // Go to Bathroom
                  const SizedBox(height: UIConstants.paddingSmall),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<NavigationProvider>().setRoom(RoomType.bathroom);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cleanlinessColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: UIConstants.paddingMedium,
                          vertical: UIConstants.paddingSmall,
                        ),
                      ),
                      icon: const Icon(Icons.shower, color: Colors.white),
                      label: const Text('Limpiar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCriticalStats(PetProvider petProvider) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingSmall),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatIndicator(
            '🍎',
            petProvider.hunger,
            petProvider.hunger < 25,
          ),
          _buildStatIndicator(
            '💗',
            petProvider.cleanliness,
            petProvider.cleanliness < 25,
          ),
          _buildStatIndicator(
            '⭐',
            petProvider.fun,
            petProvider.fun < 25,
          ),
          _buildStatIndicator(
            '⚡',
            petProvider.energy,
            petProvider.energy < 25,
          ),
        ],
      ),
    );
  }

  Widget _buildStatIndicator(String emoji, double value, bool isCritical) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Container(
          width: 50,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (value / 100).clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: isCritical ? AppColors.error : AppColors.success,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Compact warning badge for when stats are low but pet not sick yet
class LowStatsWarning extends StatelessWidget {
  const LowStatsWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        if (petProvider.pet == null) return const SizedBox();
        
        // Check if any stat is below warning threshold (25)
        final warnings = <String>[];
        if (petProvider.hunger < 25) warnings.add('🍎');
        if (petProvider.cleanliness < 25) warnings.add('💗');
        if (petProvider.fun < 25) warnings.add('⭐');
        if (petProvider.energy < 25) warnings.add('⚡');
        
        if (warnings.isEmpty) return const SizedBox();
        
        return GestureDetector(
          onTap: () {
            // Could show detailed warning
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.paddingSmall,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.2),
              borderRadius: BorderRadius.circular(UIConstants.radiusSmall),
              border: Border.all(color: AppColors.warning.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                ...warnings.map((e) => Text(e, style: const TextStyle(fontSize: 16))),
              ],
            ),
          ),
        );
      },
    );
  }
}