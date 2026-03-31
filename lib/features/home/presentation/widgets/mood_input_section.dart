import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/routing/app_routes.dart';
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

  // Per-emoji tint colors matching the OpenMoji outlined SVG style
  static const List<Color> _moodColors = [
    Color(0xFF6B8CBA), // Awful  — blue-slate
    Color(0xFF9E9E9E), // Meh    — gray
    Color(0xFF5E9E73), // Okay   — green
    Color(0xFFCF9B3A), // Good   — amber
    Color(0xFF7C6FCD), // Great  — soft purple
  ];

  /// Maps asset path → unicode emoji character sent to the API
  static const Map<String, String> _emojiUnicodeMap = {
    AppAssets.moodAwful: '😢',
    AppAssets.moodMeh:   '😔',
    AppAssets.moodOkay:  '😊',
    AppAssets.moodGood:  '😃',
    AppAssets.moodGreat: '🤩',
  };

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

    context.push(
      AppRoutes.response,
      extra: {
        'emojiPath': _selectedEmojiPath,
        'emojiUnicode': _emojiUnicodeMap[_selectedEmojiPath] ?? '😊',
        'thoughts': thoughts,
      },
    );
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
