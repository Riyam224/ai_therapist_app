import 'package:ai_therapist_app/core/constants/app_sizes.dart';
import 'package:ai_therapist_app/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmojiEntryMood extends StatelessWidget {
  final String emojiAsset;
  final VoidCallback? onTap;
  final bool isSelected;
  /// Tint color for the SVG icon and selected-state ring/background.
  /// Defaults to [AppColors.primary] when not provided.
  final Color? moodColor;

  const EmojiEntryMood({
    super.key,
    required this.emojiAsset,
    this.onTap,
    this.isSelected = false,
    this.moodColor,
  });

  bool get _isSvg => emojiAsset.endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final color = moodColor ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: AppSizes.emojiButtonSize,
        height: AppSizes.emojiButtonSize,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusCircle),
          border: isSelected
              ? Border.all(color: color, width: 2.w)
              : null,
        ),
        child: Center(
          child: _isSvg
              ? SvgPicture.asset(
                  emojiAsset,
                  width: AppSizes.iconLg,
                  height: AppSizes.iconLg,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    isSelected ? color : color.withValues(alpha: 0.75),
                    BlendMode.srcIn,
                  ),
                )
              : Image.asset(
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
