import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import 'emoji_entry_mood_list_view.dart';

/// Browsable gallery of mood illustrations, separate from the mood log input
class MoodSelectorSection extends StatelessWidget {
  const MoodSelectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.homeMoodGalleryTitle,
          style: ThemeTextStyles.labelLarge(context),
        ),
        HeightSpace(AppSpacing.spaceLg),
        const EmojiEntryMoodListView(),
      ],
    );
  }
}
