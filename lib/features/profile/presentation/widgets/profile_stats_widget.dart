import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/app_fonts.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/styling/theme_extensions.dart';

/// Row of 3 stat cards: total entries, this week, day streak
class ProfileStatsWidget extends StatelessWidget {
  final int totalEntries;
  final int thisWeek;
  final int dayStreak;

  const ProfileStatsWidget({
    super.key,
    required this.totalEntries,
    required this.thisWeek,
    required this.dayStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          value: '$totalEntries',
          label: 'Total entries',
        ),
        SizedBox(width: 10.w),
        _StatCard(
          value: '$thisWeek',
          label: 'This week',
        ),
        SizedBox(width: 10.w),
        // Emoji separated into its own span so it bypasses the Urbanist font
        // and renders with the system emoji font (Apple Color Emoji / Noto)
        _StatCard(
          value: '$dayStreak',
          label: 'Day streak',
          emoji: '🔥',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String? emoji;

  const _StatCard({
    required this.value,
    required this.label,
    this.emoji,
  });

  static const _emojiFallback = [
    'Apple Color Emoji',
    'Noto Color Emoji',
    'Segoe UI Emoji',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: context.extra.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontFamily: AppFonts.mainFontName,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (emoji != null)
                    TextSpan(
                      text: ' $emoji',
                      style: TextStyle(
                        fontFamilyFallback: _emojiFallback,
                        fontSize: 18.sp,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Text(label, style: ThemeTextStyles.captionSmall(context)),
          ],
        ),
      ),
    );
  }
}
