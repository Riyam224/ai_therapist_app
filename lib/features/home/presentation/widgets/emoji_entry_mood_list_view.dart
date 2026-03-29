import 'package:ai_therapist_app/core/constants/app_sizes.dart';
import 'package:ai_therapist_app/core/constants/app_spacing.dart';
import 'package:ai_therapist_app/core/styling/app_assets.dart';
import 'package:ai_therapist_app/core/widgets/emoji_entry_mood.dart';
import 'package:flutter/material.dart';

class EmojiEntryMoodListView extends StatefulWidget {
  const EmojiEntryMoodListView({super.key});

  @override
  State<EmojiEntryMoodListView> createState() => _EmojiEntryMoodListViewState();
}

class _EmojiEntryMoodListViewState extends State<EmojiEntryMoodListView> {
  int? _selectedMoodIndex;

  // List of available mood emojis
  static const List<String> _moodEmojis = [
    AppAssets.moodAmazing,
    AppAssets.moodGood,
    AppAssets.moodOkay,
    AppAssets.moodBad,
    AppAssets.moodAwful,
    AppAssets.emojiAngry,
    AppAssets.emojiAnxious,
    AppAssets.emojiCalm,
    AppAssets.emojiExcited,
    AppAssets.emojiTired,
  ];

  void _onMoodSelected(int index) {
    setState(() {
      _selectedMoodIndex = _selectedMoodIndex == index ? null : index;
    });
    // TODO: Implement theme selection logic based on selected mood
    debugPrint('Selected mood at index: $index');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.emojiButtonSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _moodEmojis.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.spaceXl),
            child: EmojiEntryMood(
              emojiAsset: _moodEmojis[index],
              isSelected: _selectedMoodIndex == index,
              onTap: () => _onMoodSelected(index),
            ),
          );
        },
      ),
    );
  }
}
