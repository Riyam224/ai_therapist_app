import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/widgets/spacing_widgets.dart';

/// Header for recent mood entries with "See all" navigation
class RecentEntriesHeader extends StatelessWidget {
  const RecentEntriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final extraColors = context.extra;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('RECENT ENTRIES', style: ThemeTextStyles.labelLarge(context)),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to journal/history screen
            GoRouter.of(context).push('/journal');
          },
          child: Row(
            children: [
              Text(
                'See all',
                style: ThemeTextStyles.labelMedium(context).copyWith(
                  color: extraColors.primaryColor,
                ),
              ),
              WidthSpace(AppSpacing.spaceXs),
              Icon(
                Icons.arrow_forward,
                color: extraColors.primaryColor,
                size: AppSizes.iconSm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
