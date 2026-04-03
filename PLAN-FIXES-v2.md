# 📋 PLAN CORREGIDO - Pou Clone Game v2.0
## Arreglar Todos los Errores + Implementar Mejoras (100% FREE)

---

## FASES DE IMPLEMENTACIÓN

### 🔴 SEMANA 1: UX CRÍTICOS (Bugs + Navegación)
**Goal:** Hacer el juego usable y funcional

---

#### DAY 1: Bugs de Código

**1. Fix Evolution Level Bug (home_screen.dart)**
```dart
// LÍNEA 163 - cambiar:
'Nivel ${petProvider.pet?.evolutionLevel.index ?? 0 + 1}'
// POR:
'Nivel ${(petProvider.pet?.evolutionLevel.index ?? 0) + 1}'
```

**2. Fix Mirror Emoji Typo (bathroom_screen.dart)**
```dart
// LÍNEA 218 - cambiar:
child: const Text('🪞\', style: TextStyle(fontSize: 40)),
// POR:
child: const Text('🪞', style: TextStyle(fontSize: 40)),
```

**3. Fix Memory Match "Coming Soon" Duplicate (game_room_screen.dart)**
```dart
// ELIMINAR el _buildComingSoonCard duplicado para Memory Match
// Cambiar "Coming soon" a show real game
```

**4. Implement Settings Toggles (home_screen.dart)**
```dart
// Crear un bool _soundEnabled = true
// bool _musicEnabled = true

Switch(
  value: _soundEnabled,
  onChanged: (value) {
    setState(() => _soundEnabled = value);
    AudioService.instance.setSoundEnabled(value);
  },
)
```

**5. Implement Reset Game (home_screen.dart)**
```dart
// Crear función _resetGame() que:
void _resetGame() async {
  final db = await DatabaseService.getInstance();
  await db.clearAll();
  await context.read<PetProvider>().init();
  await context.read<GameStateProvider>().init();
  await context.read<InventoryProvider>().clearAll();
  if (mounted) Navigator.pushReplacementNamed(context, '/');
}
```

---

#### DAY 2: Navegación Arreglada

**6. Implementar IndexedStack Navigation (home_screen.dart)**
```dart
// REEMPLAZAR toda la estructura de HomeScreen:

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // 0=Living, 1=Kitchen, 2=Bathroom, 3=Lab, 4=GameRoom, 5=Closet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _LivingRoomContent(),
          KitchenScreen(),
          BathroomScreen(),
          LabScreen(),
          GameRoomScreen(),
          ClosetScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [...],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(emoji: '🏠', label: 'Home', index: 0),
          _NavItem(emoji: '🍳', label: 'Kitchen', index: 1),
          _NavItem(emoji: '🛁', label: 'Bath', index: 2),
          _NavItem(emoji: '🧪', label: 'Lab', index: 3),
          _NavItem(emoji: '🎮', label: 'Games', index: 4),
          _NavItem(emoji: '👗', label: 'Closet', index: 5),
        ],
      ),
    );
  }
}
```

**7. Eliminar LivingRoomScreen duplicado**
```bash
rm lib/presentation/screens/living_room/living_room_screen.dart
```

---

#### DAY 3: Closet UX Fixes

**8. Add Labels to Closet Tabs**
```dart
// En closet_screen.dart TabBar tabs:
Tab(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(category.emoji, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 4),
      Text(category.displayName, style: const TextStyle(fontSize: 10)), // AGREGAR ESTO
    ],
  ),
)
```

**9. Add Preview Before Buy (ClosetScreen)**
```dart
// Cuando user selecciona item pero no lo tiene:
// Mostrar preview temporal con Opacity animation
// Usar existing PouPreview con preview items

Container(
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.green.withOpacity(0.3),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      Icon(Icons.visibility, color: Colors.green),
      const SizedBox(width: 8),
      Text('Preview: ${item.name}', style: TextStyle(color: Colors.green)),
      TextButton(
        onPressed: () => _buyAndEquip(item),
        child: Text('Buy ${item.price} coins'),
      ),
    ],
  ),
)
```

**10. Confirm Before Unequip**
```dart
// En _handleItemTap - si ya está equipado:
if (_isItemEquipped(item, inventory)) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Quitar ${item.name}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(), child: Text('Mantener')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop();
            _unequipItem(item, inventory);
          },
          child: Text('Quitar'),
        ),
      ],
    ),
  );
  return;
}
```

---

#### DAY 4: Kitchen UX Improvements

**11. Show Pou Eating (don't cover with menu)**
```dart
// En kitchen_screen.dart - AGREGAR:
// When feeding, show smaller FoodMenu that doesn't cover Pou
BottomSheet(
  isScrollControlled: true,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.3,  // Solo 30% de pantalla
    maxChildSize: 0.6,
    minChildSize: 0.2,
    // Food menu content
  ),
)
```

**12. Show Eating Animation**
```dart
// Cuando food llega a Pou - cambiar expresión por 2 segundos
petProvider.setTemporaryExpression(PouExpression.happy, duration: seconds(2));
```

**13. Cancel Confirmation on Accidental Tap**
```dart
// Cuando user toca "Alimentar":
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('¿Alimentar con ${food.name}?'),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(food.emoji, style: TextStyle(fontSize: 50)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('+${food.hungerRestore.toInt()} 🍎'),
            if (food.energyRestore > 0) Text('+${food.energyRestore.toInt()} ⚡'),
            if (food.funRestore > 0) Text('+${food.funRestore.toInt()} ⭐'),
          ],
        ),
      ],
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(), child: Text('Cancelar')),
      ElevatedButton(
        onPressed: () {
          Navigator.pop();
          _feedPou(food);
        },
        child: Text('Alimentar (-${food.price} coins)'),
      ),
    ],
  ),
)
```

**14. Add Scroll Indicator for Food**
```dart
// En FoodMenu horizontal GridView - agregar:
child: Column(
  children: [
    GridView.builder(...),
    // Scroll indicator
    const SizedBox(height: 8),
    _ScrollIndicator(),
  ],
)

// Donde _ScrollIndicator es una flecha animada que parpadea
```

---

#### DAY 5: Bathroom UX Improvements

**15. Reduce Cleaning Time (make faster)**
```dart
// En bath_cleaning_action.dart:
static const BathCleaningAction shower = BathCleaningAction(
  type: CleaningType.shower,
  name: 'Ducha',
  emoji: '🚿',
  duration: Duration(seconds: 5),  // REDUCIDO de 10 a 5
  cleanlinessBonus: 20,  // REDUCIDO proporcionalmente
  ...
);

static const BathCleaningAction bathtub = BathCleaningAction(
  type: CleaningType.bathtub,
  name: 'Bañera',
  emoji: '🛁',
  duration: Duration(seconds: 8),  // REDUCIDO de 15 a 8
  cleanlinessBonus: 30,  // REDUCIDO proporcionalmente
  ...
);
```

**16. Add Cancel Confirmation for Cleaning**
```dart
// En bathroom_screen.dart - cuando cleaning está activo y user toca back:
if (_isCleaning) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('¿Cancelar limpieza?'),
      content: Text('Ya estás ${_selectedCleaningType?.name} - cancelarás el progreso.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(), child: Text('Continuar')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop();
            _cancelCleaning();
            context.read<NavigationProvider>().setRoom(RoomType.livingRoom);
          },
          child: Text('Sí, cancelar'),
        ),
      ],
    ),
  );
  return;
}
```

**17. Add Coin Cost to Bathroom (free → costs coins)**
```dart
// En bath_cleaning_action.dart:
static const BathCleaningAction shower = BathCleaningAction(
  ...
  coinCost: 5,  // AGREGAR
  ...
);
```

---

### 🟡 SEMANA 2: RETENTION MECHANICS
**Goal:** Hacer el juego adictivo sin monetización

---

#### DAY 1-2: Sistema de Enfermedad (Consecuencia)

**18. Add Sick State to Pet**
```dart
// En pet_model.dart:
class PetModel {
  ...
  bool isSick = false;
  DateTime? sickSince;

  bool get needsMedicalAttention =>
    hunger < 10 || cleanliness < 10 || fun < 10 || energy < 10;

  void update() {
    // Existing decay logic
    this.applyDecay();

    // NEW: Check for sick state
    if (needsMedicalAttention && !isSick) {
      isSick = true;
      sickSince = DateTime.now();
    } else if (!needsMedicalAttention && isSick) {
      isSick = false;
      sickSince = null;
    }

    // NEW: If any stat hits 0 for 60 seconds, pet faints
    if (hunger <= 0 || cleanliness <= 0 || fun <= 0 || energy <= 0) {
      if (sickSince != null &&
          DateTime.now().difference(sickSince!).inSeconds > 60) {
        petState = PetState.fainted;
      }
    }
  }
}

enum PetState { normal, sick, fainted, sleeping, eating }
```

**19. Add Sick Visual in PouCharacter**
```dart
// En pou_character.dart - mostrar expresión doente:
String _getPouEmoji(PouExpression expression) {
  // Si pet.isSick, mostrar expresión doente
  if (petProvider.pet?.isSick == true) {
    return '🤒'; // o 🤢 o 💀
  }
  // ... resto de expresiones
}
```

**20. Add Warning Overlay when Sick**
```dart
// En HomeScreen - agregar overlay:
if (petProvider.pet?.isSick == true) {
  overlay: Container(
    color: Colors.red.withOpacity(0.3),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🤒 ¡Pou está enfermo!', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 16),
          const Text('Stats críticos detectados', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => nav.setRoom(RoomType.lab), // Ir al Lab
            icon: const Icon(Icons.local_drink),
            label: const Text('Dar medicina'),
          ),
        ],
      ),
    ),
  );
}
```

**21. Make Mini-Games Disabled When Sick**
```dart
// En GameRoomScreen - cuando pet está enfermo:
if (petProvider.pet?.isSick == true) {
  // Show message instead of games
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🤒', style: TextStyle(fontSize: 80)),
        const Text('Pou está enfermo', style: TextStyle(fontSize: 24)),
        const Text('Recupéralo antes de jugar'),
        ElevatedButton(
          onPressed: () => nav.setRoom(RoomType.lab),
          child: const Text('Ir al Lab'),
        ),
      ],
    ),
  );
}
```

**22. Add Recovery Potion (Free - uses time)**
```dart
// En lab_screen.dart - AGREGAR:
class RecoveryPotionItem {
  static const potion = PotionItem(
    id: 'recovery_potion',
    name: 'Medicina',
    emoji: '💊',
    price: 0,  // FREE
    hungerRestore: 30,
    energyRestore: 30,
    funRestore: 30,
    cleanlinessRestore: 30,
    color: Colors.green,
    strength: PotionStrength.special,
  );
}

// BUT: Make it only available when pet is sick
// If pet.isSick == false, show "Usar medicina?" prompt
```

---

#### DAY 3-4: Daily Tasks & Streaks

**23. Create DailyTasksProvider**
```dart
class DailyTasksProvider extends ChangeNotifier {
  // Estructura de tareas diarias
  List<DailyTask> todayTasks = [
    DailyTask(id: 'feed3', description: 'Alimenta a Pou 3 veces', target: 3, current: 0, reward: 50),
    DailyTask(id: 'play2', description: 'Juega 2 mini-juegos', target: 2, current: 0, reward: 75),
    DailyTask(id: 'clean1', description: 'Limpia a Pou', target: 1, current: 0, reward: 30),
  ];

  // Guardar last login date
  // Si es nuevo día (medianoche local), reset tasks y actualizar streak
  DateTime? lastLoginDate;
  int currentStreak = 0;

  void checkAndResetIfNewDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastLoginDate == null) {
      // Primer login
      currentStreak = 1;
    } else {
      final lastDate = DateTime(lastLoginDate!.year, lastLoginDate!.month, lastLoginDate!.day);
      final diff = today.difference(lastDate).inDays;
      
      if (diff == 1) {
        // Login consecutive - increase streak
        currentStreak++;
      } else if (diff > 1) {
        // Streak broken - reset
        currentStreak = 1;
      }
      // diff == 0 = same day, no change
    }
    
    lastLoginDate = now;
    _saveProgress();
    notifyListeners();
  }
}
```

**24. Show Daily Tasks in HomeScreen**
```dart
// En HomeScreen - agregar widget:
class _DailyTasksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DailyTasksProvider>(
      builder: (context, tasks, _) {
        if (tasks.currentStreak > 0) {
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text('🔥 ${tasks.currentStreak} días', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tasks.todayTasks.map((task) {
                      return LinearProgressIndicator(
                        value: task.current / task.target,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation(
                          task.current >= task.target ? Colors.green : Colors.orange,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
```

---

#### DAY 5: Achievements System

**25. Create AchievementProvider**
```dart
class AchievementProvider extends ChangeNotifier {
  List<Achievement> achievements = [
    Achievement(id: 'first_feed', name: 'Primera alimentación', description: 'Alimenta a Pou por primera vez', icon: '🍎', isUnlocked: false, unlockedAt: null),
    Achievement(id: 'feed100', name: 'Chef de Pou', description: 'Alimenta a Pou 100 veces', icon: '👨‍🍳', target: 100, current: 0),
    Achievement(id: 'perfect_day', name: 'Día perfecto', description: 'Mantén todos los stats sobre 75% por 24h', icon: '⭐', isUnlocked: false),
    Achievement(id: 'evolution_child', name: 'Niño', description: 'Evoluciona a Child', icon: '🧒', isUnlocked: false),
    Achievement(id: 'evolution_adult', name: 'Adulto', description: 'Evoluciona a Adult', icon: '🧑', isUnlocked: false),
    Achievement(id: 'evolution_royal', name: 'Real', description: 'Evoluciona a Royal', icon: '👑', isUnlocked: false),
    Achievement(id: 'skyjump1000', name: 'Cloud Master', description: 'Alcanza 1000+ puntos en Sky Jump', icon: '☁️', target: 1000, current: 0),
    Achievement(id: 'pop100', name: 'Bubble Popper', description: 'Estalla 100 burbujas', icon: '🫧', target: 100, current: 0),
    Achievement(id: 'memory_master', name: 'Memoria de Acero', description: 'Completa Memory Match en menos de 60s', icon: '🧠', target: 60, current: 0),
    Achievement(id: 'streak7', name: 'Semana perfecta', description: '7 días seguidos', icon: '🔥', target: 7, current: 0),
    Achievement(id: 'collector10', name: 'Coleccionista', description: 'Own 10 clothing items', icon: '👗', target: 10, current: 0),
  ];

  void unlock(String id) {
    final achievement = achievements.firstWhere((a) => a.id == id);
    if (!achievement.isUnlocked) {
      achievement.isUnlocked = true;
      achievement.unlockedAt = DateTime.now();
      _showUnlockNotification(achievement);
      notifyListeners();
    }
  }

  void increment(String id, int amount) {
    final achievement = achievements.firstWhere((a) => a.id == id);
    if (!achievement.isUnlocked) {
      achievement.current += amount;
      if (achievement.current >= achievement.target) {
        unlock(id);
      }
      notifyListeners();
    }
  }

  void _showUnlockNotification(Achievement achievement) {
    // Mostrar snackbar o toast
    ScaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(achievement.icon, style: TextStyle(fontSize: 24)),
            SizedBox(width: 12),
            Expanded(child: Text('¡Logro desbloqueado: ${achievement.name}!')),
          ],
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
```

---

### 🟢 SEMANA 3: PERFORMANCE OPTIMIZATION
**Goal:** Hacer el juego fluido en dispositivos medianos

---

#### DAY 1: Cache MediaQuery (Highest Impact)

**26. Fix Particles MediaQuery Calls**
```dart
// En sparkle_particles.dart:

class _SparkleParticlesState extends State<SparkleParticles> {
  late AnimationController _controller;
  Size? _cachedSize;  // AGREGAR
  late List<Sparkle> _sparkles;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    
    _generateSparkles();
  }

  @override
  Widget build(BuildContext context) {
    // Cache size ONCE
    _cachedSize ??= MediaQuery.of(context).size;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _sparkles.map((sparkle) {
            // Usar _cachedSize! en vez de MediaQuery
            return Positioned(
              left: _cachedSize!.width * sparkle.x,
              top: _cachedSize!.height * sparkle.y,
              ...
            );
          }).toList(),
        );
      },
    );
  }
}
```

**Hacer lo mismo en:**
- `hearts_particles.dart`
- `water_droplets.dart`
- `cauldron_effect.dart`
- `bubbles_effect.dart`

---

#### DAY 2: Throttle PetProvider Notifies

**27. Add Change Detection + Throttle**
```dart
// En pet_provider.dart:

class PetProvider extends ChangeNotifier {
  DateTime? _lastNotifyTime;
  static const _minNotifyInterval = Duration(milliseconds: 100); // 10fps max
  double? _lastHunger, _lastCleanliness, _lastFun, _lastEnergy;

  void _throttledNotify() {
    final now = DateTime.now();
    if (_lastNotifyTime == null ||
        now.difference(_lastNotifyTime!) > _minNotifyInterval) {
      _lastNotifyTime = now;
      notifyListeners();
    }
  }

  void _applyDecay() {
    if (_pet == null) return;
    final changed = _pet!.applyDecay();
    
    // Solo notify si valores cambiaron
    if (changed) {
      _throttledNotify();
    }
  }

  void feed(FoodItem food) {
    if (_pet == null) return;
    _pet!.updateStats(
      hunger: hunger + food.hungerRestore,
      cleanliness: cleanliness + food.cleanlinessRestore,
      fun: fun + food.funRestore,
      energy: energy + food.energyRestore,
    );
    if (food.experienceGained > 0) {
      _pet!.addExperience(food.experienceGained);
    }
    _setAnimation(PouAnimation.eating);
    _savePet();
    _throttledNotify();  // Throttled
  }
}
```

---

#### DAY 3: Cancel Animation Futures Properly

**28. Use Timer Instead of Future.delayed**
```dart
class PetProvider extends ChangeNotifier {
  Timer? _animationResetTimer;

  void _setAnimation(PouAnimation animation) {
    _animationResetTimer?.cancel();  // Cancel previous
    _currentAnimation = animation;
    notifyListeners();

    _animationResetTimer = Timer(const Duration(seconds: 2), () {
      if (_currentAnimation == animation) {
        _currentAnimation = PouAnimation.idle;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _animationResetTimer?.cancel();
    _decayTimer?.cancel();
    super.dispose();
  }
}
```

---

#### DAY 4: Split PouCharacter (Reduce Rebuilds)

**29. Separate Animation from Tap Handler**
```dart
// En pou_character.dart:

class PouCharacter extends StatelessWidget {
  final double size;

  const PouCharacter({super.key, this.size = 250});

  @override
  Widget build(BuildContext context) {
    return _PouTapHandler(size: size);
  }
}

class _PouTapHandler extends StatelessWidget {
  final double size;
  
  const _PouTapHandler({required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_) => context.read<PetProvider>().play(5),
      child: _PouAnimationWidget(size: size),  // Only rebuilds on animation
    );
  }
}

class _PouAnimationWidget extends StatefulWidget {
  final double size;
  
  const _PouAnimationWidget({required this.size});

  @override
  State<_PouAnimationWidget> createState() => _PouAnimationWidgetState();
}

class _PouAnimationWidgetState extends State<_PouAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    _controller = AnimationController(...)..repeat(reverse: true);
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
        // Rebuilds ONLY on animation tick
        return Consumer<PetProvider>(
          builder: (context, pet, _) {
            // Solo rebuild cuando expression cambia
            return Text(
              _getPouEmoji(pet.expression),
              style: TextStyle(fontSize: widget.size * 0.6),
            );
          },
        );
      },
    );
  }
}
```

---

#### DAY 5: Memory Match Theme Fix

**30. Re-skin Memory Match with Pou Theme**
```dart
// En memory_match_game.dart - cambiar emojis:

const emojis = [
  '🟤',  // Pou normal
  '😄',  // Happy
  '😢',  // Sad
  '😴',  // Tired
  '😋',  // Hungry
  '🤢',  // Dirty
  '👒',  // Hat
  '👓',  // Glasses
];
```

---

### 🔵 SEMANA 4: POLISH & EXTRAS

---

#### DAY 1: Persist High Scores

**31. Add SharedPreferences for High Scores**
```dart
// En game_state_provider.dart:
import 'package:shared_preferences/shared_preferences.dart';

class GameStateProvider extends ChangeNotifier {
  static const _keySkyJumpBest = 'sky_jump_best';
  static const _keyPouPopperBest = 'pou_popper_best';
  static const _keyMemoryMatchBest = 'memory_match_best';

  int skyJumpBestScore = 0;
  int pouPopperBestScore = 0;
  int memoryMatchBestScore = 0;

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    skyJumpBestScore = prefs.getInt(_keySkyJumpBest) ?? 0;
    pouPopperBestScore = prefs.getInt(_keyPouPopperBest) ?? 0;
    memoryMatchBestScore = prefs.getInt(_keyMemoryMatchBest) ?? 0;
  }

  Future<void> _saveHighScore(String game, int score) async {
    final prefs = await SharedPreferences.getInstance();
    switch (game) {
      case 'skyjump':
        if (score > skyJumpBestScore) {
          skyJumpBestScore = score;
          await prefs.setInt(_keySkyJumpBest, score);
        }
        break;
      // etc...
    }
  }
}
```

**32. Show High Scores in Game Room**
```dart
// En game_room_screen.dart - agregar:
Column(
  children: [
    _buildGameCard(
      title: 'SKY JUMP',
      bestScore: game.skyJumpBestScore,  // Mostrar mejor score
      ...
    ),
  ],
)
```

---

#### DAY 2: Progressive Difficulty

**33. Add Difficulty Scaling to Sky Jump**
```dart
// En sky_jump_game.dart:

void _updateDifficulty() {
  // Basado en games played (stored in GameStateProvider)
  final gamesPlayed = context.read<GameStateProvider>().skyJumpGamesPlayed;
  
  if (gamesPlayed < 10) {
    cloudSpeedMultiplier = 1.0;
    cloudSizeMultiplier = 1.0;
  } else if (gamesPlayed < 50) {
    cloudSpeedMultiplier = 1.1;
    cloudSizeMultiplier = 0.95;
  } else if (gamesPlayed < 100) {
    cloudSpeedMultiplier = 1.2;
    cloudSizeMultiplier = 0.9;
    // Empezar a spawn moving clouds más frecuentemente
  } else {
    cloudSpeedMultiplier = 1.3;
    cloudSizeMultiplier = 0.85;
    // breaking clouds más frecuentes
  }
}
```

---

#### DAY 3: Add "Help My Pou" Social (Local Only)

**34. Create Help System**
```dart
// En GameStateProvider:
int helpRequestsRemaining = 3;  // Max 3 por día
int helpsGivenToday = 0;         // Max 5 por día

void requestHelp() {
  if (helpRequestsRemaining > 0) {
    helpRequestsRemaining--;
    // En una versión real, esto mandaría notificación a amigos
    // Por ahora, simulamos que alguien ayudó
    petProvider.feed(FoodItem(id: 'help_food', name: 'Ayuda', emoji: '🎁', price: 0, hungerRestore: 20, category: FoodCategory.special));
    notifyListeners();
  }
}

void giveHelp() {
  if (helpsGivenToday < 5) {
    helpsGivenToday++;
    coins += 5;  // Bonus por ayudar
    notifyListeners();
  }
}
```

---

#### DAY 4: Notification System (Awareness)

**35. Local Notifications When Stats Low**
```dart
// En pet_provider.dart:
void _applyDecay() {
  _pet!.applyDecay();
  
  // Check for warning thresholds
  if (pet!.hunger < 30 && pet!.hunger >= 25) {
    // Solo notificar una vez
    if (!_hungerWarningShown) {
      _hungerWarningShown = true;
      // En app real: mostrar snackbar o notification
      // Por ahora solo log
      debugPrint('⚠️ Hambre baja: ${pet!.hunger}');
    }
  } else if (pet!.hunger >= 30) {
    _hungerWarningShown = false;
  }
  // Lo mismo para otros stats...
}
```

---

#### DAY 5: Final Testing & Bug Fixes

**36. Run Flutter Analyze**
```bash
cd ~/.openclaw/workspace/pou_game
flutter analyze
```

**37. Fix Any Remaining Warnings**

**38. Build Final APK**
```bash
flutter build apk --debug
```

---

## 📊 CHECKLIST DE IMPLEMENTACIÓN

| # | Task | Priority | Status |
|---|------|----------|--------|
| 1 | Evolution level bug fix | CRITICAL | ⬜ |
| 2 | Mirror emoji typo | HIGH | ⬜ |
| 3 | Memory Match duplicate fix | CRITICAL | ⬜ |
| 4 | Settings toggles working | HIGH | ⬜ |
| 5 | Reset game functional | CRITICAL | ⬜ |
| 6 | IndexedStack navigation | CRITICAL | ⬜ |
| 7 | Delete duplicate LivingRoomScreen | MEDIUM | ⬜ |
| 8 | Closet tab labels | CRITICAL | ⬜ |
| 9 | Preview before buy | HIGH | ⬜ |
| 10 | Confirm before unequip | MEDIUM | ⬜ |
| 11 | Kitchen: smaller menu, show Pou | HIGH | ⬜ |
| 12 | Kitchen: confirm before feed | MEDIUM | ⬜ |
| 13 | Kitchen: scroll indicator | LOW | ⬜ |
| 14 | Bathroom: reduce cleaning time | HIGH | ⬜ |
| 15 | Bathroom: cancel confirmation | HIGH | ⬜ |
| 16 | Bathroom: add coin cost | MEDIUM | ⬜ |
| 17 | Sick state system | CRITICAL | ⬜ |
| 18 | Sick visual + warning overlay | CRITICAL | ⬜ |
| 19 | Disable games when sick | HIGH | ⬜ |
| 20 | Recovery potion (free) | HIGH | ⬜ |
| 21 | Daily tasks provider | HIGH | ⬜ |
| 22 | Streak system | HIGH | ⬜ |
| 23 | Achievement provider | MEDIUM | ⬜ |
| 24 | Achievement unlock notifications | MEDIUM | ⬜ |
| 25 | Cache MediaQuery in particles | CRITICAL | ⬜ |
| 26 | Throttle PetProvider notifies | CRITICAL | ⬜ |
| 27 | Cancel animation futures | HIGH | ⬜ |
| 28 | Split PouCharacter | MEDIUM | ⬜ |
| 29 | Memory Match Pou theme | MEDIUM | ⬜ |
| 30 | Persist high scores | HIGH | ⬜ |
| 31 | Show high scores in game room | MEDIUM | ⬜ |
| 32 | Progressive difficulty | MEDIUM | ⬜ |
| 33 | Help system | MEDIUM | ⬜ |
| 34 | Notification awareness | LOW | ⬜ |
| 35 | Final testing + build | - | ⬜ |

---

## 📁 ARCHIVOS A MODIFICAR

| Archivo | Cambios |
|---------|---------|
| `home_screen.dart` | Navigation, bugs, warnings |
| `bathroom_screen.dart` | Typo, time, confirmations |
| `kitchen_screen.dart` | Menu size, confirmations |
| `closet_screen.dart` | Tab labels, preview, confirm |
| `lab_screen.dart` | Recovery potion |
| `game_room_screen.dart` | Duplicate fix, high scores |
| `pet_provider.dart` | Throttle, cancel futures, sick state |
| `pet_model.dart` | Sick state tracking |
| `game_state_provider.dart` | High scores, daily tasks |
| `sparkle_particles.dart` | Cache MediaQuery |
| `hearts_particles.dart` | Cache MediaQuery |
| `water_droplets.dart` | Cache MediaQuery |
| `cauldron_effect.dart` | Cache MediaQuery |
| `pou_character.dart` | Split animation/tap |
| `memory_match_game.dart` | Pou emojis |
| `sky_jump_game.dart` | Difficulty scaling |

---

## ⏱️ TIMELINE

| Semana | Foco | Días Estimados |
|--------|------|----------------|
| **Semana 1** | UX Críticos | 5 |
| **Semana 2** | Retention | 5 |
| **Semana 3** | Performance | 5 |
| **Semana 4** | Polish | 5 |
| **TOTAL** | | **~20 días** |

---

## 🎯 RESULTADO ESPERADO

Al final:
- ✅ 0 bugs críticos
- ✅ Navegación fluida
- ✅ Stats con consecuencias (enfermedad)
- ✅ Retention hooks (streaks, achievements, dailies)
- ✅ Performance optimizado
- ✅ UI/UX pulido
- ✅ 100% Free to play

**Score objetivo: 7-8/10**