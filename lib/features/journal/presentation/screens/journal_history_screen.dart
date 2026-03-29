import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/models/mood_entry.dart';
import 'package:ai_therapist_app/core/widgets/mood_entry_card.dart';
import '../widgets/journal_header_widget.dart';
import '../widgets/journal_search_bar_widget.dart';
import '../widgets/journal_emoji_filter_widget.dart';

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({super.key});

  @override
  State<JournalHistoryScreen> createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedEmoji;
  String _searchQuery = '';

  // Sample entries — replace with real API/Hive data later
  late final List<MoodEntry> _allEntries;

  @override
  void initState() {
    super.initState();
    _allEntries = _buildSampleEntries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MoodEntry> _buildSampleEntries() => [
        MoodEntry(
          emoji: AppAssets.emojiOverwhelmed,
          title: 'Overwhelmed with ever...',
          preview: 'It sounds like you\'re carrying a ...',
          sideColor: AppColors.primary,
          date: DateTime.now().subtract(const Duration(hours: 2)),
          isEmojiImage: true,
        ),
        MoodEntry(
          emoji: AppAssets.moodOkay,
          title: 'Feeling grateful for sma...',
          preview: 'That\'s beautiful! Gratitude is...',
          sideColor: AppColors.moodHappy,
          date: DateTime.now().subtract(const Duration(days: 1, hours: 3, minutes: 30)),
          isEmojiImage: true,
        ),
        MoodEntry(
          emoji: AppAssets.emojiAnxious,
          title: 'Anxious about my futur...',
          preview: 'Anxiety about the future is very...',
          sideColor: AppColors.moodAnxious,
          date: DateTime(2026, 3, 26, 23, 0),
          isEmojiImage: true,
        ),
        MoodEntry(
          emoji: AppAssets.emojiLonely,
          title: 'Feeling lonely and misu...',
          preview: 'Loneliness can feel very heavy...',
          sideColor: AppColors.moodCalm,
          date: DateTime(2026, 3, 25, 22, 0),
          isEmojiImage: true,
        ),
        MoodEntry(
          emoji: AppAssets.emojiCalm,
          title: 'Finally feeling at peace ...',
          preview: 'Peace is such a beautiful state...',
          sideColor: AppColors.moodSad,
          date: DateTime(2026, 3, 24, 9, 0),
          isEmojiImage: true,
        ),
        MoodEntry(
          emoji: AppAssets.emojiGrateful,
          title: 'Grateful for small moments',
          preview: 'Every small moment counts...',
          sideColor: AppColors.moodHappy,
          date: DateTime(2026, 3, 23, 18, 30),
          isEmojiImage: true,
        ),
        MoodEntry(
          emoji: AppAssets.emojiStressed,
          title: 'Stressed about work again',
          preview: 'Work pressure is getting to me...',
          sideColor: AppColors.moodAnxious,
          date: DateTime(2026, 3, 22, 20, 0),
          isEmojiImage: true,
        ),
      ];

  List<MoodEntry> get _filteredEntries {
    return _allEntries.where((entry) {
      final matchesSearch = _searchQuery.isEmpty ||
          entry.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.preview.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesEmoji =
          _selectedEmoji == null || entry.emoji == _selectedEmoji;

      return matchesSearch && matchesEmoji;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEntries;

    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            AppSpacing.topPaddingSafeArea,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.verticalPaddingMd,
          ),
          sliver: SliverToBoxAdapter(
            child: JournalHeaderWidget(entryCount: _allEntries.length),
          ),
        ),

        // ── Search bar ───────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingLg,
          ),
          sliver: SliverToBoxAdapter(
            child: JournalSearchBarWidget(
              controller: _searchController,
              onChanged: (query) => setState(() => _searchQuery = query),
            ),
          ),
        ),

        // ── Emoji filter row ─────────────────────────────
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingSm,
            AppSpacing.horizontalPaddingLg,
            AppSpacing.sectionSpacingSm,
          ),
          sliver: SliverToBoxAdapter(
            child: JournalEmojiFilterWidget(
              selectedEmoji: _selectedEmoji,
              onEmojiSelected: (emoji) =>
                  setState(() => _selectedEmoji = emoji),
            ),
          ),
        ),

        // ── Entries list ─────────────────────────────────
        if (filtered.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No entries found')),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.horizontalPaddingLg,
              0,
              AppSpacing.horizontalPaddingLg,
              AppSpacing.verticalPaddingLg,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.spaceMd),
                  child: MoodEntryCard(
                    emoji: filtered[index].emoji,
                    title: filtered[index].title,
                    preview: filtered[index].preview,
                    sideColor: filtered[index].sideColor,
                    date: filtered[index].date,
                    isEmojiImage: filtered[index].isEmojiImage,
                    onTap: () {},
                  ),
                ),
                childCount: filtered.length,
              ),
            ),
          ),
      ],
    );
  }
}
