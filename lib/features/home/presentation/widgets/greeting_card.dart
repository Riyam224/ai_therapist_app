import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../plant/domain/entities/plant_stage.dart';
import '../../../plant/presentation/cubit/plant_cubit.dart';
import '../../../plant/presentation/cubit/plant_state.dart';

/// Greeting card displaying personalized welcome message with dynamic plant animation.
class GreetingCard extends StatefulWidget {
  const GreetingCard({
    required this.userName,
    super.key,
  });

  final String userName;

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  PlantStage? _lastStage;

  String _timeBasedGreeting(String name, int hour) {
    if (hour >= 5 && hour < 12) return 'Good morning, $name ☀️';
    if (hour >= 12 && hour < 17) return 'Good afternoon, $name 🌤️';
    if (hour >= 17 && hour < 21) return 'Good evening, $name 🌙';
    return 'Good night, $name ⭐';
  }

  String _timeBasedLottiePath(int hour) {
    if (hour >= 5 && hour < 12) return 'assets/lottie/seed_soil.json';
    if (hour >= 12 && hour < 17) return 'assets/lottie/plant_sprout.json';
    if (hour >= 17 && hour < 21) return 'assets/lottie/plant.json';
    return 'assets/lottie/blooming.json';
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    return BlocListener<PlantCubit, PlantState>(
      listenWhen: (previous, current) {
        if (current is! PlantLoaded) return false;
        if (_lastStage == null) return true;
        return current.stage.index > _lastStage!.index;
      },
      listener: (context, state) {
        if (state is PlantLoaded && _lastStage != null) {
          HapticFeedback.heavyImpact();
        }
        if (state is PlantLoaded) {
          _lastStage = state.stage;
        }
      },
      child: BlocBuilder<PlantCubit, PlantState>(
        builder: (context, state) {
          final extra = context.extra;
          final onPrimary = extra.onPrimaryTextColor!;
          final primary = extra.primaryColor!;
          final stage = state is PlantLoaded ? state.stage : PlantStage.seed;
          final streak = state is PlantLoaded ? state.streakDays : 0;

          _lastStage ??= stage;

          final dayLabel = streak == 1 ? 'day' : 'days';

          final greeting = _timeBasedGreeting(widget.userName, hour);
          final lottiePath = _timeBasedLottiePath(hour);

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          color: onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stage.label,
                        style: TextStyle(
                          color: onPrimary.withValues(alpha: .85),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (streak > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: onPrimary.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.water_drop_rounded,
                                color: onPrimary,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.local_fire_department,
                                color: onPrimary,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$streak $dayLabel streak',
                                style: TextStyle(
                                  color: onPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (streak == 0)
                        Text(
                          stage.streakMessage,
                          style: TextStyle(
                            color: onPrimary.withValues(alpha: .7),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Lottie.asset(
                  lottiePath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                  repeat: true,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox(width: 110, height: 110),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
