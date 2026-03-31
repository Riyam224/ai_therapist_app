import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/utils/date_time_helper.dart';
import '../../../../core/widgets/spacing_widgets.dart';

/// Greeting card displaying personalized welcome message with Luna animation.
class GreetingCard extends StatelessWidget {
  const GreetingCard({
    required this.userName,
    super.key,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    const greeting = 'Hello';
    final formattedDate = DateTimeHelper.getFormattedDate();
    final extraColors = context.extra;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: AppSizes.greetingCardHeight,
          decoration: BoxDecoration(
            color: extraColors.primaryColor,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          ),
          padding: EdgeInsets.all(AppSpacing.horizontalPaddingLg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Text column ────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$greeting, $userName ',
                            style: ThemeTextStyles.whiteHeadline(context),
                          ),
                          TextSpan(
                            text: '🌱',
                            style: TextStyle(
                              inherit: false,
                              fontSize:
                                  ThemeTextStyles.whiteHeadline(context).fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    HeightSpace(AppSpacing.spaceMd),
                    Text(
                      'What\'s growing in your mind today?',
                      style: ThemeTextStyles.whiteBody(context),
                    ),
                    HeightSpace(AppSpacing.spaceLg),
                    Text(
                      formattedDate,
                      style: ThemeTextStyles.whiteCaption(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 120),
            ],
          ),
        ),

        // ── Luna Lottie animation — floats above the card ─────────────────
        Positioned(
          right: 8,
          top: -28,
          child: Lottie.asset(
            'assets/lottie/plant.json',
            width: 148,
            height: 148,
            fit: BoxFit.contain,
            repeat: true,
            animate: true,
            errorBuilder: (_, __, ___) => const SizedBox(width: 80, height: 80),
          ),
        ),
      ],
    );
  }
}
