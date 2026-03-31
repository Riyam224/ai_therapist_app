import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/models/mood_entry.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/widgets/mood_entry_card.dart';
import '../../../home/domain/entities/mood_entry_entity.dart';
import '../../../home/presentation/cubit/mood_cubit.dart';
import '../../../home/presentation/cubit/mood_state.dart';
import '../widgets/journal_header_widget.dart';
import '../widgets/journal_search_bar_widget.dart';
import '../widgets/journal_emoji_filter_widget.dart';

class JournalHistoryScreen extends StatelessWidget {
  const JournalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MoodCubit>()..getHistory(),
      child: const _JournalBody(),
    );
  }
}

class _JournalBody extends StatefulWidget {
  const _JournalBody();

  @override
  State<_JournalBody> createState() => _JournalBodyState();
}

class _JournalBodyState extends State<_JournalBody> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedEmoji;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  MoodEntry _entityToUiEntry(MoodEntryEntity e) {
    return MoodEntry(
      id: e.id,
      emoji: e.emoji,
      title: _titleFromThoughts(e.thoughts),
      preview: e.aiResponse,
      sideColor: _colorForEmoji(e.emoji),
      date: e.createdAt,
      isEmojiImage: false,
    );
  }

  String _titleFromThoughts(String thoughts) {
    final sentence = thoughts.split(RegExp(r'[.!?]')).first.trim();
    if (sentence.isEmpty) return thoughts;
    return sentence.length > 40 ? '${sentence.substring(0, 40)}…' : sentence;
  }

  Color _colorForEmoji(String emoji) {
    const map = {
      '😩': AppColors.primary,
      '😰': AppColors.moodAnxious,
      '😤': AppColors.moodSad,
      '😢': AppColors.moodCalm,
      '😔': AppColors.primary,
      '😊': AppColors.moodHappy,
      '😌': AppColors.lavender,
      '😃': AppColors.moodHappy,
      '🤩': AppColors.moodExcited,
      '🥰': AppColors.blushPink,
    };
    return map[emoji] ?? AppColors.moodNeutral;
  }

  List<MoodEntry> _filterAndMap(List<MoodEntryEntity> entities) {
    return entities
        .where((e) {
          final matchesSearch = _searchQuery.isEmpty ||
              e.thoughts.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.aiResponse.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesEmoji =
              _selectedEmoji == null || e.emoji == _selectedEmoji;
          return matchesSearch && matchesEmoji;
        })
        .map(_entityToUiEntry)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        final allEntities = state is MoodHistorySuccess
            ? state.entries
            : <MoodEntryEntity>[];
        final filtered = _filterAndMap(allEntities);

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
                child: JournalHeaderWidget(entryCount: allEntities.length),
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

            // ── Loading ──────────────────────────────────────
            if (state is MoodLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )

            // ── Error ────────────────────────────────────────
            else if (state is MoodError)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_outlined,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )

            // ── Empty ────────────────────────────────────────
            else if (filtered.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No entries found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )

            // ── Entries list ─────────────────────────────────
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
                    (context, index) {
                      final entry = filtered[index];
                      return Dismissible(
                        key: ValueKey(entry.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          context.read<MoodCubit>().deleteEntry(entry.id);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.spaceMd),
                          child: MoodEntryCard(
                            emoji: entry.emoji,
                            title: entry.title,
                            preview: entry.preview,
                            sideColor: entry.sideColor,
                            date: entry.date,
                            isEmojiImage: entry.isEmojiImage,
                            onTap: () {},
                          ),
                        ),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
