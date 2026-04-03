import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_stats_widget.dart';
import '../widgets/profile_settings_section_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'Riyam';
  static const String _subtitle = 'Joined March 2026 · MindEase member';

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            AppSpacing.topPaddingSafeArea,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.verticalPaddingMd,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Profile', style: ThemeTextStyles.headlineMedium(context)),

                // Settings gear icon
                Container(
                  width: AppSizes.avatarSm,
                  height: AppSizes.avatarSm,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.extra.cardBackgroundColor,
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: context.extra.secondaryTextColor,
                    size: AppSizes.iconSm,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Avatar + Name ────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingLg,
          ),
          sliver: const SliverToBoxAdapter(
            child: ProfileAvatarWidget(
              name: _name,
              subtitle: _subtitle,
            ),
          ),
        ),

        // ── Stats row ────────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingMd,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingMd,
          ),
          sliver: const SliverToBoxAdapter(
            child: ProfileStatsWidget(
              totalEntries: 27,
              thisWeek: 5,
              dayStreak: 3,
            ),
          ),
        ),

        // ── Settings section ─────────────────────────────
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            0,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingLg,
          ),
          sliver: const SliverToBoxAdapter(
            child: ProfileSettingsSectionWidget(),
          ),
        ),
      ],
    );
  }
}
