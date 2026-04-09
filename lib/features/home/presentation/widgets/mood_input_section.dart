import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/routing/app_routes.dart';
import '../cubit/mood_cubit.dart';
import 'mood_selector_widget.dart';
import 'thoughts_input_widget.dart';

/// Combined section for mood selection and thoughts input
class MoodInputSection extends StatefulWidget {
  const MoodInputSection({super.key});

  @override
  State<MoodInputSection> createState() => _MoodInputSectionState();
}

class _MoodInputSectionState extends State<MoodInputSection> {
  String? _selectedEmoji;
  final TextEditingController _thoughtsController = TextEditingController();

  static const List<String> _moodEmojis = ['😢', '😔', '😊', '😃', '🤩'];

  static const List<String> _moodLabels = [
    'Feeling awful',
    'Feeling meh',
    'Feeling okay',
    'Feeling good',
    'Amazing!',
  ];

  static const List<Color> _moodColors = [
    Color(0xFF2563EB), // Awful  — bold blue
    Color(0xFF525252), // Meh    — dark gray
    Color(0xFF16A34A), // Okay   — bold green
    Color(0xFFD97706), // Good   — bold amber
    Color(0xFF6D28D9), // Great  — bold purple
  ];

  static const List<String> _lowMoods = ['😢', '😔', '😩', '😰', '😭', '😑', '🙁'];

  String _thoughtsLabel(String? emoji) {
    switch (emoji) {
      case '😢':
        return 'What\'s weighing on you?';
      case '😔':
        return 'What\'s been on your mind?';
      case '😊':
        return 'What\'s going on today?';
      case '😃':
        return 'What\'s making you feel good?';
      case '🤩':
        return 'What\'s making you smile?';
      default:
        return 'Tell me what\'s going on...';
    }
  }

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

  void _onEmojiSelected(String emoji) {
    setState(() => _selectedEmoji = emoji);
  }

  void _onTalkToLuna() {
    final thoughts = _thoughtsController.text.trim();

    if (_selectedEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your mood first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (thoughts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please share your thoughts'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    final emojiUnicode = _selectedEmoji!;

    if (_lowMoods.contains(emojiUnicode)) {
      context.read<MoodCubit>().addLocalEntry(
        emoji: emojiUnicode,
        thoughts: thoughts,
      );
      context.go(AppRoutes.breathing, extra: emojiUnicode);
    } else {
      context.push(
        AppRoutes.response,
        extra: {
          'emojiPath': null,
          'emojiUnicode': emojiUnicode,
          'thoughts': thoughts,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final extra = context.extra;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling today?',
          style: ThemeTextStyles.bodyMedium(context).copyWith(
            color: extra.secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.spaceLg),
        MoodSelectorWidget(
          emojis: _moodEmojis,
          selectedEmoji: _selectedEmoji,
          onEmojiSelected: _onEmojiSelected,
          moodColors: _moodColors,
          selectedLabel: _selectedEmoji != null
              ? _moodLabels[_moodEmojis.indexOf(_selectedEmoji!)]
              : null,
        ),
        SizedBox(height: AppSpacing.sectionSpacingMd),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _thoughtsLabel(_selectedEmoji),
              key: ValueKey(_selectedEmoji),
              style: ThemeTextStyles.bodyMedium(context).copyWith(
                color: extra.secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.spaceLg),
        ThoughtsInputWidget(
          controller: _thoughtsController,
          onSubmit: _onTalkToLuna,
        ),
      ],
    );
  }
}
