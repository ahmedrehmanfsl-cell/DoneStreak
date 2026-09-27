import 'dart:math';
import 'package:flutter/material.dart';

/// A glowing orb whose size and warmth grow with the streak count.
/// This replaces a generic numeric badge with a distinct, ownable visual —
/// deliberately not a plain circular progress ring or a flame icon, both of
/// which are extremely common in habit-tracker apps.
class StreakOrb extends StatefulWidget {
  final int streak;
  final double size;

  const StreakOrb({super.key, required this.streak, this.size = 120});

  @override
  State<StreakOrb> createState() => _StreakOrbState();
}

class _StreakOrbState extends State<StreakOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
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
      builder: (context, _) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _OrbPainter(
            streak: widget.streak,
            t: _controller.value,
          ),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  final int streak;
  final double t; // 0..1 looping animation phase

  _OrbPainter({required this.streak, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius = size.width * 0.28;
    // Growth: orb gets a little bigger and warmer-colored with more streak days,
    // capped so it never overflows its box.
    final growth = min(streak / 30, 1.0);
    final radius = baseRadius + (size.width * 0.14 * growth);
    final pulse = sin(t * 2 * pi) * 2.0;

    final coreColor = Color.lerp(
      const Color(0xFFB08BFF), // cool violet at streak 0
      const Color(0xFFFFC15E), // warm amber at high streak
      growth,
    )!;

    // Outer soft glow, several translucent rings
    for (int i = 3; i >= 1; i--) {
      final glowPaint = Paint()
        ..color = coreColor.withValues(alpha: 0.10 / i)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18.0 * i);
      canvas.drawCircle(center, radius + (i * 10) + pulse, glowPaint);
    }

    // Core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, coreColor],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius + pulse * 0.4, corePaint);

    // Orbiting day-markers: one small dot per day of the current streak,
    // capped visually at 12 so the ring stays legible.
    final markerCount = min(streak, 12);
    for (int i = 0; i < markerCount; i++) {
      final angle = (2 * pi * i / max(markerCount, 1)) + (t * 2 * pi * 0.15);
      final markerRadius = radius + 22;
      final dx = center.dx + markerRadius * cos(angle);
      final dy = center.dy + markerRadius * sin(angle);
      final dotPaint = Paint()..color = coreColor.withValues(alpha: 0.85);
      canvas.drawCircle(Offset(dx, dy), 3.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.streak != streak;
}
