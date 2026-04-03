// lib/presentation/widgets/pou_character.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/enums/pet_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/sprite_manager.dart';
import '../providers/pet_provider.dart';

class PouCharacter extends StatefulWidget {
  final double size;

  const PouCharacter({
    super.key,
    this.size = 250,
  });

  @override
  State<PouCharacter> createState() => _PouCharacterState();
}

class _PouCharacterState extends State<PouCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getExpressionName(PouExpression expression) {
    switch (expression) {
      case PouExpression.happy:
        return 'happy';
      case PouExpression.sad:
        return 'sad';
      case PouExpression.surprised:
        return 'neutral';
      case PouExpression.tired:
        return 'tired';
      case PouExpression.hungry:
        return 'hungry';
      case PouExpression.dirty:
        return 'sad';
      case PouExpression.neutral:
      default:
        return 'neutral';
    }
  }

  Color _getGlowColor(PouExpression expression) {
    switch (expression) {
      case PouExpression.happy:
        return AppColors.success;
      case PouExpression.sad:
        return AppColors.warning;
      case PouExpression.tired:
        return AppColors.energyColor;
      case PouExpression.hungry:
        return AppColors.hungerColor;
      case PouExpression.dirty:
        return AppColors.error;
      case PouExpression.surprised:
      case PouExpression.neutral:
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        final expression = petProvider.expression;
        final spriteName = _getExpressionName(expression);
        final glowColor = _getGlowColor(expression);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            // Tap interaction - add fun
            petProvider.play(5);
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_bounceAnimation.value),
                child: Transform.scale(
                  scale: _isPressed ? 0.9 : _scaleAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow effect
                      Container(
                        width: widget.size * 1.2,
                        height: widget.size * 1.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Sprite image (with emoji fallback)
                      SpriteManager.getPouSprite(
                        spriteName,
                        size: widget.size,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}