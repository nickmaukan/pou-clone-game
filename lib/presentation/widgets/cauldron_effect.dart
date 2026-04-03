// lib/presentation/widgets/cauldron_effect.dart
import 'dart:math';
import 'package:flutter/material.dart';

class CauldronBubbles extends StatefulWidget {
  final bool isActive;
  final int bubbleCount;
  final Color baseColor;

  const CauldronBubbles({
    super.key,
    this.isActive = true,
    this.bubbleCount = 25,
    this.baseColor = const Color(0xFF55EFC4),
  });

  @override
  State<CauldronBubbles> createState() => _CauldronBubblesState();
}

class _CauldronBubblesState extends State<CauldronBubbles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<CauldronBubble> _bubbles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _generateBubbles();
  }

  void _generateBubbles() {
    _bubbles = List.generate(widget.bubbleCount, (index) {
      return CauldronBubble(
        x: 0.2 + _random.nextDouble() * 0.6,
        startY: 0.8,
        endY: 0.2 + _random.nextDouble() * 0.2,
        size: 5 + _random.nextDouble() * 15,
        speed: 0.4 + _random.nextDouble() * 0.6,
        delay: _random.nextDouble() * 0.7,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _bubbles.map((bubble) {
            final adjustedProgress = ((_controller.value - bubble.delay) / (1 - bubble.delay))
                .clamp(0.0, 1.0);

            if (adjustedProgress <= 0) return const SizedBox();

            final y = bubble.startY + (bubble.endY - bubble.startY) * Curves.easeOut.transform(adjustedProgress);
            final x = bubble.x + (_random.nextDouble() - 0.5) * 0.05;
            final opacity = 0.4 + _random.nextDouble() * 0.4;
            final scale = 1.0 - adjustedProgress * 0.3;

            return Positioned(
              left: MediaQuery.of(context).size.width * x,
              top: MediaQuery.of(context).size.height * y,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: bubble.size,
                    height: bubble.size,
                    decoration: BoxDecoration(
                      color: widget.baseColor.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class CauldronBubble {
  final double x;
  final double startY;
  final double endY;
  final double size;
  final double speed;
  final double delay;

  CauldronBubble({
    required this.x,
    required this.startY,
    required this.endY,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

// Vapor effect rising from cauldron
class VaporEffect extends StatefulWidget {
  final bool isActive;
  final int particleCount;
  final Color color;

  const VaporEffect({
    super.key,
    this.isActive = true,
    this.particleCount = 12,
    this.color = const Color(0xFF9B9B9B),
  });

  @override
  State<VaporEffect> createState() => _VaporEffectState();
}

class _VaporEffectState extends State<VaporEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<VaporParticle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _generateParticles();
  }

  void _generateParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return VaporParticle(
        x: 0.35 + _random.nextDouble() * 0.3,
        startY: 0.6,
        endY: 0.1 + _random.nextDouble() * 0.1,
        size: 30 + _random.nextDouble() * 30,
        delay: _random.nextDouble() * 0.8,
        wiggle: (_random.nextDouble() - 0.5) * 0.15,
        speed: 0.3 + _random.nextDouble() * 0.4,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _particles.map((particle) {
            final adjustedProgress = ((_controller.value - particle.delay) / (1 - particle.delay))
                .clamp(0.0, 1.0);

            if (adjustedProgress <= 0) return const SizedBox();

            final y = particle.startY + (particle.endY - particle.startY) * Curves.easeOut.transform(adjustedProgress);
            final x = particle.x + particle.wiggle * sin(adjustedProgress * pi * 4);
            final opacity = (1 - adjustedProgress) * 0.4;
            final scale = 0.5 + adjustedProgress * 1.5;

            return Positioned(
              left: MediaQuery.of(context).size.width * x,
              top: MediaQuery.of(context).size.height * y,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: particle.size,
                    height: particle.size,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class VaporParticle {
  final double x;
  final double startY;
  final double endY;
  final double size;
  final double delay;
  final double wiggle;
  final double speed;

  VaporParticle({
    required this.x,
    required this.startY,
    required this.endY,
    required this.size,
    required this.delay,
    required this.wiggle,
    required this.speed,
  });
}

// Cauldron visual widget
class CauldronWidget extends StatelessWidget {
  final Color liquidColor;
  final bool isActive;

  const CauldronWidget({
    super.key,
    this.liquidColor = const Color(0xFF55EFC4),
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cauldron body
          Positioned(
            bottom: 0,
            child: Container(
              width: 180,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: liquidColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          
          // Liquid inside
          Positioned(
            bottom: 20,
            child: Container(
              width: 150,
              height: 80,
              decoration: BoxDecoration(
                color: liquidColor.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.circular(40),
                ),
              ),
            ),
          ),
          
          // Bubbles
          if (isActive)
            Positioned(
              bottom: 30,
              left: 25,
              right: 25,
              child: CauldronBubbles(
                isActive: isActive,
                bubbleCount: 20,
                baseColor: liquidColor,
              ),
            ),
          
          // Cauldron rim
          Positioned(
            bottom: 110,
            child: Container(
              width: 200,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Handles
          Positioned(
            bottom: 60,
            left: 5,
            child: Container(
              width: 20,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 5,
            child: Container(
              width: 20,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Vapor
          if (isActive)
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: VaporEffect(
                isActive: isActive,
                particleCount: 10,
                color: liquidColor,
              ),
            ),
        ],
      ),
    );
  }
}