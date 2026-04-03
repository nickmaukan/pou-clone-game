// lib/presentation/widgets/water_droplets.dart
import 'dart:math';
import 'package:flutter/material.dart';

class WaterDroplets extends StatefulWidget {
  final bool isActive;
  final int dropletCount;
  final Color color;

  const WaterDroplets({
    super.key,
    this.isActive = true,
    this.dropletCount = 40,
    this.color = const Color(0xFF87CEEB),
  });

  @override
  State<WaterDroplets> createState() => _WaterDropletsState();
}

class _WaterDropletsState extends State<WaterDroplets>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<WaterDroplet> _droplets;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _generateDroplets();
  }

  void _generateDroplets() {
    _droplets = List.generate(widget.dropletCount, (index) {
      return WaterDroplet(
        x: _random.nextDouble(),
        startY: -_random.nextDouble() * 0.5,
        endY: 1.0 + _random.nextDouble() * 0.5,
        size: 5 + _random.nextDouble() * 10,
        speed: 0.3 + _random.nextDouble() * 0.7,
        delay: _random.nextDouble() * 0.5,
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
          children: _droplets.map((droplet) {
            final progress = ((_controller.value - droplet.delay) / (1 - droplet.delay))
                .clamp(0.0, 1.0);
            
            if (progress <= 0) return const SizedBox();

            final y = droplet.startY + (droplet.endY - droplet.startY) * progress;
            final opacity = 0.3 + (1 - progress) * 0.5;

            return Positioned(
              left: MediaQuery.of(context).size.width * droplet.x,
              top: MediaQuery.of(context).size.height * y,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: droplet.size,
                  height: droplet.size * 1.5,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(droplet.size / 2),
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

class WaterDroplet {
  final double x;
  final double startY;
  final double endY;
  final double size;
  final double speed;
  final double delay;

  WaterDroplet({
    required this.x,
    required this.startY,
    required this.endY,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

// Shower head visual component
class ShowerHead extends StatelessWidget {
  final double width;

  const ShowerHead({super.key, this.width = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}