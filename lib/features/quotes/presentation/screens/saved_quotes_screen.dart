import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../cubit/saved_quotes_cubit.dart';
import '../cubit/saved_quotes_state.dart';
import 'package:go_router/go_router.dart';

class SavedQuotesScreen extends StatelessWidget {
  const SavedQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.space3Xl),
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(AppRoutes.profile),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Text(
                      'Saved quotes',
                      style: ThemeTextStyles.headlineSmall(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              SizedBox(height: AppSpacing.sectionSpacingMd),
              Expanded(
                child: BlocBuilder<SavedQuotesCubit, SavedQuotesState>(
                  builder: (context, state) {
                    if (state is SavedQuotesLoading) {
                      return Center(
                        child: Text(
                          'Loading saved quotes...',
                          style: ThemeTextStyles.bodyMedium(context),
                        ),
                      );
                    }

                    if (state is SavedQuotesLoaded && state.quotes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('📌', style: TextStyle(fontSize: 40)),
                            SizedBox(height: AppSpacing.spaceSm),
                            Text(
                              'No saved quotes yet',
                              style: ThemeTextStyles.titleMedium(context),
                            ),
                            SizedBox(height: AppSpacing.spaceXs),
                            Text(
                              'Save Luna’s words to collect them here',
                              style: ThemeTextStyles.bodySmall(context).copyWith(
                                color: context.extra.secondaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is SavedQuotesLoaded) {
                      return ListView.builder(
                        itemCount: state.quotes.length,
                        itemBuilder: (context, index) {
                          final quote = state.quotes[index];
                          return Dismissible(
                            key: ValueKey(quote.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              return await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: const Text('Delete quote?'),
                                      content: const Text(
                                        'This will remove the saved quote.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            dialogContext,
                                          ).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            dialogContext,
                                          ).pop(true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                            },
                            onDismissed: (_) {
                              context
                                  .read<SavedQuotesCubit>()
                                  .deleteQuote(quote.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Quote deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () => context
                                        .read<SavedQuotesCubit>()
                                        .saveQuote(quote.text),
                                  ),
                                ),
                              );
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
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: AppSpacing.spaceMd),
                              padding: EdgeInsets.all(AppSpacing.spaceLg),
                              decoration: BoxDecoration(
                                color: context.extra.cardBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: context.extra.borderColor ??
                                      AppColors.lightBorder,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                '"${quote.text}"',
                                style: ThemeTextStyles.bodyMedium(context),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(height: AppSpacing.sectionSpacingLg),
            ],
          ),
        ),
      ),
    );
  }
}
