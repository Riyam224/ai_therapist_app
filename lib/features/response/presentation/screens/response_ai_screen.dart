import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/navigation/app_bottom_nav_bar.dart';
import '../widgets/luna_avatar_widget.dart';
import '../widgets/luna_info_widget.dart';
import '../widgets/user_mood_card_widget.dart';
import '../widgets/ai_response_card_widget.dart';
import '../widgets/mood_tags_row_widget.dart';
import '../widgets/action_buttons_widget.dart';
import '../widgets/after_feeling_selector_widget.dart';

class ResponseAiScreen extends StatelessWidget {
  final String? emojiImagePath;
  final String thoughts;
  final String aiResponse;
  final List<String> moodTags;

  const ResponseAiScreen({
    super.key,
    this.emojiImagePath,
    this.thoughts =
        'I feel very overwhelmed with everything lately and I don\'t know what to do',
    this.aiResponse =
        'It sounds like you\'re carrying a lot right now, and that feeling is completely valid. Overwhelm often comes when we take on more than we can hold alone. Try taking one small step at a time — you don\'t have to solve everything today. I\'m here with you 💜',
    this.moodTags = const ['Overwhelmed', 'Anxious', 'Need support'],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go(AppRoutes.home);
          if (index == 1) context.go(AppRoutes.journal);
          if (index == 2) context.go(AppRoutes.profile);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPaddingMd,
                vertical: AppSpacing.verticalPaddingSm,
              ),
              child: Row(
                children: [
                  // Circular back button
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cardBackground,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),

                  // Centered title
                  Expanded(
                    child: Text(
                      'Luna\'s Response',
                      style: ThemeTextStyles.headlineSmall(context),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Balance spacer
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            // ── Scrollable Body ──────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalPaddingLg,
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppSpacing.spaceLg),

                    // Luna Avatar
                    const LunaAvatarWidget(),
                    SizedBox(height: AppSpacing.spaceMd),

                    // Luna name + subtitle
                    const LunaInfoWidget(),
                    SizedBox(height: AppSpacing.sectionSpacingMd),

                    // Your Mood card
                    UserMoodCardWidget(
                      emoji: emojiImagePath ?? AppAssets.emojiOverwhelmed,
                      thoughts: thoughts,
                      isEmojiImage: true,
                    ),
                    SizedBox(height: AppSpacing.spaceLg),

                    // Luna Says card
                    AiResponseCardWidget(response: aiResponse),
                    SizedBox(height: AppSpacing.spaceLg),

                    // Mood tags
                    MoodTagsRowWidget(tags: moodTags),
                    SizedBox(height: AppSpacing.sectionSpacingMd),

                    // Action buttons
                    ActionButtonsWidget(
                      onSave: () => context.go(AppRoutes.journal),
                      onTalkAgain: () => context.go(AppRoutes.home),
                    ),
                    SizedBox(height: AppSpacing.spaceLg),

                    // After feeling selector
                    const AfterFeelingSelectorWidget(),
                    SizedBox(height: AppSpacing.sectionSpacingMd),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
