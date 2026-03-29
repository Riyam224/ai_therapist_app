import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/routing/app_routes.dart';
import 'mood_selector_widget.dart';
import 'thoughts_input_widget.dart';

/// Combined section for mood selection and thoughts input
/// Manages the state for both emoji selection and thoughts
class MoodInputSection extends StatefulWidget {
  const MoodInputSection({super.key});

  @override
  State<MoodInputSection> createState() => _MoodInputSectionState();
}

class _MoodInputSectionState extends State<MoodInputSection> {
  String? _selectedEmojiPath;
  final TextEditingController _thoughtsController = TextEditingController();

  // List of available mood emojis
  static const List<String> _moodEmojis = [
    AppAssets.emojiOverwhelmed,
    AppAssets.emojiAnxious,
    AppAssets.emojiStressed,
    AppAssets.moodAwful,
    AppAssets.moodBad,
    AppAssets.moodOkay,
    AppAssets.emojiCalm,
    AppAssets.moodGood,
    AppAssets.moodAmazing,
    AppAssets.emojiExcited,
  ];

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

  void _onEmojiSelected(String emojiPath) {
    setState(() {
      _selectedEmojiPath = emojiPath;
    });
  }

  void _onTalkToLuna() {
    final thoughts = _thoughtsController.text.trim();

    // Validate inputs
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

    // Navigate to response screen with selected data
    context.push(
      AppRoutes.response,
      extra: {
        'emojiPath': _selectedEmojiPath,
        'thoughts': thoughts,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mood Selector
        Text('YOUR MOOD', style: ThemeTextStyles.labelLarge(context)),
        SizedBox(height: AppSpacing.spaceLg),
        MoodSelectorWidget(
          emojis: _moodEmojis,
          selectedEmoji: _selectedEmojiPath,
          onEmojiSelected: _onEmojiSelected,
        ),
        SizedBox(height: AppSpacing.sectionSpacingMd),

        // Thoughts Input
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
