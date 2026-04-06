// lib/features/breathing/presentation/widgets/breathing_circle.dart

import 'package:flutter/material.dart';

class BreathingCircle extends StatelessWidget {
  final double scale;
  final Color color;
  final String phaseText;

  const BreathingCircle({
    super.key,
    required this.scale,
    required this.color,
    required this.phaseText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFD4B0),
            ),
          ),
          // Inner animated circle
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 140 * scale,
            height: 140 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(
              child: Text(
                phaseText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
