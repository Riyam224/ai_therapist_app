import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_stats_widget.dart';
import '../widgets/profile_settings_section_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String get _name {
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String?;
    if (fullName != null && fullName.isNotEmpty) return fullName;
    return user?.email?.split('@').first ?? 'Friend';
  }

  String get _subtitle {
    final user = Supabase.instance.client.auth.currentUser;
    if (user?.createdAt != null) {
      final joined = DateTime.parse(user!.createdAt);
      final month = DateFormat('MMMM yyyy').format(joined);
      return 'Joined $month · MindEase member';
    }
    return 'MindEase member';
  }

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
          sliver: SliverToBoxAdapter(
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

        // ── Logout button ─────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            0,
            AppSpacing.horizontalPaddingLg,
            100,
          ),
          sliver: SliverToBoxAdapter(
            child: TextButton.icon(
              onPressed: () => context.read<AuthCubit>().logout(),
              icon: const Icon(Icons.logout_rounded, color: AppColors.errorColor),
              label: Text(
                'Log out',
                style: ThemeTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.errorColor.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
