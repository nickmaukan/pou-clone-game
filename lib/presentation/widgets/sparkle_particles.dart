// lib/presentation/widgets/sparkle_particles.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SparkleParticles extends StatefulWidget {
  final Color color;
  final int count;

  const SparkleParticles({
    super.key,
    this.color = const Color(0xFFFFD700),
    this.count = 20,
  });

  @override
  State<SparkleParticles> createState() => _SparkleParticlesState();
}

class _SparkleParticlesState extends State<SparkleParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Sparkle> _sparkles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _generateSparkles();
  }

  void _generateSparkles() {
    _sparkles = List.generate(widget.count, (index) {
      return Sparkle(
        x: 0.2 + _random.nextDouble() * 0.6,
        y: 0.3 + _random.nextDouble() * 0.4,
        size: 15 + _random.nextDouble() * 25,
        delay: _random.nextDouble() * 0.3,
        duration: 1.0 + _random.nextDouble() * 0.5,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // "CLEAN!" text
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.5 + value * 0.5,
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('✨', style: TextStyle(fontSize: 30)),
                            SizedBox(width: 10),
                            Text(
                              '¡LIMPIO!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('✨', style: TextStyle(fontSize: 30)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Sparkle particles
            ..._sparkles.map((sparkle) {
              final adjustedProgress = ((_controller.value - sparkle.delay) / (1 - sparkle.delay))
                  .clamp(0.0, 1.0);

              if (adjustedProgress <= 0) return const SizedBox();

              final y = sparkle.y - (sparkle.y - sparkle.y + 0.3) * Curves.easeOut.transform(adjustedProgress);
              final opacity = (1 - adjustedProgress).clamp(0.0, 1.0);
              final scale = 0.5 + (1 - adjustedProgress) * 0.5;

              return Positioned(
                left: MediaQuery.of(context).size.width * sparkle.x,
                top: MediaQuery.of(context).size.height * y,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Transform.rotate(
                      angle: sparkle.rotationSpeed * adjustedProgress,
                      child: const Text(
                        '✨',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Star burst from center
            ...List.generate(8, (index) {
              final progress = _controller.value.clamp(0.0, 1.0);
              final angle = index * pi / 4;
              final distance = progress * 150;
              
              if (progress <= 0.2) return const SizedBox();
              
              return Positioned(
                left: MediaQuery.of(context).size.width / 2 + cos(angle) * distance - 15,
                top: MediaQuery.of(context).size.height / 2 + sin(angle) * distance - 15,
                child: Opacity(
                  opacity: (1 - progress).clamp(0.0, 1.0),
                  child: const Text('⭐', style: TextStyle(fontSize: 30)),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class Sparkle {
  final double x;
  final double y;
  final double size;
  final double delay;
  final double duration;
  final double rotationSpeed;

  Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.delay,
    required this.duration,
    required this.rotationSpeed,
  });
}

// Confetti for high scores
class ConfettiParticles extends StatefulWidget {
  const ConfettiParticles({super.key});

  @override
  State<ConfettiParticles> createState() => _ConfettiParticlesState();
}

class _ConfettiParticlesState extends State<ConfettiParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Confetti> _confetti;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _confetti = List.generate(30, (index) {
      return Confetti(
        x: _random.nextDouble(),
        startY: -0.1 - _random.nextDouble() * 0.2,
        endY: 1.0 + _random.nextDouble() * 0.2,
        size: 8 + _random.nextDouble() * 8,
        color: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
        ][_random.nextInt(6)],
        delay: _random.nextDouble() * 0.5,
        wobble: (_random.nextDouble() - 0.5) * 0.2,
        rotation: _random.nextDouble() * 2 * pi,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _confetti.map((c) {
            final adjustedProgress = ((_controller.value - c.delay) / (1 - c.delay))
                .clamp(0.0, 1.0);

            if (adjustedProgress <= 0) return const SizedBox();

            final y = c.startY + (c.endY - c.startY) * Curves.easeIn.transform(adjustedProgress);
            final x = c.x + c.wobble * sin(adjustedProgress * pi * 4);
            final rotation = c.rotation + adjustedProgress * 4 * pi;

            return Positioned(
              left: MediaQuery.of(context).size.width * x,
              top: MediaQuery.of(context).size.height * y,
              child: Opacity(
                opacity: (1 - adjustedProgress * 0.5).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: rotation,
                  child: Container(
                    width: c.size,
                    height: c.size * 0.6,
                    decoration: BoxDecoration(
                      color: c.color,
                      borderRadius: BorderRadius.circular(2),
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

class Confetti {
  final double x;
  final double startY;
  final double endY;
  final double size;
  final Color color;
  final double delay;
  final double wobble;
  final double rotation;

  Confetti({
    required this.x,
    required this.startY,
    required this.endY,
    required this.size,
    required this.color,
    required this.delay,
    required this.wobble,
    required this.rotation,
  });
}