# Home Screen Warmth Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the home screen feel warm and intimate by giving Luna a living contextual voice in the greeting card and replacing the SVG mood selector with large expressive unicode emoji tiles.

**Architecture:** Three widget files change — greeting_card.dart gets Luna message logic + gradient background, mood_selector_widget.dart becomes large emoji tile grid, mood_input_section.dart updates its emoji list and section label to match. No new files, no new Cubits, no route changes.

**Tech Stack:** Flutter, flutter_bloc, AppColors/AppExtraColors theme system, ThemeTextStyles

---

## Files Modified

| File | Change |
|---|---|
| `lib/features/home/presentation/widgets/greeting_card.dart` | Gradient card + contextual Luna message based on time/streak/entries |
| `lib/features/home/presentation/widgets/mood_selector_widget.dart` | Replace SVG horizontal scroll with large unicode emoji tile grid |
| `lib/features/home/presentation/widgets/mood_input_section.dart` | Switch emoji list to unicode, update section label to conversational text |

---

## Task 1: Luna Greeting Card — Gradient + Contextual Message

**Files:**
- Modify: `lib/features/home/presentation/widgets/greeting_card.dart`

The current card is a flat solid-color box. Replace it with:
- Gradient background (primary → primaryContainer direction top-left to bottom-right)
- Luna speaks in first person with a message that considers time of day, streak, and whether entries exist
- Remove the static `stage.label` subtitle — Luna's message replaces it
- Keep streak badge and Lottie animation

`GreetingCard` needs to know if there are any entries. Pass `hasEntries` as a bool from `HomeScreen` → `_HomeScreenBody` → `GreetingCard`. In `home_screen.dart`, derive `hasEntries` from state inside the `BlocBuilder`.

- [ ] **Step 1: Add `hasEntries` parameter to GreetingCard**

Replace the class signature and constructor in `greeting_card.dart`:

```dart
class GreetingCard extends StatefulWidget {
  const GreetingCard({
    required this.userName,
    required this.hasEntries,
    super.key,
  });

  final String userName;
  final bool hasEntries;

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}
```

- [ ] **Step 2: Add Luna message logic to `_GreetingCardState`**

Add this method to `_GreetingCardState` (replace `_timeBasedGreeting`):

```dart
String _lunaMessage(String name, int hour, int streak, bool hasEntries) {
  if (!hasEntries) {
    return 'Hey $name, I\'m Luna. I\'m here whenever you\'re ready to talk 🌱';
  }
  if (hour >= 5 && hour < 12) {
    if (streak > 0) return 'Good morning, $name! $streak-day streak — that\'s beautiful 🌸';
    return 'Good morning, $name ☀️ What\'s on your heart today?';
  }
  if (hour >= 12 && hour < 17) {
    return 'Hey $name 🌤️ How\'s your day going so far?';
  }
  if (hour >= 17 && hour < 21) {
    if (streak > 0) return 'Good evening, $name 🌙 $streak days strong — I\'m proud of you.';
    return 'Good evening, $name 🌙 I\'m here if you want to talk.';
  }
  return 'Hey $name ⭐ Still up? I\'m listening.';
}
```

Keep `_timeBasedLottiePath` — it stays the same.

- [ ] **Step 3: Replace the card `Container` decoration and content**

Replace the entire `return Container(...)` block inside `BlocBuilder` with:

```dart
final greeting = _lunaMessage(widget.userName, hour, streak, widget.hasEntries);

return Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: isDark
          ? [const Color(0xFF7C5CDB), const Color(0xFF3D2B8E)]
          : [AppColors.primary, AppColors.primaryContainer],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
    boxShadow: [
      BoxShadow(
        color: primary.withValues(alpha: 0.25),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: TextStyle(
                color: onPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.4,
                fontFamilyFallback: const ['Apple Color Emoji', 'Noto Color Emoji'],
              ),
            ),
            if (streak > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, color: onPrimary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${streak} day${streak == 1 ? '' : 's'} streak',
                      style: TextStyle(
                        color: onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      Lottie.asset(
        lottiePath,
        width: 110,
        height: 110,
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (_, __, ___) => const SizedBox(width: 110, height: 110),
      ),
    ],
  ),
);
```

You need `isDark` — add it at the top of the `BlocBuilder` builder:
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
```

- [ ] **Step 4: Pass `hasEntries` from `home_screen.dart`**

In `home_screen.dart`, inside the `BlocBuilder<MoodCubit, MoodState>` builder, add:

```dart
final hasEntries = state is MoodHistorySuccess && entries.isNotEmpty;
```

Then update the `GreetingCard` call in the sliver:

```dart
child: GreetingCard(userName: widget.userName, hasEntries: hasEntries),
```

- [ ] **Step 5: Hot restart and verify**

Run `flutter run` and check:
- Greeting card shows a gradient (peach→mint in light, purple in dark)
- Luna message is contextual (try different streak/entry states in your test account)
- Lottie still shows on the right
- Streak badge still shows when streak > 0

- [ ] **Step 6: Commit**

```bash
git add lib/features/home/presentation/widgets/greeting_card.dart \
        lib/features/home/presentation/screens/home_screen.dart
git commit -m "feat: Luna greeting card with contextual message and gradient"
```

---

## Task 2: Mood Selector — Large Unicode Emoji Tiles

**Files:**
- Modify: `lib/features/home/presentation/widgets/mood_selector_widget.dart`
- Modify: `lib/features/home/presentation/widgets/mood_input_section.dart`

Replace the horizontal SVG scroll with a row of 5 large tappable emoji tiles. Each tile is a rounded card with a big unicode emoji centered inside. Selected tile gets a colored background + border.

- [ ] **Step 1: Rewrite `MoodSelectorWidget` to accept unicode emojis and render tiles**

Replace the entire contents of `mood_selector_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../../../../core/styling/theme_text_styles.dart';

/// Large tappable unicode emoji mood tiles
class MoodSelectorWidget extends StatelessWidget {
  final List<String> emojis;         // unicode emoji strings e.g. ['😢', '😔', '😊', '😃', '🤩']
  final String? selectedEmoji;       // selected unicode emoji
  final ValueChanged<String> onEmojiSelected;
  final List<Color>? moodColors;
  final String? selectedLabel;

  const MoodSelectorWidget({
    super.key,
    required this.emojis,
    required this.selectedEmoji,
    required this.onEmojiSelected,
    this.moodColors,
    this.selectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.extra;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(emojis.length, (index) {
            final emoji = emojis[index];
            final isSelected = selectedEmoji == emoji;
            final moodColor = (moodColors != null && index < moodColors!.length)
                ? moodColors![index]
                : extra.primaryColor!;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < emojis.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onEmojiSelected(emoji);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: AppSizes.emojiButtonSize,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? moodColor.withValues(alpha: 0.15)
                          : extra.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      border: Border.all(
                        color: isSelected ? moodColor : (extra.borderColor ?? Colors.transparent),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: moodColor.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamilyFallback: ['Apple Color Emoji', 'Noto Color Emoji'],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: selectedLabel != null
              ? Text(
                  selectedLabel!,
                  key: ValueKey(selectedLabel),
                  style: ThemeTextStyles.labelMedium(context),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Check `AppSizes.borderRadiusMd` exists**

Open `lib/core/constants/app_sizes.dart` and verify `borderRadiusMd` is defined. If it's missing, add:

```dart
static const double borderRadiusMd = 14.0;
```

- [ ] **Step 3: Update `mood_input_section.dart` to use unicode emojis**

The old `_moodEmojis` was a list of SVG asset paths. Replace with unicode emoji strings and update all references.

In `_MoodInputSectionState`, replace:

```dart
// OLD — remove these
static const List<String> _moodEmojis = [
  AppAssets.moodAwful,
  AppAssets.moodMeh,
  AppAssets.moodOkay,
  AppAssets.moodGood,
  AppAssets.moodGreat,
];

static const Map<String, String> _emojiUnicodeMap = {
  AppAssets.moodAwful: '😢',
  AppAssets.moodMeh:   '😔',
  AppAssets.moodOkay:  '😊',
  AppAssets.moodGood:  '😃',
  AppAssets.moodGreat: '🤩',
};
```

With:

```dart
// NEW
static const List<String> _moodEmojis = ['😢', '😔', '😊', '😃', '🤩'];
```

Remove the `_emojiUnicodeMap` entirely — it's no longer needed.

- [ ] **Step 4: Update `_onTalkToLuna` to use emoji directly**

The old code did `_emojiUnicodeMap[_selectedEmojiPath]`. Now `_selectedEmojiPath` IS the unicode emoji. Replace:

```dart
// OLD
final emojiUnicode = _emojiUnicodeMap[_selectedEmojiPath] ?? '😊';
```

With:

```dart
final emojiUnicode = _selectedEmojiPath ?? '😊';
```

- [ ] **Step 5: Update section label to conversational text**

In `mood_input_section.dart` `build()`, replace:

```dart
Text('YOUR MOOD', style: ThemeTextStyles.labelLarge(context)),
```

With:

```dart
Text('How are you feeling today?', style: ThemeTextStyles.bodyMedium(context).copyWith(
  color: context.extra.secondaryTextColor,
  fontWeight: FontWeight.w600,
)),
```

- [ ] **Step 6: Remove unused `AppAssets` import if no longer needed**

Check if `AppAssets` is used anywhere else in `mood_input_section.dart`. If not, remove:

```dart
import '../../../../core/styling/app_assets.dart';
```

- [ ] **Step 7: Hot restart and verify**

- 5 large emoji tiles appear in a row, evenly spaced
- Tapping one highlights it with a colored border and soft background
- The mood label animates in below
- "Talk to Luna" flow still works (routing to breathing or response screen)

- [ ] **Step 8: Commit**

```bash
git add lib/features/home/presentation/widgets/mood_selector_widget.dart \
        lib/features/home/presentation/widgets/mood_input_section.dart \
        lib/core/constants/app_sizes.dart
git commit -m "feat: replace SVG mood selector with large unicode emoji tiles"
```

---

## Self-Review

**Spec coverage:**
- ✅ Luna contextual message (time + streak + hasEntries) — Task 1
- ✅ Gradient greeting card — Task 1 Step 3
- ✅ Large tappable emoji tiles — Task 2 Step 1
- ✅ Colored highlight on selection — Task 2 Step 1
- ✅ Conversational section label — Task 2 Step 5

**Placeholder scan:** All steps have complete code. No TBDs.

**Type consistency:**
- `MoodSelectorWidget.emojis` is `List<String>` in both Task 2 Step 1 (widget) and Task 2 Step 3 (caller) ✅
- `selectedEmoji` is `String?` in both widget signature and `_selectedEmojiPath` in `mood_input_section.dart` ✅
- `hasEntries` is `bool` passed from home_screen.dart → GreetingCard ✅
