# Home Screen Conversational Redesign

**Date:** 2026-04-09  
**Goal:** Make the home screen feel warm and intimate — like talking to a close friend — by giving Luna a living voice and transforming the mood check-in into a natural conversation.

---

## 1. Luna Greeting Card

**Current:** Solid-color rectangle with a time-based greeting string and streak badge.

**New:** Gradient card with Luna speaking directly to the user.

### Visual
- Background: `LinearGradient` from `primaryColor` → `primaryContainer` (light) / `primaryDark` → a deeper purple (dark)
- Subtle inner glow border: `BoxDecoration` border with `primaryColor.withValues(alpha: 0.3)`
- Lottie animation stays on the right (time-based asset, unchanged)
- Streak badge stays but is embedded naturally in Luna's message text, not as a separate chip

### Luna Message Logic
Evaluate in order:

| Condition | Message |
|---|---|
| No entries yet | *"Hey [name], I'm Luna. I'm here whenever you're ready to talk 🌱"* |
| Morning (5–11) + streak > 0 | *"Good morning, [name]! You're on a [n]-day streak — that's beautiful 🌸"* |
| Morning (5–11) + streak == 0 | *"Good morning, [name] ☀️ What's on your heart today?"* |
| Afternoon (12–16) | *"Hey [name] 🌤️ How's your day going so far?"* |
| Evening (17–20) + streak > 0 | *"Good evening, [name] 🌙 [n] days strong — I'm proud of you."* |
| Evening (17–20) + streak == 0 | *"Good evening, [name] 🌙 I'm here if you want to talk."* |
| Night (21–4) | *"Hey [name] ⭐ Still up? I'm listening."* |

Message is a single `Text` widget using `ThemeTextStyles.headlineSmall(context)` in `onPrimaryTextColor`.

### Implementation Notes
- Message logic lives in `GreetingCard` (same file: [greeting_card.dart](lib/features/home/presentation/widgets/greeting_card.dart))
- `entryCount` is derived from `MoodCubit` state passed down — check `MoodHistorySuccess.entries.isEmpty`
- No new files needed

---

## 2. Mood Check-in Section

### 2a. Section Label
**Current:** `YOUR MOOD` — all-caps `labelLarge`  
**New:** `"How are you feeling today?"` — `ThemeTextStyles.bodyMedium(context)` in `secondaryTextColor`, sentence case, no caps

### 2b. Mood Selector Visual
- Each of the 5 mood SVG faces sits inside a **rounded pill container** (`BorderRadius.circular(16)`)
- Unselected: card background fill, subtle border
- Selected: fill with `moodColors[index].withValues(alpha: 0.15)`, border in `moodColors[index]`, soft box shadow `moodColors[index].withValues(alpha: 0.3)` blurRadius 8
- A **mood label** fades in below the row when a mood is selected, using `AnimatedSwitcher`. Text uses `ThemeTextStyles.labelSmall` in `secondaryTextColor`

Mood labels (unchanged): `'Feeling awful'`, `'Feeling meh'`, `'Feeling okay'`, `'Feeling good'`, `'Amazing!'`

### 2c. Thoughts Input Label
**Current:** `SHARE YOUR THOUGHTS` — static all-caps label  
**New:** Mood-sensitive label, sentence case:

| Selected mood | Label |
|---|---|
| Awful (`😢`) | `"What's weighing on you?"` |
| Meh (`😔`) | `"What's been on your mind?"` |
| Okay (`😊`) | `"What's going on today?"` |
| Good (`😃`) | `"What's making you feel good?"` |
| Great (`🤩`) | `"What's making you smile?"` |
| None selected | `"Tell me what's going on..."` |

Label animates with `AnimatedSwitcher` (fade, 200ms) when mood changes.

### 2d. Text Field Styling
**Current:** Standard `OutlineInputBorder` with a border that appears on focus  
**New:** Warm journal entry style:
- `filled: true`, `fillColor: cardBackgroundColor`
- `enabledBorder`: `OutlineInputBorder` with `borderSide: BorderSide.none` (no border at rest)
- `focusedBorder`: `OutlineInputBorder` with soft `primaryColor` border, width 1.5
- Add a **left accent bar**: wrap `TextField` in a `DecoratedBox` with `Border(left: BorderSide(color: selectedMoodColor ?? primaryColor, width: 3))` and `borderRadius: BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14))`
- Hint text changes to match the section label above

### 2e. Talk to Luna Button
- Add `boxShadow` to the `ElevatedButton` style via `shadowColor: primaryColor.withValues(alpha: 0.4)`, `elevation: 6`
- No other changes

---

## 3. Layout & Visual Rhythm

### Section Dividers
Between the greeting card, mood check-in, weekly letter banner, and recent entries — add a soft decorative divider:

```dart
Row(children: [
  Expanded(child: Divider(color: borderColor)),
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Text('✦', style: TextStyle(color: secondaryTextColor, fontSize: 10)),
  ),
  Expanded(child: Divider(color: borderColor)),
])
```

This replaces raw `SizedBox` spacing between major sections in `home_screen.dart`.

### Recent Entries Header
- Title changes from current label → `"Recent reflections"`
- The **Delete All** button is removed from the header row
- Instead: add a trailing `IconButton` with `Icons.more_horiz_rounded` that shows a `showModalBottomSheet` with a single "Delete all entries" destructive option
- This prevents the delete action from being visually prominent on the main screen

---

## 4. Files to Modify

| File | Change |
|---|---|
| [greeting_card.dart](lib/features/home/presentation/widgets/greeting_card.dart) | Gradient card, Luna message logic |
| [mood_input_section.dart](lib/features/home/presentation/widgets/mood_input_section.dart) | Conversational label, mood-sensitive thoughts label |
| [mood_selector_widget.dart](lib/features/home/presentation/widgets/mood_selector_widget.dart) | Pill container, color highlight, glow on selection |
| [thoughts_input_widget.dart](lib/features/home/presentation/widgets/thoughts_input_widget.dart) | Journal style, left accent bar, hint text prop |
| [recent_entries_header.dart](lib/features/home/presentation/widgets/recent_entries_header.dart) | Rename label, move delete to bottom sheet |
| [home_screen.dart](lib/features/home/presentation/screens/home_screen.dart) | Add section dividers between slivers |

No new files. No new routes. No new Cubits. No backend changes.

---

## 5. Out of Scope

- Weekly letter banner — already polished, no changes
- Journal, Profile, Response screens — not touched
- Navigation structure — unchanged
- Any backend API changes
