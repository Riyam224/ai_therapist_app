# Breathing & Affirmation Screens Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Arabic-language placeholder screens with fully spec-compliant English breathing exercise (4-7-8) and affirmation card screens, wired into the home screen's low-mood trigger logic.

**Architecture:** Breathing and affirmation are stateful presentation-layer features with no backend calls. Affirmation data lives in a dedicated `lib/features/affirmation/data/` layer. Screens receive the selected emoji via GoRouter `extra` and chain: Home → BreathingScreen → AffirmationScreen → Home.

**Tech Stack:** Flutter, go_router (context.go/push), AnimationController + CurvedAnimation, HapticFeedback, AppColors, AppSpacing, ThemeTextStyles.

---

## File Map

| Action | Path |
|--------|------|
| Rewrite | `lib/features/breathing/presentation/screens/breathing_screen.dart` |
| Rewrite | `lib/features/breathing/presentation/widgets/breathing_circle.dart` |
| Create  | `lib/features/affirmation/data/affirmations_data.dart` |
| Create  | `lib/features/affirmation/presentation/screens/affirmation_screen.dart` |
| Modify  | `lib/core/routing/router_generation_config.dart` |
| Modify  | `lib/features/home/presentation/widgets/mood_input_section.dart` |
| Delete  | `lib/features/breathing/presentation/widgets/affirmations_data.dart` *(old Arabic file)* |
| Delete  | `lib/features/breathing/presentation/screens/affirmation_screen.dart` *(old Arabic file)* |

---

## Task 1: Affirmation Data Layer

**Files:**
- Create: `lib/features/affirmation/data/affirmations_data.dart`

- [ ] **Step 1: Create the directory and data file**

```dart
// lib/features/affirmation/data/affirmations_data.dart

const Map<String, List<String>> affirmations = {
  '😔': [
    'You have overcome more than you know. This hard day is proof of your strength, not your weakness.',
    'Difficult feelings are temporary. You are not your mood today — you are so much bigger than that.',
    'Even the most beautiful trees go through winter. Your spring is coming soon 🌸',
    'Real courage is waking up and trying again despite everything.',
  ],
  '😢': [
    'Crying is not weakness — it is the courage to feel deeply.',
    'Your tears wash away the pain. Lightness and peace follow.',
    'Allow yourself to grieve. Then allow yourself to heal.',
    'Every pain you go through teaches you something about your inner strength.',
  ],
  '😰': [
    'Anxiety is lying to you. The truth is you are stronger than you imagine.',
    'Take a breath. Just this moment — and it is completely safe.',
    'You do not have to solve everything right now. One small step is enough.',
    'Your mind is trying to protect you. Tell it you are safe right now.',
  ],
  '😩': [
    'Exhaustion is proof that you have been trying hard. Rest without guilt.',
    'It is okay to take your time. Healing has no deadlines.',
    'Your body is asking you for rest. Give it what it needs — you deserve it.',
    'Rest is not laziness — it is an essential part of strength.',
  ],
  '😭': [
    'Sometimes we need to fall apart to rebuild ourselves stronger.',
    'Your pain is real and your feelings are valid. You are not overreacting.',
    'You are not alone in this. Luna is always here with you 💙',
    'After the fiercest storms come the most beautiful seasons of life.',
  ],
  '😑': [
    'Feeling empty sometimes is a recharging period. Do not fight it.',
    'You do not have to feel anything specific right now. Numbness is valid too.',
    'Sometimes inner stillness is the most beautiful thing you can feel.',
  ],
  '🙁': [
    'A hard day does not mean a hard life. This will pass.',
    'Tell Luna what is bothering you — writing lightens the weight.',
    'You deserve to be okay. Always.',
  ],
};

const List<String> defaultAffirmations = [
  'You deserve every good thing. Always and forever 🌸',
  'Every new day is a new chance to begin again.',
  'Luna is proud of you for being here and trying.',
];
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/affirmation/data/affirmations_data.dart
git commit -m "feat: add English affirmation data layer"
```

---

## Task 2: BreathingCircle Widget

**Files:**
- Rewrite: `lib/features/breathing/presentation/widgets/breathing_circle.dart`

- [ ] **Step 1: Write the widget**

```dart
// lib/features/breathing/presentation/widgets/breathing_circle.dart

import 'package:flutter/material.dart';

class BreathingCircle extends StatelessWidget {
  final double scale;
  final Color color;
  final String phaseText;

  const BreathingCircle({
    super.key,
    required this.scale,
    required this.color,
    required this.phaseText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFD4B0),
            ),
          ),
          // Inner animated circle
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 140 * scale,
            height: 140 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(
              child: Text(
                phaseText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/breathing/presentation/widgets/breathing_circle.dart
git commit -m "feat: implement BreathingCircle widget"
```

---

## Task 3: BreathingScreen — Full English Rewrite

**Files:**
- Rewrite: `lib/features/breathing/presentation/screens/breathing_screen.dart`

Key differences from the old file:
- Add `required this.emoji` constructor parameter
- All text in English
- Use `AppColors` constants instead of hardcoded hex
- Add `_isFinished` state and "Well done! 🌸" completion message
- Pass emoji to `/affirmation` route via `extra`
- Add AnimatedSwitcher around the phase text
- Add round counter shown only while running
- Show Skip button that passes emoji too
- Use `BreathingCircle` widget

- [ ] **Step 1: Rewrite breathing_screen.dart**

```dart
// lib/features/breathing/presentation/screens/breathing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/styling/app_colors.dart';
import '../widgets/breathing_circle.dart';

class BreathingScreen extends StatefulWidget {
  final String emoji;

  const BreathingScreen({super.key, required this.emoji});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  int _currentRound = 1;
  final int _totalRounds = 3;
  String _phase = 'Breathe in';
  String _subText = 'Take a deep breath for 4 seconds';
  Color _circleColor = AppColors.primary;
  bool _isRunning = false;
  bool _isFinished = false;

  static const _phases = [
    {
      'name': 'Breathe in',
      'seconds': 4,
      'color': AppColors.primary,           // breathInColor  0xFFE8621A
      'sub': 'Take a deep breath slowly',
    },
    {
      'name': 'Hold',
      'seconds': 7,
      'color': Color(0xFF2D6A4F),            // breathHoldColor / secondary
      'sub': 'Hold your breath gently',
    },
    {
      'name': 'Breathe out',
      'seconds': 8,
      'color': Color(0xFF85B7EB),            // breathOutColor
      'sub': 'Release slowly and completely',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _startExercise() async {
    setState(() => _isRunning = true);

    for (int round = 1; round <= _totalRounds; round++) {
      if (!mounted) return;
      setState(() => _currentRound = round);

      for (final phase in _phases) {
        if (!mounted) return;

        HapticFeedback.lightImpact();

        setState(() {
          _phase = phase['name'] as String;
          _subText = phase['sub'] as String;
          _circleColor = phase['color'] as Color;
        });

        _controller.duration = Duration(seconds: phase['seconds'] as int);

        if (phase['name'] == 'Breathe in') {
          _controller.forward(from: 0);
        } else if (phase['name'] == 'Breathe out') {
          _controller.reverse(from: 1);
        }

        await Future.delayed(Duration(seconds: phase['seconds'] as int));
      }
    }

    if (!mounted) return;
    HapticFeedback.mediumImpact();
    setState(() => _isFinished = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.go('/affirmation', extra: widget.emoji);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                'Breathe with Luna 🌿',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightOnBackground,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                '4-7-8 breathing for instant calm',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightSecondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Center(
                    child: BreathingCircle(
                      scale: _scaleAnimation.value,
                      color: _circleColor,
                      phaseText: _phase,
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _phase,
                  key: ValueKey(_phase),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightOnBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _subText,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.lightSecondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              if (_isRunning && !_isFinished)
                Text(
                  'Round $_currentRound of $_totalRounds',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightSecondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),

              if (_isFinished)
                const Text(
                  'Well done! 🌸',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D6A4F),
                  ),
                  textAlign: TextAlign.center,
                ),

              const Spacer(),

              if (!_isRunning && !_isFinished)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _startExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Start Exercise',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          context.go('/affirmation', extra: widget.emoji),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: AppColors.lightSecondaryText),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/breathing/presentation/screens/breathing_screen.dart
git commit -m "feat: rewrite BreathingScreen in English with emoji param and isFinished state"
```

---

## Task 4: AffirmationScreen — New File in Proper Location

**Files:**
- Create: `lib/features/affirmation/presentation/screens/affirmation_screen.dart`

- [ ] **Step 1: Create the screen file**

```dart
// lib/features/affirmation/presentation/screens/affirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/styling/app_colors.dart';
import '../../data/affirmations_data.dart';

class AffirmationScreen extends StatefulWidget {
  final String emoji;

  const AffirmationScreen({super.key, required this.emoji});

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  int _index = 0;

  List<String> get _cards =>
      affirmations[widget.emoji] ?? defaultAffirmations;

  String get _currentCard => _cards[_index];

  void _nextCard() {
    HapticFeedback.lightImpact();
    setState(() => _index = (_index + 1) % _cards.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                'A word from Luna 💙',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightOnBackground,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'A personalized card just for you',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightSecondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Container(
                  key: ValueKey(_index),
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('🌱', style: TextStyle(fontSize: 44)),
                      const SizedBox(height: 16),
                      Text(
                        '"$_currentCard"',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.lightOnBackground,
                          height: 1.7,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        '— Luna 🌿',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2D6A4F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '${_index + 1} / ${_cards.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightSecondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _nextCard,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                      color: AppColors.lightBorder,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Next card ↻',
                    style: TextStyle(color: AppColors.lightSecondaryText),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start journaling now 🌸',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/affirmation/presentation/screens/affirmation_screen.dart
git commit -m "feat: add AffirmationScreen with English content and AnimatedSwitcher"
```

---

## Task 5: Update Router

**Files:**
- Modify: `lib/core/routing/router_generation_config.dart`

Changes needed:
1. Update `/breathing` import to use new `BreathingScreen` (same file, but now requires `emoji` parameter)
2. Update `/affirmation` import to use the new `AffirmationScreen` from `lib/features/affirmation/presentation/screens/`
3. Fix `/breathing` route builder to extract emoji from `state.extra` and pass it to `BreathingScreen`

- [ ] **Step 1: Update router**

In `lib/core/routing/router_generation_config.dart`:

Replace the two old imports at the top:
```dart
import '../../features/breathing/presentation/screens/affirmation_screen.dart';
import '../../features/breathing/presentation/screens/breathing_screen.dart';
```

With:
```dart
import '../../features/breathing/presentation/screens/breathing_screen.dart';
import '../../features/affirmation/presentation/screens/affirmation_screen.dart';
```

Replace the two old routes at the bottom:
```dart
      GoRoute(
        path: '/breathing',
        builder: (context, state) => const BreathingScreen(),
      ),
      GoRoute(
        path: '/affirmation',
        builder: (context, state) {
          final emoji = state.extra as String? ?? '😔';
          return AffirmationScreen(emoji: emoji);
        },
      ),
```

With:
```dart
      GoRoute(
        name: AppRoutes.breathing,
        path: AppRoutes.breathing,
        builder: (context, state) {
          final emoji = state.extra as String? ?? '😔';
          return BreathingScreen(emoji: emoji);
        },
      ),
      GoRoute(
        name: AppRoutes.affirmation,
        path: AppRoutes.affirmation,
        builder: (context, state) {
          final emoji = state.extra as String? ?? '😔';
          return AffirmationScreen(emoji: emoji);
        },
      ),
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/routing/router_generation_config.dart
git commit -m "fix: update router to pass emoji extra to BreathingScreen and use new AffirmationScreen"
```

---

## Task 6: Low-Mood Trigger in MoodInputSection

**Files:**
- Modify: `lib/features/home/presentation/widgets/mood_input_section.dart`

The current `_onTalkToLuna()` always navigates to `/response`. Add low-mood detection: if the resolved unicode emoji is in the `lowMoods` list, go to `/breathing` with the emoji as `extra`.

- [ ] **Step 1: Update _onTalkToLuna() in mood_input_section.dart**

Add the `lowMoods` constant and routing branch inside `_MoodInputSectionState`:

Replace the existing `_onTalkToLuna` method:

```dart
  static const List<String> _lowMoods = [
    '😔', '😢', '😩', '😰', '😭', '😑', '🙁'
  ];

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

    final emojiUnicode = _emojiUnicodeMap[_selectedEmojiPath] ?? '😊';

    if (_lowMoods.contains(emojiUnicode)) {
      context.go('/breathing', extra: emojiUnicode);
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
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/home/presentation/widgets/mood_input_section.dart
git commit -m "feat: navigate to breathing screen for low-mood emoji selections"
```

---

## Task 7: Delete Old Arabic Files

**Files:**
- Delete: `lib/features/breathing/presentation/widgets/affirmations_data.dart`
- Delete: `lib/features/breathing/presentation/screens/affirmation_screen.dart`

- [ ] **Step 1: Delete stale files**

```bash
rm lib/features/breathing/presentation/widgets/affirmations_data.dart
rm lib/features/breathing/presentation/screens/affirmation_screen.dart
```

- [ ] **Step 2: Verify build still compiles**

```bash
flutter analyze --no-fatal-infos 2>&1 | head -40
```

Expected: no errors referencing the deleted files.

- [ ] **Step 3: Commit**

```bash
git add -u
git commit -m "chore: remove old Arabic breathing/affirmation placeholder files"
```

---

## Self-Review

### Spec Coverage Check

| Requirement | Task |
|-------------|------|
| English text throughout | Tasks 3, 4 |
| `emoji` param on BreathingScreen | Task 3 |
| `emoji` param on AffirmationScreen | Task 4 |
| 4-7-8 phases with correct durations (4/7/8s) | Task 3 |
| Phase colors: breathIn=primary, hold=0xFF2D6A4F, out=0xFF85B7EB | Task 3 |
| `_isFinished` + "Well done! 🌸" | Task 3 |
| HapticFeedback.lightImpact() per phase | Task 3 |
| HapticFeedback.mediumImpact() on completion | Task 3 |
| AnimatedSwitcher on phase text | Task 3 |
| AnimatedContainer 500ms on circle | Task 2 |
| Skip button passes emoji | Task 3 |
| Auto-navigate to /affirmation with emoji after finish | Task 3 |
| Affirmation data in correct location | Task 1 |
| English affirmation content for all 7 moods | Task 1 |
| defaultAffirmations fallback | Task 1 |
| AnimatedSwitcher on affirmation card | Task 4 |
| Page counter (_index + 1 / _cards.length) | Task 4 |
| HapticFeedback.lightImpact() on next card | Task 4 |
| "Start journaling now 🌸" → /home | Task 4 |
| AppColors used everywhere (no raw hex in widgets) | Tasks 3, 4 |
| Router passes emoji extra to both routes | Task 5 |
| Low-mood trigger logic on home | Task 6 |
| lowMoods = ['😔','😢','😩','😰','😭','😑','🙁'] | Task 6 |
| Old Arabic files removed | Task 7 |

### Placeholder Scan
No TBD, TODO, or missing code blocks found.

### Type Consistency
- `BreathingScreen(emoji: widget.emoji)` — `emoji` is `String` in constructor ✓
- `AffirmationScreen(emoji: emoji)` — `emoji` is `String` in constructor ✓  
- `affirmations[widget.emoji]` — Map key is `String`, emoji is `String` ✓
- `_phases` uses `Color` values — `phase['color'] as Color` cast is correct ✓
- `BreathingCircle(scale, color, phaseText)` — all params typed and used correctly ✓
