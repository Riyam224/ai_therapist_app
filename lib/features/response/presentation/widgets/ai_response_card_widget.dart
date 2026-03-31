import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

/// Removes all emoji and non-text Unicode symbols from [text].
String _stripEmojis(String text) {
  return text
      .replaceAll(
        RegExp(
          r'[\u{1F000}-\u{1FFFF}]'
          r'|[\u{2600}-\u{27BF}]'
          r'|[\u{FE00}-\u{FEFF}]'
          r'|[\u{1F900}-\u{1F9FF}]'
          r'|[\u{E0000}-\u{E007F}]'
          r'|[\u2700-\u27BF]'
          r'|[\u2300-\u23FF]'
          r'|[\u2B00-\u2BFF]'
          r'|\u200D'
          r'|\uFE0F',
          unicode: true,
        ),
        '',
      )
      .replaceAll(RegExp(r'  +'), ' ')
      .trim();
}

/// AI response card with lavender background showing Luna's response
class AiResponseCardWidget extends StatelessWidget {
  final String response;

  const AiResponseCardWidget({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final responseStyle = ThemeTextStyles.bodyMedium(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space2Xl),
      decoration: BoxDecoration(
        color: AppColors.lavender.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.lavender.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Label
          Text(
            'LUNA SAYS',
            style: ThemeTextStyles.labelSmall(context).copyWith(
              color: AppColors.lavender,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSpacing.spaceMd),

          // AI Response — emojis stripped to avoid broken glyph rendering
          Text(
            _stripEmojis(response),
            style: responseStyle,
          ),
        ],
      ),
    );
  }
}
