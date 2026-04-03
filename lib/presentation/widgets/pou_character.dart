// lib/presentation/widgets/pou_character.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/enums/pet_state.dart';
import '../../core/theme/app_colors.dart';
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

  String _getPouEmoji(PouExpression expression) {
    switch (expression) {
      case PouExpression.happy:
        return '😄';
      case PouExpression.sad:
        return '😢';
      case PouExpression.surprised:
        return '😲';
      case PouExpression.tired:
        return '😴';
      case PouExpression.hungry:
        return '😋';
      case PouExpression.dirty:
        return '🤢';
      case PouExpression.neutral:
      default:
        return '🟤';
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
        final emoji = _getPouEmoji(expression);
        final glowColor = _getGlowColor(expression);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            petProvider.play(5);
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _isPressed ? 5 : -_bounceAnimation.value),
                child: Transform.scale(
                  scale: _isPressed ? 0.95 : _scaleAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pou body with glow
                      Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(0.4),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(
                              fontSize: widget.size * 0.6,
                            ),
                          ),
                        ),
                      ),
                      
                      // Shadow
                      Container(
                        width: widget.size * 0.6,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black.withOpacity(0.2),
                        ),
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
