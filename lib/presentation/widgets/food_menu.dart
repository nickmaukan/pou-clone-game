// lib/presentation/widgets/food_menu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';
import '../../data/models/food_item.dart';
import '../providers/game_state_provider.dart';
import '../providers/pet_provider.dart';

class FoodMenu extends StatefulWidget {
  final Function(FoodItem) onFoodSelected;

  const FoodMenu({super.key, required this.onFoodSelected});

  @override
  State<FoodMenu> createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {
  FoodCategory _selectedCategory = FoodCategory.fruits;
  FoodItem? _selectedFood;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusXLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          _buildHandle(),
          
          // Category tabs
          _buildCategoryTabs(),
          
          // Food grid
          Flexible(
            child: _buildFoodGrid(),
          ),
          
          // Selected food info
          if (_selectedFood != null) _buildSelectedInfo(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: UIConstants.paddingMedium),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(UIConstants.paddingMedium),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: FoodCategory.values.map((category) {
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _selectedFood = null;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.paddingMedium,
                vertical: UIConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.displayName,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFoodGrid() {
    final foods = FoodCatalog.getByCategory(_selectedCategory);

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return _buildFoodItem(food);
        },
      ),
    );
  }

  Widget _buildFoodItem(FoodItem food) {
    final game = context.read<GameStateProvider>();
    final canAfford = game.canAfford(food.price);
    final isSelected = _selectedFood?.id == food.id;

    return GestureDetector(
      onTap: () {
        if (canAfford) {
          setState(() {
            _selectedFood = isSelected ? null : food;
          });
        } else {
          _showNotEnoughCoins();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    food.emoji,
                    style: TextStyle(
                      fontSize: 32,
                      color: canAfford ? null : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 10)),
                      Text(
                        '${food.price}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: canAfford ? AppColors.warning : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!canAfford)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock, color: Colors.white, size: 20),
                  ),
                ),
              ),
            if (food.isSpecial)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.rarityLegendary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('⭐', style: TextStyle(fontSize: 8)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedInfo() {
    final food = _selectedFood!;

    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusLarge),
        ),
      ),
      child: Row(
        children: [
          // Food icon and name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${food.emoji} ${food.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                // Stats effects
                Wrap(
                  spacing: 8,
                  children: [
                    if (food.hungerRestore > 0)
                      _buildStatChip('🍎 +${food.hungerRestore.toInt()}'),
                    if (food.energyRestore > 0)
                      _buildStatChip('⚡ +${food.energyRestore.toInt()}'),
                    if (food.funRestore > 0)
                      _buildStatChip('⭐ +${food.funRestore.toInt()}'),
                    if (food.cleanlinessRestore > 0)
                      _buildStatChip('💗 +${food.cleanlinessRestore.toInt()}'),
                  ],
                ),
              ],
            ),
          ),
          
          // Feed button
          ElevatedButton(
            onPressed: () => widget.onFoodSelected(food),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.paddingLarge,
                vertical: UIConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.radiusRound),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.restaurant, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  ' Alimentar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(UIConstants.radiusSmall),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  void _showNotEnoughCoins() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            const Text('No tienes suficientes monedas'),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
        ),
      ),
    );
  }
}