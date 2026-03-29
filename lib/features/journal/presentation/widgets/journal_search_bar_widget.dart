import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/theme_text_styles.dart';

/// Search bar for filtering journal entries
class JournalSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const JournalSearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: ThemeTextStyles.bodyMedium(context),
        decoration: InputDecoration(
          hintText: 'Search entries...',
          hintStyle: ThemeTextStyles.bodySmall(context),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.secondaryTextColor,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}
