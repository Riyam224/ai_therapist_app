import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/app_fonts.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

/// User mood card with pink background showing emoji and thoughts
class UserMoodCardWidget extends StatelessWidget {
  final String emoji;
  final String thoughts;
  final bool isEmojiImage;

  const UserMoodCardWidget({
    super.key,
    required this.emoji,
    required this.thoughts,
    this.isEmojiImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space2Xl),
      decoration: BoxDecoration(
        color: AppColors.blushPink.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.blushPink.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Label
          Text(
            'YOUR MOOD',
            style: ThemeTextStyles.labelSmall(context).copyWith(
              color: AppColors.blushPink,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSpacing.spaceMd),

          // Emoji and Thoughts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji
              if (isEmojiImage)
                Image.asset(
                  emoji,
                  width: 32.w,
                  height: 32.h,
                )
              else
                Text(
                  emoji,
                  style: TextStyle(
                    fontFamily: AppFonts.mainFontName,
                    fontSize: 32.sp,
                  ),
                ),
              SizedBox(width: AppSpacing.spaceMd),

              // Thoughts
              Expanded(
                child: Text(
                  thoughts,
                  style: ThemeTextStyles.bodyMedium(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
