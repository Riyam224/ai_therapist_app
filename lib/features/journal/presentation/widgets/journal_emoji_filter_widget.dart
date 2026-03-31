import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/styling/theme_extensions.dart';

/// Horizontal scrollable emoji filter row using unicode emojis (matching API data)
class JournalEmojiFilterWidget extends StatelessWidget {
  final String? selectedEmoji;
  final ValueChanged<String?> onEmojiSelected;

  const JournalEmojiFilterWidget({
    super.key,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  /// The 5 core moods backed by SVG assets (matching the API emoji set)
  static const List<String> _filterEmojis = [
    '😢', // Awful
    '😔', // Meh
    '😊', // Okay
    '😃', // Good
    '🤩', // Great
  ];

  Widget _buildEmojiImage(String emoji) {
    final assetPath = AppAssets.emojiAssetMap[emoji];
    if (assetPath == null) {
      return RichText(text: TextSpan(text: emoji, style: TextStyle(fontSize: 24.sp)));
    }
    if (assetPath.endsWith('.svg')) {
      final moodColor = AppAssets.moodSvgColors[assetPath];
      return SvgPicture.asset(
        assetPath,
        width: AppSizes.iconMd,
        height: AppSizes.iconMd,
        fit: BoxFit.contain,
        colorFilter: moodColor != null ? ColorFilter.mode(moodColor, BlendMode.srcIn) : null,
      );
    }
    return Image.asset(assetPath, width: AppSizes.iconMd, height: AppSizes.iconMd, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    final extraColors = context.extra;

    return SizedBox(
      height: AppSizes.emojiButtonSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterEmojis.length,
        itemBuilder: (context, index) {
          final emoji = _filterEmojis[index];
          final isSelected = selectedEmoji == emoji;

          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.spaceMd),
            child: GestureDetector(
              onTap: () => onEmojiSelected(isSelected ? null : emoji),
              child: Container(
                width: AppSizes.emojiButtonSize,
                height: AppSizes.emojiButtonSize,
                decoration: BoxDecoration(
                  color: isSelected
                      ? extraColors.primaryColor!.withValues(alpha: 0.3)
                      : extraColors.cardBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusCircle),
                  border: isSelected
                      ? Border.all(
                          color: extraColors.primaryColor!,
                          width: 2.w,
                        )
                      : null,
                ),
                child: Center(
                  child: _buildEmojiImage(emoji),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
