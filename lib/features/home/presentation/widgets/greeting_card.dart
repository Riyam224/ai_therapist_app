import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/utils/date_time_helper.dart';
import '../../../../core/widgets/spacing_widgets.dart';

/// Greeting card displaying personalized welcome message
class GreetingCard extends StatelessWidget {
  const GreetingCard({
    required this.userName,
    super.key,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    final greeting = DateTimeHelper.getGreeting();
    final formattedDate = DateTimeHelper.getFormattedDate();
    final extraColors = context.extra;

    return Container(
      width: double.infinity,
      height: AppSizes.greetingCardHeight,
      decoration: BoxDecoration(
        color: extraColors.primaryColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      ),
      padding: EdgeInsets.all(AppSpacing.horizontalPaddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$greeting, $userName 🌸',
            style: ThemeTextStyles.whiteHeadline(context),
          ),
          HeightSpace(AppSpacing.spaceMd),
          Text(
            'How are you feeling today?',
            style: ThemeTextStyles.whiteBody(context),
          ),
          HeightSpace(AppSpacing.spaceLg),
          Text(formattedDate, style: ThemeTextStyles.whiteCaption(context)),
        ],
      ),
    );
  }
}
