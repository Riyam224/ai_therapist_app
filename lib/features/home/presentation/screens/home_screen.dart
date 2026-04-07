import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/models/mood_entry.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../plant/presentation/cubit/plant_cubit.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../cubit/mood_cubit.dart';
import '../cubit/mood_state.dart';
import '../cubit/weekly_letter_cubit.dart';
import '../widgets/greeting_card.dart';
import '../widgets/home_header.dart';
import '../widgets/mood_input_section.dart';
import '../widgets/recent_entries_header.dart';
import '../widgets/recent_entries_list.dart';
import '../widgets/weekly_letter_banner.dart';

/// Home screen — main entry point of the app
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _userName {
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String?;
    if (fullName != null && fullName.isNotEmpty) {
      return fullName.split(' ').first;
    }
    return user?.email?.split('@').first ?? 'Friend';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<PlantCubit>()..loadPlant(),
        ),
        BlocProvider.value(
          value: sl<MoodCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<WeeklyLetterCubit>()..load(),
        ),
      ],
      child: _HomeScreenBody(userName: _userName),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({required this.userName});

  final String userName;

  /// Maps a MoodEntryEntity (from API) to a MoodEntry (UI model)
  List<MoodEntry> _toUiEntries(
    BuildContext context,
    List<MoodEntryEntity> entities,
  ) {
    return entities.map((e) => _entityToUiEntry(context, e)).toList();
  }

  MoodEntry _entityToUiEntry(BuildContext context, MoodEntryEntity e) {
    return MoodEntry(
      id: e.id,
      emoji: e.emoji,
      title: _titleFromThoughts(e.thoughts),
      preview: e.thoughts,
      sideColor: _emojiColor(e.emoji),
      date: e.createdAt,
      isEmojiImage: false,
    );
  }

  /// Use the first sentence or first 40 chars of thoughts as the card title
  String _titleFromThoughts(String thoughts) {
    final sentence = thoughts.split(RegExp(r'[.!?]')).first.trim();
    if (sentence.isEmpty) return thoughts;
    return sentence.length > 40 ? '${sentence.substring(0, 40)}…' : sentence;
  }

  Color _emojiColor(String emoji) {
    const colors = {
      '😔': AppColors.primary,
      '😊': AppColors.moodHappy,
      '😃': AppColors.moodHappy,
      '😢': AppColors.moodCalm,
      '😭': AppColors.moodCalm,
      '😰': AppColors.moodAnxious,
      '😩': AppColors.moodAnxious,
      '😤': AppColors.moodSad,
      '😌': AppColors.lavender,
      '🥰': AppColors.blushPink,
      '🤩': AppColors.moodExcited,
      '😴': AppColors.lavender,
      '😡': AppColors.moodAnxious,
    };
    return colors[emoji] ?? AppColors.moodNeutral;
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete all entries?'),
        content: const Text(
            'This will permanently remove all journal entries from your device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<MoodCubit>().deleteAllEntries();
            },
            child:
                const Text('Delete all', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        final entries = switch (state) {
          MoodHistorySuccess(:final entries) => _toUiEntries(context, entries),
          _ => <MoodEntry>[],
        };

        return CustomScrollView(
          slivers: [
            // Header
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontalPaddingLg,
                AppSpacing.topPaddingSafeArea,
                AppSpacing.horizontalPaddingLg,
                AppSpacing.verticalPaddingLg,
              ),
              sliver: SliverToBoxAdapter(
                child: HomeHeader(userName: userName),
              ),
            ),

            // Greeting card
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPaddingLg,
              ),
              sliver: SliverToBoxAdapter(
                child: GreetingCard(userName: userName),
              ),
            ),

            // Weekly letter banner
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontalPaddingLg,
                AppSpacing.sectionSpacingSm,
                AppSpacing.horizontalPaddingLg,
                0,
              ),
              sliver: const SliverToBoxAdapter(child: WeeklyLetterBanner()),
            ),

            // Mood Input Section
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
              sliver: SliverToBoxAdapter(
                child: RecentEntriesHeader(
                  onDeleteAll:
                      entries.isEmpty ? null : () => _confirmDeleteAll(context),
                ),
              ),
            ),

            // Loading indicator
            if (state is MoodLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            // Error message
            if (state is MoodError)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalPaddingLg,
                    vertical: 16,
                  ),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.errorColor),
                  ),
                ),
              ),

            // Recent entries list
            if (entries.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.horizontalPaddingLg,
                  0,
                  AppSpacing.horizontalPaddingLg,
                  AppSpacing.verticalPaddingLg,
                ),
                sliver: RecentEntriesList(
                  entries: entries,
                  onDelete: (id) => context.read<MoodCubit>().deleteEntry(id),
                ),
              ),
          ],
        );
      },
    );
  }
}
