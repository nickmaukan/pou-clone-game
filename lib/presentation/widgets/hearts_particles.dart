// lib/presentation/widgets/hearts_particles.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HeartsParticles extends StatefulWidget {
  final int heartCount;
  final Color color;

  const HeartsParticles({
    super.key,
    this.heartCount = 8,
    this.color = Colors.pink,
  });

  @override
  State<HeartsParticles> createState() => _HeartsParticlesState();
}

class _HeartsParticlesState extends State<HeartsParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<HeartParticle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _particles = List.generate(widget.heartCount, (index) {
      return HeartParticle(
        startX: 0.3 + _random.nextDouble() * 0.4, // 30-70% of width
        startY: 0.5 + _random.nextDouble() * 0.2, // 50-70% of height
        endY: 0.2 + _random.nextDouble() * 0.3, // 20-50% of height
        size: 20 + _random.nextDouble() * 20, // 20-40px
        wobble: (_random.nextDouble() - 0.5) * 0.3, // -0.15 to 0.15
        delay: _random.nextDouble() * 0.3, // 0-300ms delay
        color: widget.color.withOpacity(0.6 + _random.nextDouble() * 0.4),
      );
    });

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
        return Stack(
          children: _particles.map((particle) {
            final adjustedProgress = ((_controller.value - particle.delay) / (1 - particle.delay)).clamp(0.0, 1.0);
            
            if (adjustedProgress <= 0) return const SizedBox.shrink();

            final y = particle.startY - (particle.startY - particle.endY) * Curves.easeOut.transform(adjustedProgress);
            final x = particle.startX + particle.wobble * sin(adjustedProgress * pi);
            final opacity = (1 - adjustedProgress).clamp(0.0, 1.0);
            final scale = 0.5 + (1 - adjustedProgress) * 0.5;

            return Positioned(
              left: MediaQuery.of(context).size.width * x,
              top: MediaQuery.of(context).size.height * y,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Text(
                    '❤️',
                    style: TextStyle(fontSize: particle.size),
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

class HeartParticle {
  final double startX;
  final double startY;
  final double endY;
  final double size;
  final double wobble;
  final double delay;
  final Color color;

  HeartParticle({
    required this.startX,
    required this.startY,
    required this.endY,
    required this.size,
    required this.wobble,
    required this.delay,
    required this.color,
  });
}

// Alternative version with different heart types
class MultiColorHeartsParticles extends StatelessWidget {
  const MultiColorHeartsParticles({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeartsParticles(
      heartCount: 10,
      color: Colors.pink,
    );
  }
}

// Sparkles for when stats are full
class SparklesParticles extends StatefulWidget {
  final Color color;

  const SparklesParticles({super.key, this.color = Colors.amber});

  @override
  State<SparklesParticles> createState() => _SparklesParticlesState();
}

class _SparklesParticlesState extends State<SparklesParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
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
        return Stack(
          children: List.generate(5, (index) {
            final progress = (_controller.value + index * 0.2) % 1;
            return Positioned(
              left: 50 + cos(index * 72 * pi / 180) * 30,
              top: 50 + sin(index * 72 * pi / 180) * 30,
              child: Opacity(
                opacity: (1 - progress).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.5 + progress * 0.5,
                  child: const Text('✨', style: TextStyle(fontSize: 20)),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}