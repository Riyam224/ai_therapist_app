import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';

/// Large tappable unicode emoji mood tiles with animated selection highlight
class MoodSelectorWidget extends StatelessWidget {
  final List<String> emojis;
  final String? selectedEmoji;
  final ValueChanged<String> onEmojiSelected;
  final List<Color>? moodColors;
  final String? selectedLabel;

  const MoodSelectorWidget({
    super.key,
    required this.emojis,
    required this.selectedEmoji,
    required this.onEmojiSelected,
    this.moodColors,
    this.selectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.extra;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(emojis.length, (index) {
            final emoji = emojis[index];
            final isSelected = selectedEmoji == emoji;
            final moodColor =
                (moodColors != null && index < moodColors!.length)
                    ? moodColors![index]
                    : extra.primaryColor!;
            // In dark mode use the theme primary (purple) for border/glow
            // so the selection highlight matches the dark palette
            final highlightColor =
                isDark ? extra.primaryColor! : moodColor;

            return Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(right: index < emojis.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onEmojiSelected(emoji);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: AppSizes.emojiButtonSize * 1.4,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? highlightColor.withValues(alpha: 0.15)
                          : extra.cardBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusMd),
                      border: Border.all(
                        color: isSelected
                            ? highlightColor
                            : (extra.borderColor ?? Colors.transparent),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: highlightColor.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamilyFallback: [
                            'Apple Color Emoji',
                            'Noto Color Emoji',
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: selectedLabel != null
              ? Text(
                  selectedLabel!,
                  key: ValueKey(selectedLabel),
                  style: ThemeTextStyles.labelMedium(context),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}
