// lib/presentation/widgets/bubbles_effect.dart
import 'dart:math';
import 'package:flutter/material.dart';

class BubblesEffect extends StatefulWidget {
  final bool isActive;
  final int bubbleCount;
  final Color baseColor;

  const BubblesEffect({
    super.key,
    this.isActive = true,
    this.bubbleCount = 25,
    this.baseColor = const Color(0xFF87CEEB),
  });

  @override
  State<BubblesEffect> createState() => _BubblesEffectState();
}

class _BubblesEffectState extends State<BubblesEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> _bubbles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _generateBubbles();
  }

  void _generateBubbles() {
    _bubbles = List.generate(widget.bubbleCount, (index) {
      return Bubble(
        x: 0.1 + _random.nextDouble() * 0.8,
        startY: 1.0 + _random.nextDouble() * 0.3,
        endY: -0.2 - _random.nextDouble() * 0.3,
        size: 10 + _random.nextDouble() * 20,
        speed: 0.5 + _random.nextDouble() * 0.5,
        delay: _random.nextDouble() * 0.6,
        wobble: (_random.nextDouble() - 0.5) * 0.1,
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
            final progress = ((_controller.value - bubble.delay) / (1 - bubble.delay))
                .clamp(0.0, 1.0);
            
            if (progress <= 0) return const SizedBox();

            final y = bubble.startY + (bubble.endY - bubble.startY) * progress;
            final x = bubble.x + bubble.wobble * sin(progress * pi * 4);
            final opacity = 0.5 + _random.nextDouble() * 0.3;
            final scale = 0.8 + (1 - progress) * 0.2;

            return Positioned(
              left: MediaQuery.of(context).size.width * x,
              top: MediaQuery.of(context).size.height * y,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: CustomPaint(
                    size: Size(bubble.size, bubble.size),
                    painter: BubblePainter(
                      color: widget.baseColor.withOpacity(0.6),
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

class Bubble {
  final double x;
  final double startY;
  final double endY;
  final double size;
  final double speed;
  final double delay;
  final double wobble;

  Bubble({
    required this.x,
    required this.startY,
    required this.endY,
    required this.size,
    required this.speed,
    required this.delay,
    required this.wobble,
  });
}

class BubblePainter extends CustomPainter {
  final Color color;

  BubblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw bubble
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    canvas.drawCircle(center, radius, paint);

    // Draw highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.2,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Bathtub with water
class BathtubWidget extends StatelessWidget {
  final bool hasWater;
  final bool hasBubbles;

  const BathtubWidget({
    super.key,
    this.hasWater = true,
    this.hasBubbles = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Stack(
        children: [
          // Tub body
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          
          // Water
          if (hasWater)
            Positioned(
              bottom: 10,
              left: 30,
              right: 30,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF87CEEB).withOpacity(0.7),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
              ),
            ),
          
          // Bubbles on water surface
          if (hasBubbles)
            const Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: BubblesEffect(bubbleCount: 15),
            ),
          
          // Tub feet (classic legs)
          Positioned(
            bottom: -10,
            left: 40,
            child: _buildLeg(),
          ),
          Positioned(
            bottom: -10,
            right: 40,
            child: _buildLeg(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeg() {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}