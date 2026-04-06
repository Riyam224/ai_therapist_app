// lib/features/breathing/presentation/screens/breathing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../widgets/breathing_circle.dart';

class BreathingScreen extends StatefulWidget {
  final String emoji;

  const BreathingScreen({super.key, required this.emoji});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  int _currentRound = 1;
  final int _totalRounds = 3;
  String _phase = 'Breathe in';
  String _subText = 'Take a deep breath for 4 seconds';
  Color _circleColor = AppColors.primary;
  bool _isRunning = false;
  bool _isFinished = false;

  static final _phases = [
    {
      'name': 'Breathe in',
      'seconds': 4,
      'color': AppColors.primary,
      'sub': 'Take a deep breath slowly',
    },
    {
      'name': 'Hold',
      'seconds': 7,
      'color': const Color(0xFF2D6A4F),
      'sub': 'Hold your breath gently',
    },
    {
      'name': 'Breathe out',
      'seconds': 8,
      'color': const Color(0xFF85B7EB),
      'sub': 'Release slowly and completely',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _startExercise() async {
    setState(() => _isRunning = true);

    for (int round = 1; round <= _totalRounds; round++) {
      if (!mounted) return;
      setState(() => _currentRound = round);

      for (final phase in _phases) {
        if (!mounted) return;

        HapticFeedback.lightImpact();

        setState(() {
          _phase = phase['name'] as String;
          _subText = phase['sub'] as String;
          _circleColor = phase['color'] as Color;
        });

        _controller.duration = Duration(seconds: phase['seconds'] as int);

        if (phase['name'] == 'Breathe in') {
          _controller.forward(from: 0);
        } else if (phase['name'] == 'Breathe out') {
          _controller.reverse(from: 1);
        }

        await Future.delayed(Duration(seconds: phase['seconds'] as int));
      }
    }

    if (!mounted) return;
    HapticFeedback.mediumImpact();
    setState(() => _isFinished = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.go('/affirmation', extra: widget.emoji);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Text(
                'Breathe with Luna 🌿',
                style: ThemeTextStyles.headlineSmall(context),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '4-7-8 breathing for instant calm',
                style: ThemeTextStyles.bodyMedium(context),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Center(
                    child: BreathingCircle(
                      scale: _scaleAnimation.value,
                      color: _circleColor,
                      phaseText: _phase,
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _phase,
                  key: ValueKey(_phase),
                  style: ThemeTextStyles.headlineSmall(context),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _subText,
                style: ThemeTextStyles.bodyMedium(context),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              if (_isRunning && !_isFinished)
                Text(
                  'Round $_currentRound of $_totalRounds',
                  style: ThemeTextStyles.bodySmall(context),
                  textAlign: TextAlign.center,
                ),

              if (_isFinished)
                Text(
                  'Well done! 🌸',
                  style: ThemeTextStyles.titleMedium(context).copyWith(
                    color: const Color(0xFF2D6A4F),
                  ),
                  textAlign: TextAlign.center,
                ),

              const Spacer(),

              if (!_isRunning && !_isFinished)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _startExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Start Exercise',
                          style: ThemeTextStyles.whiteButton(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          context.go('/affirmation', extra: widget.emoji),
                      child: Text(
                        'Skip',
                        style: ThemeTextStyles.bodyMedium(context),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
