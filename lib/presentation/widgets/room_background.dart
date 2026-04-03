// lib/presentation/widgets/room_background.dart
import 'package:flutter/material.dart';
import '../../core/enums/room_type.dart';

class RoomBackground extends StatelessWidget {
  final RoomType roomType;
  final Widget child;

  const RoomBackground({
    super.key,
    required this.roomType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getGradient(),
      ),
      child: Stack(
        children: [
          // Background elements
          ..._getBackgroundElements(),
          // Content
          child,
        ],
      ),
    );
  }

  LinearGradient _getGradient() {
    switch (roomType) {
      case RoomType.livingRoom:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        );
      case RoomType.kitchen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2D2D44),
            Color(0xFF1E1E2E),
          ],
        );
      case RoomType.bathroom:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1F4068),
            Color(0xFF162447),
          ],
        );
      case RoomType.lab:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF0F0F23),
          ],
        );
      case RoomType.gameRoom:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E1E3E),
            Color(0xFF0D0D1A),
          ],
        );
      case RoomType.closet:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A2A4A),
            Color(0xFF1A1A2E),
          ],
        );
      case RoomType.shop:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3A2A5A),
            Color(0xFF1A1A2E),
          ],
        );
    }
  }

  List<Widget> _getBackgroundElements() {
    switch (roomType) {
      case RoomType.livingRoom:
        return [
          // Window
          Positioned(
            top: 50,
            left: 100,
            child: _buildWindow(),
          ),
          // Sofa
          Positioned(
            bottom: 200,
            left: 100,
            child: _buildSofa(),
          ),
          // Plant
          Positioned(
            bottom: 150,
            right: 80,
            child: _buildPlant(),
          ),
        ];
      case RoomType.kitchen:
        return [
          // Counter
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: _buildCounter(),
          ),
          // Fridge
          Positioned(
            bottom: 200,
            right: 50,
            child: _buildFridge(),
          ),
        ];
      case RoomType.bathroom:
        return [
          // Bathtub
          Positioned(
            bottom: 150,
            left: 150,
            child: _buildBathtub(),
          ),
          // Shower
          Positioned(
            bottom: 300,
            right: 100,
            child: _buildShower(),
          ),
        ];
      case RoomType.lab:
        return [
          // Cauldron
          Positioned(
            bottom: 150,
            left: 200,
            child: _buildCauldron(),
          ),
          // Shelves
          Positioned(
            top: 100,
            left: 50,
            child: _buildShelves(),
          ),
        ];
      case RoomType.gameRoom:
        return [
          // Arcade machine
          Positioned(
            bottom: 150,
            left: 100,
            child: _buildArcadeMachine(),
          ),
          // TV
          Positioned(
            top: 80,
            left: 200,
            child: _buildTV(),
          ),
        ];
      case RoomType.closet:
        return [
          // Mirror
          Positioned(
            top: 100,
            right: 100,
            child: _buildMirror(),
          ),
          // Wardrobe
          Positioned(
            top: 80,
            left: 50,
            child: _buildWardrobe(),
          ),
        ];
      case RoomType.shop:
        return [
          // Display
          Positioned(
            top: 150,
            left: 150,
            child: _buildDisplay(),
          ),
          // Counter
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: _buildShopCounter(),
          ),
        ];
    }
  }

  Widget _buildWindow() => Container(
    width: 150,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.lightBlue.withOpacity(0.3),
      border: Border.all(color: Colors.brown.shade700, width: 8),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Stack(
      children: [
        // Clouds
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        // Cross
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.brown.shade700, width: 4),
          ),
        ),
      ],
    ),
  );

  Widget _buildSofa() => Container(
    width: 200,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.red.shade800,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    ),
  );

  Widget _buildPlant() => Column(
    children: [
      Container(
        width: 40,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.brown.shade700,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
      ),
    ],
  );

  Widget _buildCounter() => Container(
    height: 120,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.grey.shade400,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
  );

  Widget _buildFridge() => Container(
    width: 80,
    height: 160,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.grey.shade300, width: 2),
    ),
  );

  Widget _buildBathtub() => Container(
    width: 180,
    height: 80,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      border: Border.all(color: Colors.grey.shade400, width: 4),
    ),
  );

  Widget _buildShower() => Container(
    width: 60,
    height: 150,
    decoration: BoxDecoration(
      color: Colors.grey.shade600,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
  );

  Widget _buildCauldron() => Container(
    width: 120,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(60),
        bottomRight: Radius.circular(60),
      ),
    ),
    child: Stack(
      children: [
        // Bubbles
        Positioned(
          top: 10,
          left: 20,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 30,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildShelves() => Column(
    children: List.generate(3, (index) => Container(
      width: 100,
      height: 20,
      margin: const EdgeInsets.only(bottom: 40),
      color: Colors.brown.shade600,
    )),
  );

  Widget _buildArcadeMachine() => Container(
    width: 80,
    height: 150,
    decoration: BoxDecoration(
      color: Colors.purple.shade800,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Widget _buildTV() => Container(
    width: 200,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(color: Colors.grey.shade700, width: 8),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Container(
      margin: const EdgeInsets.all(10),
      color: Colors.blueGrey.shade800,
    ),
  );

  Widget _buildMirror() => Container(
    width: 120,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.lightBlue.shade100,
      border: Border.all(color: Colors.grey.shade400, width: 8),
      borderRadius: BorderRadius.circular(60),
    ),
  );

  Widget _buildWardrobe() => Container(
    width: 150,
    height: 250,
    decoration: BoxDecoration(
      color: Colors.brown.shade700,
      borderRadius: BorderRadius.circular(5),
    ),
  );

  Widget _buildDisplay() => Container(
    width: 150,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.purple.shade900,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Widget _buildShopCounter() => Container(
    height: 100,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.brown.shade600,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
  );
}
