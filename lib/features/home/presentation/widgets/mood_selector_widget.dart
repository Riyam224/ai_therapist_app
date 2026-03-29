import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import 'package:ai_therapist_app/core/widgets/emoji_entry_mood.dart';

/// Horizontal list of mood emoji buttons
class MoodSelectorWidget extends StatelessWidget {
  final List<String> emojis;
  final String? selectedEmoji;
  final ValueChanged<String> onEmojiSelected;

  const MoodSelectorWidget({
    super.key,
    required this.emojis,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              onTap: () => onEmojiSelected(emojiPath),
            ),
          );
        },
      ),
    );
  }
}
