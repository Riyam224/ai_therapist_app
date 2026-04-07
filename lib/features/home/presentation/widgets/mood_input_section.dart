import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/styling/app_assets.dart';
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
  String? _selectedEmojiPath;
  final TextEditingController _thoughtsController = TextEditingController();

  // 5 illustrated SVG moods shown on the home screen selector
  static const List<String> _moodEmojis = [
    AppAssets.moodAwful,
    AppAssets.moodMeh,
    AppAssets.moodOkay,
    AppAssets.moodGood,
    AppAssets.moodGreat,
  ];

  static const List<String> _moodLabels = [
    'Feeling awful',
    'Feeling meh',
    'Feeling okay',
    'Feeling good',
    'Amazing!',
  ];

  // Per-emoji tint colors matching the OpenMoji outlined SVG style
  static const List<Color> _moodColors = [
    Color(0xFF2563EB), // Awful  — bold blue
    Color(0xFF525252), // Meh    — dark gray
    Color(0xFF16A34A), // Okay   — bold green
    Color(0xFFD97706), // Good   — bold amber
    Color(0xFF6D28D9), // Great  — bold purple
  ];

  /// Maps asset path → unicode emoji character sent to the API
  static const Map<String, String> _emojiUnicodeMap = {
    AppAssets.moodAwful: '😢',
    AppAssets.moodMeh:   '😔',
    AppAssets.moodOkay:  '😊',
    AppAssets.moodGood:  '😃',
    AppAssets.moodGreat: '🤩',
  };

  static const List<String> _lowMoods = [
    '😔',
    '😢',
    '😩',
    '😰',
    '😭',
    '😑',
    '🙁',
  ];

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

  void _onEmojiSelected(String emojiPath) {
    setState(() => _selectedEmojiPath = emojiPath);
  }

  void _onTalkToLuna() {
    final thoughts = _thoughtsController.text.trim();

    if (_selectedEmojiPath == null) {
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

    final emojiUnicode = _emojiUnicodeMap[_selectedEmojiPath] ?? '😊';

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
          'emojiPath': _selectedEmojiPath,
          'emojiUnicode': emojiUnicode,
          'thoughts': thoughts,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('YOUR MOOD', style: ThemeTextStyles.labelLarge(context)),
        SizedBox(height: AppSpacing.spaceLg),
        MoodSelectorWidget(
          emojis: _moodEmojis,
          selectedEmoji: _selectedEmojiPath,
          onEmojiSelected: _onEmojiSelected,
          moodColors: _moodColors,
          selectedLabel: _selectedEmojiPath != null
              ? _moodLabels[_moodEmojis.indexOf(_selectedEmojiPath!)]
              : null,
        ),
        SizedBox(height: AppSpacing.sectionSpacingMd),
        Text('SHARE YOUR THOUGHTS', style: ThemeTextStyles.labelLarge(context)),
        SizedBox(height: AppSpacing.spaceLg),
        ThoughtsInputWidget(
          controller: _thoughtsController,
          onSubmit: _onTalkToLuna,
        ),
      ],
    );
  }
}
