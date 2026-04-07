import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_text_styles.dart';
import 'package:ai_therapist_app/core/widgets/emoji_entry_mood.dart';

/// Horizontal list of mood emoji buttons with animated label
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSizes.emojiButtonSize,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              final emojiPath = emojis[index];
              return Padding(
                padding: EdgeInsets.only(right: AppSpacing.spaceLg),
                child: EmojiEntryMood(
                  emojiAsset: emojiPath,
                  isSelected: selectedEmoji == emojiPath,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onEmojiSelected(emojiPath);
                  },
                  moodColor: moodColors != null && index < moodColors!.length
                      ? moodColors![index]
                      : null,
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppSpacing.spaceMd),
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
