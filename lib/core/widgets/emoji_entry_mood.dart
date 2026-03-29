import 'package:ai_therapist_app/core/constants/app_sizes.dart';
import 'package:ai_therapist_app/core/styling/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiEntryMood extends StatelessWidget {
  final String emojiAsset;
  final VoidCallback? onTap;
  final bool isSelected;

  const EmojiEntryMood({
    super.key,
    required this.emojiAsset,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final extraColors = context.extra;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.emojiButtonSize,
        height: AppSizes.emojiButtonSize,
        decoration: BoxDecoration(
          color: isSelected
              ? extraColors.primaryColor!.withValues(alpha: 0.3)
              : extraColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusCircle),
          border: isSelected
              ? Border.all(
                  color: extraColors.primaryColor!,
                  width: 2.w,
                )
              : null,
        ),
        child: Center(
          child: Image.asset(
            emojiAsset,
            width: AppSizes.iconLg,
            height: AppSizes.iconLg,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
