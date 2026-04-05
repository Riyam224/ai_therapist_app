import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/styling/app_colors.dart';
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
        final stage = state is PlantLoaded ? state.stage : PlantStage.seed;
        final streak = state is PlantLoaded ? state.streakDays : 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stage.label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .85),
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
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🔥 $streak day streak',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (streak == 0)
                      Text(
                        stage.streakMessage,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
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
