import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/models/mood_entry.dart';
import 'package:ai_therapist_app/core/widgets/mood_entry_card.dart';

/// List of recent mood entries
class RecentEntriesList extends StatelessWidget {
  const RecentEntriesList({
    required this.entries,
    super.key,
  });

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final entry = entries[index];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.spaceMd),
            child: MoodEntryCard(
              emoji: entry.emoji,
              title: entry.title,
              preview: entry.preview,
              sideColor: entry.sideColor,
              date: entry.date,
              isEmojiImage: entry.isEmojiImage,
              onTap: () {
                // TODO: Navigate to mood entry details
                debugPrint('Tapped on: ${entry.title}');
              },
            ),
          );
        },
        childCount: entries.length,
      ),
    );
  }
}
