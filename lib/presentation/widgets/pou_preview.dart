// lib/presentation/widgets/pou_preview.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/enums/pet_state.dart';
import '../../data/models/clothing_item.dart';
import '../providers/pet_provider.dart';
import '../providers/inventory_provider.dart';

class PouPreview extends StatefulWidget {
  final double size;
  final bool showAnimation;
  final bool showGlow;

  const PouPreview({
    super.key,
    this.size = 250,
    this.showAnimation = true,
    this.showGlow = true,
  });

  @override
  State<PouPreview> createState() => _PouPreviewState();
}

class _PouPreviewState extends State<PouPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.showAnimation) {
      _controller.repeat(reverse: true);
    }

    _bounceAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PetProvider, InventoryProvider>(
      builder: (context, pet, inventory, _) {
        final expression = pet.expression;
        final emoji = _getPouEmoji(expression);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, widget.showAnimation ? -_bounceAnimation.value : 0),
              child: Transform.scale(
                scale: widget.showAnimation ? _scaleAnimation.value : 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect
                    if (widget.showGlow)
                      Container(
                        width: widget.size * 1.2,
                        height: widget.size * 1.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _getExpressionColor(expression).withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                    // Background (if equipped)
                    if (inventory.equippedBackground != null)
                      _buildBackground(inventory.equippedBackground!),

                    // Body with outfit
                    _buildBody(inventory),

                    // Accessory back layer (wings, etc)
                    ..._buildAccessoriesBack(inventory),

                    // Glasses
                    if (inventory.equippedGlasses != null)
                      _buildGlasses(inventory.equippedGlasses!),

                    // Hat
                    if (inventory.equippedHat != null)
                      _buildHat(inventory.equippedHat!),

                    // Main Pou emoji
                    Text(
                      emoji,
                      style: TextStyle(
                        fontSize: widget.size * 0.5,
                      ),
                    ),

                    // Accessory front layer
                    ..._buildAccessoriesFront(inventory),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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

  Color _getExpressionColor(PouExpression expression) {
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
      default:
        return AppColors.primary;
    }
  }

  Widget _buildBody(InventoryProvider inventory) {
    final outfitId = inventory.equippedOutfit;
    ClothingItem? outfit;

    if (outfitId != null) {
      outfit = ClothingCatalog.getById(outfitId);
    }

    if (outfit == null) {
      return const SizedBox();
    }

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(widget.size * 0.2),
      ),
      child: Center(
        child: Text(
          outfit.emoji,
          style: TextStyle(fontSize: widget.size * 0.3),
        ),
      ),
    );
  }

  Widget _buildHat(String? hatId) {
    if (hatId == null) return const SizedBox();

    final hat = ClothingCatalog.getById(hatId);
    if (hat == null) return const SizedBox();

    return Positioned(
      top: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          hat.emoji,
          style: TextStyle(fontSize: widget.size * 0.25),
        ),
      ),
    );
  }

  Widget _buildGlasses(String? glassesId) {
    if (glassesId == null) return const SizedBox();

    final glasses = ClothingCatalog.getById(glassesId);
    if (glasses == null) return const SizedBox();

    return Positioned(
      top: widget.size * 0.35,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          glasses.emoji,
          style: TextStyle(fontSize: widget.size * 0.15),
        ),
      ),
    );
  }

  Widget _buildBackground(String? backgroundId) {
    if (backgroundId == null) return const SizedBox();

    final background = ClothingCatalog.getById(backgroundId);
    if (background == null) return const SizedBox();

    return Container(
      width: widget.size * 1.5,
      height: widget.size * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background.emoji == '☁️'
            ? Colors.lightBlue.withOpacity(0.2)
            : AppColors.primary.withOpacity(0.1),
      ),
      child: Center(
        child: Text(
          background.emoji,
          style: TextStyle(fontSize: widget.size * 0.4),
        ),
      ),
    );
  }

  List<Widget> _buildAccessoriesBack(InventoryProvider inventory) {
    final accessories = inventory.equippedAccessories;
    final List<Widget> widgets = [];

    for (final accId in accessories) {
      final acc = ClothingCatalog.getById(accId);
      if (acc == null) continue;

      // Check if this is a "back" accessory (wings, cape, etc)
      if (_isBackAccessory(acc)) {
        widgets.add(
          Positioned(
            bottom: widget.size * 0.3,
            child: Text(
              acc.emoji,
              style: TextStyle(fontSize: widget.size * 0.3),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  List<Widget> _buildAccessoriesFront(InventoryProvider inventory) {
    final accessories = inventory.equippedAccessories;
    final List<Widget> widgets = [];

    for (final accId in accessories) {
      final acc = ClothingCatalog.getById(accId);
      if (acc == null) continue;

      // Check if this is a "front" accessory
      if (!_isBackAccessory(acc)) {
        widgets.add(
          Positioned(
            bottom: widget.size * 0.2,
            child: Text(
              acc.emoji,
              style: TextStyle(fontSize: widget.size * 0.25),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  bool _isBackAccessory(ClothingItem item) {
    // Items that should appear behind Pou
    final backAccessories = [
      'acc_wings_angel',
      'acc_wings_devil',
      'acc_wings_fairy',
      'acc_cape',
      'acc_wings_butterfly',
    ];

    return backAccessories.contains(item.id);
  }
}

// Compact version for stat bars
class PouPreviewCompact extends StatelessWidget {
  final double size;

  const PouPreviewCompact({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, pet, _) {
        final expression = pet.expression;
        final emoji = _getPouEmoji(expression);

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: size * 0.6),
            ),
          ),
        );
      },
    );
  }

  String _getPouEmoji(PouExpression expression) {
    switch (expression) {
      case PouExpression.happy:
        return '😄';
      case PouExpression.sad:
        return '😢';
      case PouExpression.tired:
        return '😴';
      case PouExpression.hungry:
        return '😋';
      case PouExpression.dirty:
        return '🤢';
      default:
        return '🟤';
    }
  }
}