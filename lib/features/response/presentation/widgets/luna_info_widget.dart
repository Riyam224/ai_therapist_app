import 'package:flutter/material.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

/// Luna information widget showing name and subtitle
class LunaInfoWidget extends StatelessWidget {
  const LunaInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Luna',
          style: ThemeTextStyles.titleLarge(context),
        ),
        SizedBox(height: AppSpacing.spaceXs),
        Text(
          'AI Therapist · Always here for you',
          style: ThemeTextStyles.bodySmall(context),
        ),
      ],
    );
  }
}
