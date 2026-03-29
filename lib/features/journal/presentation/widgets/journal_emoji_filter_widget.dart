import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
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

  /// Unicode emojis matching what the app sends to and receives from the API
  static const List<String> _filterEmojis = [
    '😩', // Overwhelmed
    '😰', // Anxious
    '😤', // Stressed
    '😢', // Awful
    '😔', // Bad
    '😊', // Okay
    '😌', // Calm
    '😃', // Good
    '🤩', // Amazing
    '🥰', // Excited
  ];

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
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontFamilyFallback: const [
                        'Apple Color Emoji',
                        'Noto Color Emoji',
                        'Segoe UI Emoji',
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
