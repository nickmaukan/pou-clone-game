// lib/presentation/screens/closet/closet_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/enums/room_type.dart';
import '../../../core/enums/item_category.dart' as cat;
import '../../../core/enums/item_category.dart' show ItemRarity;
import '../../../data/models/clothing_item.dart';
import '../../providers/pet_provider.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../widgets/coin_display.dart';
import '../../widgets/pou_preview.dart';

enum ClosetCategory {
  hats,
  glasses,
  outfits,
  accessories,
  eyeColors,
  bodyColors,
}

extension ClosetCategoryExtension on ClosetCategory {
  String get emoji {
    switch (this) {
      case ClosetCategory.hats:
        return '👒';
      case ClosetCategory.glasses:
        return '👓';
      case ClosetCategory.outfits:
        return '👗';
      case ClosetCategory.accessories:
        return '🎭';
      case ClosetCategory.eyeColors:
        return '👁️';
      case ClosetCategory.bodyColors:
        return '🎨';
    }
  }

  String get displayName {
    switch (this) {
      case ClosetCategory.hats:
        return 'Sombreros';
      case ClosetCategory.glasses:
        return 'Lentes';
      case ClosetCategory.outfits:
        return 'Outfits';
      case ClosetCategory.accessories:
        return 'Accesorios';
      case ClosetCategory.eyeColors:
        return 'Ojos';
      case ClosetCategory.bodyColors:
        return 'Color';
    }
  }

  cat.ItemCategory get itemCategory {
    switch (this) {
      case ClosetCategory.hats:
        return cat.ItemCategory.hat;
      case ClosetCategory.glasses:
        return cat.ItemCategory.glasses;
      case ClosetCategory.outfits:
        return cat.ItemCategory.outfit;
      case ClosetCategory.accessories:
        return cat.ItemCategory.accessory;
      case ClosetCategory.eyeColors:
        return cat.ItemCategory.glasses;
      case ClosetCategory.bodyColors:
        return cat.ItemCategory.outfit;
    }
  }
}

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen>
    with SingleTickerProviderStateMixin {
  ClosetCategory _selectedCategory = ClosetCategory.hats;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = ClosetCategory.values[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Pou Preview Area
            _buildPreviewArea(),

            // Category Tabs
            _buildCategoryTabs(),

            // Items Grid
            Expanded(
              child: _buildItemsGrid(),
            ),
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
          // Back button
          IconButton(
            onPressed: () {
              context.read<NavigationProvider>().setRoom(RoomType.livingRoom);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textSecondary,
              size: 32,
            ),
          ),

          // Title
          const Row(
            children: [
              Text('👗 ', style: TextStyle(fontSize: 24)),
              Text(
                'VESTIDOR',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),

          // Coins
          Consumer<GameStateProvider>(
            builder: (context, game, _) => CoinDisplay(coins: game.coins),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea() {
    return Container(
      height: 280,
      margin: const EdgeInsets.all(UIConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.closetColor.withOpacity(0.2),
            AppColors.closetColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
        border: Border.all(color: AppColors.closetColor.withOpacity(0.3), width: 2),
      ),
      child: Stack(
        children: [
          // Mirror frame effect
          Positioned.fill(
            child: CustomPaint(
              painter: MirrorFramePainter(),
            ),
          ),

          // Pou Preview
          const Center(
            child: PouPreview(size: 180),
          ),

          // Current outfit name
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Consumer<InventoryProvider>(
              builder: (context, inventory, _) {
                final outfit = inventory.equippedOutfit;
                final outfitName = outfit != null
                    ? ClothingCatalog.getById(outfit)?.name ?? 'Custom'
                    : 'Sin outfit';
                
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.paddingMedium,
                    vertical: UIConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(UIConstants.radiusRound),
                  ),
                  child: Text(
                    'Outfit: $outfitName',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),

          // Stats indicator
          Positioned(
            top: 10,
            right: 10,
            child: Consumer<PetProvider>(
              builder: (context, pet, _) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatMini('🍎', pet.hunger),
                      const SizedBox(width: 8),
                      _buildStatMini('💗', pet.cleanliness),
                      const SizedBox(width: 8),
                      _buildStatMini('⭐', pet.fun),
                      const SizedBox(width: 8),
                      _buildStatMini('⚡', pet.energy),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatMini(String emoji, double value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        Container(
          width: 30,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (value / 100).clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: _getStatColor(value),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatColor(double value) {
    if (value > 75) return AppColors.success;
    if (value > 50) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: AppColors.closetColor,
        indicatorWeight: 3,
        labelColor: AppColors.closetColor,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        tabAlignment: TabAlignment.fill,
        tabs: ClosetCategory.values.map((category) {
          return Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  category.displayName,  // ADDED LABELS
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemsGrid() {
    final items = _getItemsForCategory(_selectedCategory);

    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(item);
        },
      ),
    );
  }

  List<ClothingItem> _getItemsForCategory(ClosetCategory category) {
    switch (category) {
      case ClosetCategory.hats:
        return ClothingCatalog.hats;
      case ClosetCategory.glasses:
        return ClothingCatalog.glasses;
      case ClosetCategory.outfits:
        return ClothingCatalog.outfits;
      case ClosetCategory.accessories:
        return ClothingCatalog.accessories;
      case ClosetCategory.eyeColors:
        return _getEyeColorItems();
      case ClosetCategory.bodyColors:
        return _getBodyColorItems();
    }
  }

  List<ClothingItem> _getEyeColorItems() {
    const eyeColors = [
      ('Ojos Negros', Color(0xFF000000), '👁️'),
      ('Ojos Marrones', Color(0xFF8B4513), '🟤'),
      ('Ojos Azules', Color(0xFF2196F3), '🔵'),
      ('Ojos Verdes', Color(0xFF4CAF50), '🟢'),
      ('Ojos Púrpura', Color(0xFF9C27B0), '🟣'),
      ('Ojos Rojos', Color(0xFFF44336), '🔴'),
      ('Ojos Dorados', Color(0xFFFFD700), '🟡'),
      ('Ojos Blancos', Color(0xFFFFFFFF), '⚪'),
    ];

    return eyeColors.asMap().entries.map((entry) {
      final color = entry.value;
      return ClothingItem(
        id: 'eye_${entry.key}',
        name: color.$1,
        emoji: color.$3,
        category: cat.ItemCategory.glasses,
        rarity: ItemRarity.common,
        price: 50,
      );
    }).toList();
  }

  List<ClothingItem> _getBodyColorItems() {
    const bodyColors = [
      ('Marrón Clásico', Color(0xFF8B4513), '🟤'),
      ('Verde Fresco', Color(0xFF4CAF50), '🟢'),
      ('Azul Océano', Color(0xFF2196F3), '🔵'),
      ('Rosa Sweet', Color(0xFFE91E63), '🩷'),
      ('Naranja Solar', Color(0xFFFF9800), '🟠'),
      ('Púrpura Místico', Color(0xFF9C27B0), '🟣'),
      ('Negro Obscuro', Color(0xFF000000), '⚫'),
      ('Dorado Divino', Color(0xFFFFD700), '✨'),
    ];

    return bodyColors.asMap().entries.map((entry) {
      final color = entry.value;
      return ClothingItem(
        id: 'body_${entry.key}',
        name: color.$1,
        emoji: color.$3,
        category: cat.ItemCategory.outfit,
        rarity: ItemRarity.common,
        price: 100,
      );
    }).toList();
  }

  Widget _buildItemCard(ClothingItem item) {
    final inventory = context.read<InventoryProvider>();
    final game = context.read<GameStateProvider>();
    
    final isOwned = inventory.ownsItem(item.id);
    final isEquipped = _isItemEquipped(item, inventory);
    final canAfford = game.canAfford(item.price);

    return GestureDetector(
      onTap: () => _handleItemTap(item, inventory, game),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isEquipped
              ? AppColors.closetColor.withOpacity(0.3)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
          border: Border.all(
            color: isEquipped
                ? AppColors.closetColor
                : isOwned
                    ? AppColors.success.withOpacity(0.5)
                    : Colors.transparent,
            width: isEquipped ? 3 : 2,
          ),
          boxShadow: isEquipped
              ? [
                  BoxShadow(
                    color: AppColors.closetColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Item content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Item emoji
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getRarityColor(item.rarity).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Item name
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Price or equipped
                  if (isEquipped)
                    const Text(
                      '✓',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (isOwned)
                    const Text(
                      '✓',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('💰', style: TextStyle(fontSize: 9)),
                        Text(
                          '${item.price}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: canAfford ? AppColors.warning : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Owned checkmark
            if (isOwned && !isEquipped)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: Colors.white, size: 10),
                  ),
                ),
              ),

            // Rarity indicator
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getRarityColor(item.rarity),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(cat.ItemRarity rarity) {
    switch (rarity) {
      case cat.ItemRarity.common:
        return AppColors.common;
      case cat.ItemRarity.uncommon:
        return AppColors.uncommon;
      case cat.ItemRarity.rare:
        return AppColors.rare;
      case cat.ItemRarity.epic:
        return AppColors.epic;
      case cat.ItemRarity.legendary:
        return AppColors.legendary;
    }
  }

  bool _isItemEquipped(ClothingItem item, InventoryProvider inventory) {
    switch (item.category) {
      case cat.ItemCategory.hat:
        return inventory.equippedHat == item.id;
      case cat.ItemCategory.glasses:
        return inventory.equippedGlasses == item.id;
      case cat.ItemCategory.outfit:
        return inventory.equippedOutfit == item.id;
      case cat.ItemCategory.accessory:
        return inventory.equippedAccessories.contains(item.id);
      case cat.ItemCategory.background:
        return inventory.equippedBackground == item.id;
      default:
        return false;
    }
  }

  void _handleItemTap(ClothingItem item, InventoryProvider inventory, GameStateProvider game) {
    // Check if already equipped - if so, unequip
    if (_isItemEquipped(item, inventory)) {
      _unequipItem(item, inventory);
      return;
    }

    // If already owned, equip
    if (inventory.ownsItem(item.id)) {
      _equipItem(item, inventory);
      return;
    }

    // Need to buy
    if (game.canAfford(item.price)) {
      _buyAndEquip(item, inventory, game);
    } else {
      _showError('No tienes suficientes monedas');
    }
  }

  void _equipItem(ClothingItem item, InventoryProvider inventory) {
    switch (item.category) {
      case cat.ItemCategory.hat:
        inventory.equipHat(item.id);
        break;
      case cat.ItemCategory.glasses:
        inventory.equipGlasses(item.id);
        break;
      case cat.ItemCategory.outfit:
        inventory.equipOutfit(item.id);
        break;
      case cat.ItemCategory.accessory:
        inventory.equipAccessory(item.id);
        break;
      case cat.ItemCategory.background:
        inventory.equipBackground(item.id);
        break;
      default:
        break;
    }

    _showSuccess('¡${item.name} equipado!');
  }

  void _unequipItem(ClothingItem item, InventoryProvider inventory) {
    switch (item.category) {
      case cat.ItemCategory.hat:
        inventory.equipHat(null);
        break;
      case cat.ItemCategory.glasses:
        inventory.equipGlasses(null);
        break;
      case cat.ItemCategory.outfit:
        inventory.equipOutfit(null);
        break;
      case cat.ItemCategory.accessory:
        inventory.unequipAccessory(item.id);
        break;
      case cat.ItemCategory.background:
        inventory.equipBackground(null);
        break;
      default:
        break;
    }

    _showSuccess('${item.name} quitado');
  }

  void _buyAndEquip(ClothingItem item, InventoryProvider inventory, GameStateProvider game) {
    // Deduct coins
    game.spendCoins(item.price);

    // Add to inventory
    inventory.buyClothing(item);

    // Equip
    _equipItem(item, inventory);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

// Mirror frame painter
class MirrorFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final rect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      paint,
    );

    // Corner decorations
    final cornerPaint = Paint()
      ..color = Colors.amber.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(25, 25), 8, cornerPaint);
    canvas.drawCircle(Offset(size.width - 25, 25), 8, cornerPaint);
    canvas.drawCircle(Offset(25, size.height - 25), 8, cornerPaint);
    canvas.drawCircle(Offset(size.width - 25, size.height - 25), 8, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}