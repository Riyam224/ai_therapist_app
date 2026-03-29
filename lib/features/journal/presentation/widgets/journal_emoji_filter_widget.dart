import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/app_assets.dart';
import 'package:ai_therapist_app/core/widgets/emoji_entry_mood.dart';

/// Horizontal scrollable emoji filter row
class JournalEmojiFilterWidget extends StatelessWidget {
  final String? selectedEmoji;
  final ValueChanged<String?> onEmojiSelected;

  const JournalEmojiFilterWidget({
    super.key,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  static const List<String> _filterEmojis = [
    AppAssets.emojiOverwhelmed,
    AppAssets.moodAwful,
    AppAssets.emojiAnxious,
    AppAssets.moodOkay,
    AppAssets.emojiAngry,
    AppAssets.emojiGrateful,
    AppAssets.emojiCalm,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.sp,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterEmojis.length,
        itemBuilder: (context, index) {
          final emoji = _filterEmojis[index];
          final isSelected = selectedEmoji == emoji;

          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.spaceMd),
            child: EmojiEntryMood(
              emojiAsset: emoji,
              isSelected: isSelected,
              onTap: () => onEmojiSelected(isSelected ? null : emoji),
            ),
          );
        },
      ),
    );
  }
}
