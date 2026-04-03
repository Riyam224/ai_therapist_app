import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';

/// Thoughts input field with submit button
class ThoughtsInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const ThoughtsInputWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final extraColors = context.extra;

    return Column(
      children: [
        // Thoughts Input Field
        TextField(
          controller: controller,
          maxLines: 5,
          maxLength: 500,
          style: ThemeTextStyles.bodyMedium(context),
          decoration: InputDecoration(
            filled: true,
            fillColor: extraColors.cardBackgroundColor,
            hintText: 'What\'s on your mind today...',
            hintStyle: ThemeTextStyles.bodySmall(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: extraColors.primaryColor!,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: extraColors.primaryColor!,
                width: 2.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: extraColors.borderColor!,
                width: 1.w,
              ),
            ),
            contentPadding: EdgeInsets.all(AppSpacing.horizontalPaddingMd),
          ),
        ),
        SizedBox(height: AppSpacing.spaceLg),

        // Talk to Luna Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: extraColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPaddingXl,
                vertical: AppSpacing.verticalPaddingLg,
              ),
              elevation: 0,
            ),
            child: Text(
              'Talk to Luna',
              style: ThemeTextStyles.whiteButton(context),
            ),
          ),
        ),
      ],
    );
  }
}
