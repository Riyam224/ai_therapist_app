import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/navigation/app_bottom_nav_bar.dart';
import '../../../home/presentation/cubit/mood_cubit.dart';
import '../../../home/presentation/cubit/mood_state.dart';
import '../widgets/luna_avatar_widget.dart';
import '../widgets/luna_info_widget.dart';
import '../widgets/user_mood_card_widget.dart';
import '../widgets/ai_response_card_widget.dart';
import '../widgets/mood_tags_row_widget.dart';
import '../widgets/action_buttons_widget.dart';
import '../widgets/after_feeling_selector_widget.dart';

class ResponseAiScreen extends StatefulWidget {
  final String? emojiImagePath;
  final String? emojiUnicode;
  final String thoughts;

  const ResponseAiScreen({
    super.key,
    this.emojiImagePath,
    this.emojiUnicode,
    this.thoughts = '',
  });

  @override
  State<ResponseAiScreen> createState() => _ResponseAiScreenState();
}

class _ResponseAiScreenState extends State<ResponseAiScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.emojiUnicode != null && widget.thoughts.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<MoodCubit>().generateResponse(
            emoji: widget.emojiUnicode!,
            thoughts: widget.thoughts,
          );
        }
      });
    }
  }

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
            // ── App Bar ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPaddingMd,
                vertical: AppSpacing.verticalPaddingSm,
              ),
              child: Row(
                children: [
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
                      decoration: const BoxDecoration(
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
                  Expanded(
                    child: Text(
                      'Luna\'s Response',
                      style: ThemeTextStyles.headlineSmall(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────
            Expanded(
              child: BlocBuilder<MoodCubit, MoodState>(
                builder: (context, state) {
                  if (state is MoodLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MoodError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.horizontalPaddingLg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.errorColor,
                              size: 48,
                            ),
                            SizedBox(height: AppSpacing.spaceMd),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: ThemeTextStyles.bodyMedium(context),
                            ),
                            SizedBox(height: AppSpacing.spaceLg),
                            ElevatedButton(
                              onPressed: () {
                                if (widget.emojiUnicode != null) {
                                  context.read<MoodCubit>().generateResponse(
                                    emoji: widget.emojiUnicode!,
                                    thoughts: widget.thoughts,
                                  );
                                }
                              },
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Success or initial (show content)
                  final aiResponse = state is MoodGenerateSuccess
                      ? state.entry.aiResponse
                      : '';
                  final displayThoughts = state is MoodGenerateSuccess
                      ? state.entry.thoughts
                      : widget.thoughts;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.horizontalPaddingLg,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: AppSpacing.spaceLg),
                        const LunaAvatarWidget(),
                        SizedBox(height: AppSpacing.spaceMd),
                        const LunaInfoWidget(),
                        SizedBox(height: AppSpacing.sectionSpacingMd),
                        UserMoodCardWidget(
                          emoji: widget.emojiImagePath ?? AppAssets.emojiOverwhelmed,
                          thoughts: displayThoughts,
                          isEmojiImage: true,
                        ),
                        SizedBox(height: AppSpacing.spaceLg),
                        if (aiResponse.isNotEmpty) ...[
                          AiResponseCardWidget(response: aiResponse),
                          SizedBox(height: AppSpacing.spaceLg),
                          const MoodTagsRowWidget(
                            tags: ['Expressing', 'Reflecting', 'Growing'],
                          ),
                          SizedBox(height: AppSpacing.sectionSpacingMd),
                          ActionButtonsWidget(
                            onSave: () => context.go(AppRoutes.journal),
                            onTalkAgain: () => context.go(AppRoutes.home),
                          ),
                          SizedBox(height: AppSpacing.spaceLg),
                          const AfterFeelingSelectorWidget(),
                          SizedBox(height: AppSpacing.sectionSpacingMd),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
