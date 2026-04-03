// lib/presentation/widgets/stat_boost_popup.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class StatBoostData {
  final double hunger;
  final double energy;
  final double fun;
  final double cleanliness;
  final String emoji;

  const StatBoostData({
    required this.hunger,
    required this.energy,
    required this.fun,
    required this.cleanliness,
    required this.emoji,
  });
}

class StatBoostPopup extends StatefulWidget {
  final StatBoostData data;

  const StatBoostPopup({super.key, required this.data});

  @override
  State<StatBoostPopup> createState() => _StatBoostPopupState();
}

class _StatBoostPopupState extends State<StatBoostPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.paddingLarge,
                vertical: UIConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.success.withOpacity(0.9),
                    AppColors.primary.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.data.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: UIConstants.paddingSmall),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '+${widget.data.hunger.toInt()} 🍎',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (widget.data.energy > 0 ||
                          widget.data.fun > 0 ||
                          widget.data.cleanliness > 0)
                        Text(
                          [
                            if (widget.data.energy > 0) '+${widget.data.energy.toInt()} ⚡',
                            if (widget.data.fun > 0) '+${widget.data.fun.toInt()} ⭐',
                            if (widget.data.cleanliness > 0) '+${widget.data.cleanliness.toInt()} 💗',
                          ].join(' '),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}