// lib/presentation/widgets/coin_display.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class CoinDisplay extends StatelessWidget {
  final int coins;
  final bool showAnimation;

  const CoinDisplay({
    super.key,
    required this.coins,
    this.showAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingMedium,
        vertical: UIConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFA500),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(UIConstants.radiusRound),
        boxShadow: [
          BoxShadow(
            color: AppColors.coinGold.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '💰',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Text(
            coins.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
