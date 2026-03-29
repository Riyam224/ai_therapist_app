import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/theme_text_styles.dart';

/// "My Journal" title + entry count badge
class JournalHeaderWidget extends StatelessWidget {
  final int entryCount;

  const JournalHeaderWidget({super.key, required this.entryCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('My Journal', style: ThemeTextStyles.headlineMedium(context)),

        // Entry count pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            '$entryCount entries',
            style: ThemeTextStyles.bodySmall(context).copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
