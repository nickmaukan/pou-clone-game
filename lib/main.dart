// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/services/audio_service.dart';
import 'presentation/providers/pet_provider.dart';
import 'presentation/providers/game_state_provider.dart';
import 'presentation/providers/navigation_provider.dart';
import 'presentation/providers/inventory_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ),
  );
  
  // Initialize services
  AudioService.getInstance();
  
  runApp(const PouGame());
}

class PouGame extends StatelessWidget {
  const PouGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Navigation
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        
        // Game State (needs to be initialized first)
        ChangeNotifierProvider(create: (_) => GameStateProvider()),
        
        // Pet
        ChangeNotifierProvider(create: (_) => PetProvider()),
        
        // Inventory (depends on GameStateProvider)
        ChangeNotifierProxyProvider<GameStateProvider, InventoryProvider>(
          create: (context) => InventoryProvider(context.read<GameStateProvider>()),
          update: (context, gameState, previous) => previous ?? InventoryProvider(gameState),
        ),
      ],
      child: MaterialApp(
        title: 'Pou Game',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
