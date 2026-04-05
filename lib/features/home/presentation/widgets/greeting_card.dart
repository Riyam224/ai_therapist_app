import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../plant/domain/entities/plant_stage.dart';
import '../../../plant/presentation/cubit/plant_cubit.dart';
import '../../../plant/presentation/cubit/plant_state.dart';

/// Greeting card displaying personalized welcome message with dynamic plant animation.
class GreetingCard extends StatelessWidget {
  const GreetingCard({
    required this.userName,
    super.key,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantCubit, PlantState>(
      builder: (context, state) {
        final extra = context.extra;
        final onPrimary = extra.onPrimaryTextColor!;
        final primary = extra.primaryColor!;
        final stage = state is PlantLoaded ? state.stage : PlantStage.seed;
        final streak = state is PlantLoaded ? state.streakDays : 0;

        final dayLabel = streak == 1 ? 'day' : 'days';

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
                      'Hello, $userName',
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
                stage.lottiePath,
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
    );
  }
}
