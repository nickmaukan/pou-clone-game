// lib/presentation/widgets/stat_bar.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class StatBar extends StatelessWidget {
  final String label;
  final double value;
  final String icon;
  final Color color;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = value.clamp(0, 100) / 100;

    return Row(
      children: [
        // Icon
        SizedBox(
          width: 40,
          child: Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        
        // Label
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        
        // Progress bar
        Expanded(
          child: Container(
            height: UIConstants.statBarHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(UIConstants.radiusRound),
            ),
            child: Stack(
              children: [
                // Progress fill
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Percentage text
                Center(
                  child: Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      color: percentage > 0.5
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
