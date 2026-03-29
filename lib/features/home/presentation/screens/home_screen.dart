import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/models/mood_entry.dart';
import '../widgets/greeting_card.dart';
import '../widgets/home_header.dart';
import '../widgets/mood_input_section.dart';
import '../widgets/recent_entries_header.dart';
import '../widgets/recent_entries_list.dart';

/// Home screen - main entry point of the app
/// Displays greeting, mood selector, thoughts input, and recent entries
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _userName = "Riyam";

  @override
  Widget build(BuildContext context) {
    final sampleMoodEntries = _getSampleMoodEntries(context);

    return CustomScrollView(
      slivers: [
        // Header with avatar, title, and theme toggle
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            AppSpacing.topPaddingSafeArea,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.verticalPaddingLg,
          ),
          sliver: const SliverToBoxAdapter(
            child: HomeHeader(userName: _userName),
          ),
        ),

        // Greeting card
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingLg,
          ),
          sliver: const SliverToBoxAdapter(
            child: GreetingCard(userName: _userName),
          ),
        ),

        // Mood Input Section (combines mood selector and thoughts input)
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingSm,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingSm,
          ),
          sliver: const SliverToBoxAdapter(child: MoodInputSection()),
        ),

        // Recent entries header
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingSm,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingSm,
          ),
          sliver: const SliverToBoxAdapter(child: RecentEntriesHeader()),
        ),

        // Recent entries list
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            0,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.verticalPaddingLg,
          ),
          sliver: RecentEntriesList(entries: sampleMoodEntries),
        ),
      ],
    );
  }

  /// Sample mood entries - TODO: Replace with real data from API/local storage
  List<MoodEntry> _getSampleMoodEntries(BuildContext context) {
    final extraColors = context.extra;

    return [
      MoodEntry(
        emoji: AppAssets.moodOkay,
        title: "Happy Day",
        preview: "Had a great day at the park with friends!",
        sideColor: extraColors.moodHappy!,
        date: DateTime.now().subtract(const Duration(days: 0)),
        isEmojiImage: true,
      ),
      MoodEntry(
        emoji: AppAssets.emojiCalm,
        title: "Peaceful Evening",
        preview: "Relaxed with a good book and tea",
        sideColor: extraColors.moodCalm!,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isEmojiImage: true,
      ),
      MoodEntry(
        emoji: AppAssets.moodBad,
        title: "Feeling Down",
        preview: "Work was stressful today",
        sideColor: extraColors.moodSad!,
        date: DateTime.now().subtract(const Duration(days: 2)),
        isEmojiImage: true,
      ),
      MoodEntry(
        emoji: AppAssets.emojiExcited,
        title: "Excited",
        preview: "Got great news from family!",
        sideColor: extraColors.moodExcited!,
        date: DateTime.now().subtract(const Duration(days: 3)),
        isEmojiImage: true,
      ),
      MoodEntry(
        emoji: AppAssets.emojiAnxious,
        title: "Anxious",
        preview: "Big presentation tomorrow",
        sideColor: extraColors.moodAnxious!,
        date: DateTime.now().subtract(const Duration(days: 4)),
        isEmojiImage: true,
      ),
    ];
  }
}
