import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

/// AI response card with lavender background showing Luna's response
class AiResponseCardWidget extends StatelessWidget {
  final String response;

  const AiResponseCardWidget({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space2Xl),
      decoration: BoxDecoration(
        color: AppColors.lavender.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.lavender.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Label
          Text(
            'LUNA SAYS',
            style: ThemeTextStyles.labelSmall(context).copyWith(
              color: AppColors.lavender,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSpacing.spaceMd),

          // AI Response
          Text(
            response,
            style: ThemeTextStyles.bodyMedium(context),
          ),
        ],
      ),
    );
  }
}
