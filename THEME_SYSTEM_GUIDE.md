# Theme System Guide - Light & Dark Mode Support

## Overview
The app now has a comprehensive theme system that fully supports light and dark modes. All text colors, background colors, and UI elements automatically adapt to the current theme.

## Architecture

### 1. **Theme Extension System** ([`app_extra_colors.dart`](lib/core/styling/app_extra_colors.dart))
A custom theme extension that provides theme-aware colors for both light and dark modes.

**Available Colors:**
- **Primary Colors**: `primaryColor`, `primaryLightColor`, `primaryDarkColor`
- **Background Colors**: `cardBackgroundColor`, `surfaceColor`
- **Text Colors**: `primaryTextColor`, `secondaryTextColor`, `tertiaryTextColor`, `onPrimaryTextColor`
- **Mood Colors**: `moodHappy`, `moodSad`, `moodCalm`, `moodExcited`, `moodAnxious`, `moodNeutral`
- **Utility Colors**: `borderColor`, `dividerColor`, `shadowColor`

### 2. **Theme Configuration** ([`app_theme.dart`](lib/core/styling/app_theme.dart))

#### Light Theme Configuration
```dart
- Background: #FFFAFF (lightBackground)
- Card Surface: #FFFFFF (white)
- Primary: #AB7BE8 (purple)
- Text: Dark colors (#1A1124, #7B6B8F, #9E9E9E)
- Mood Colors: Vibrant (green, blue, orange, etc.)
```

#### Dark Theme Configuration
```dart
- Background: #1A1124 (midnight)
- Card Surface: #4A2A6A (deepIris)
- Primary: #C8B4F8 (lighter purple)
- Text: Light colors (white, #E0E0E0, #B0B0B0)
- Mood Colors: Adjusted for dark backgrounds
```

### 3. **Theme-Aware Text Styles** ([`theme_text_styles.dart`](lib/core/styling/theme_text_styles.dart))

All text styles automatically adapt their colors based on the current theme.

**Available Styles:**
- **Headlines**: `headlineLarge`, `headlineMedium`, `headlineSmall`
- **Titles**: `titleLarge`, `titleMedium`, `titleSmall`
- **Body**: `bodyLarge`, `bodyMedium`, `bodySmall`
- **Labels**: `labelLarge`, `labelMedium`, `labelSmall`
- **Captions**: `captionLarge`, `captionSmall`
- **White Text** (for colored backgrounds): `whiteHeadline`, `whiteBody`, `whiteCaption`, `whiteButton`

### 4. **Theme Extension Helper** ([`theme_extensions.dart`](lib/core/styling/theme_extensions.dart))

Provides easy access to theme colors via `context.extra`:

```dart
final extraColors = context.extra;
final primaryColor = extraColors.primaryColor;
```

## How to Use

### Accessing Theme Colors

```dart
Widget build(BuildContext context) {
  // Get theme-aware colors
  final extraColors = context.extra;

  return Container(
    color: extraColors.primaryColor,
    child: Text(
      'Hello',
      style: ThemeTextStyles.bodyLarge(context),
    ),
  );
}
```

### Using Theme-Aware Text Styles

```dart
// For regular text
Text(
  'Welcome',
  style: ThemeTextStyles.headlineLarge(context),
)

// For text on colored backgrounds
Container(
  color: context.extra.primaryColor,
  child: Text(
    'Button Text',
    style: ThemeTextStyles.whiteButton(context),
  ),
)
```

### Theme-Aware Widgets

All home screen widgets now support theme changes:

1. **Home Screen** - All text and colors adapt
2. **Mood Entry Card** - Background, text, and icon colors change
3. **Emoji Mood Selector** - Background and border colors adapt
4. **Greeting Card** - Uses theme-aware colors
5. **Text Fields** - Border colors adapt to theme

## Updated Components

### ✅ Home Screen ([`home_screen.dart`](lib/features/home/presentation/screens/home_screen.dart))
- Header with avatar and theme toggle
- Dynamic greeting card
- Mood emoji selector
- Share mood section
- Recent mood entries list

All use `context.extra` for colors and `ThemeTextStyles` for text.

### ✅ Mood Entry Card ([`mood_entry_card.dart`](lib/features/home/presentation/widgets/mood_entry_card.dart))
- Card background adapts (white in light, deep iris in dark)
- Text colors automatically adjust
- Shadow color changes for better visibility

### ✅ Emoji Mood Selector ([`emoji_entry_mood.dart`](lib/features/home/presentation/widgets/emoji_entry_mood.dart))
- Background color adapts
- Selection highlight uses theme primary color
- Border colors match theme

## Color Comparison

### Primary Text Colors

| Element | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Headlines | #1A1124 (dark) | #FFFFFF (white) |
| Body Text | #1A1124 (dark) | #E0E0E0 (light gray) |
| Secondary | #7B6B8F (muted) | #B0B0B0 (gray) |
| Tertiary | #9E9E9E (gray) | #808080 (dim gray) |

### Background Colors

| Element | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Screen | #FFFAFF (off-white) | #1A1124 (midnight) |
| Cards | #FFFFFF (white) | #4A2A6A (deep iris) |
| Card Accent | #F3F0FC (light purple) | #4A2A6A (deep iris) |

### Mood Colors

| Mood | Light Mode | Dark Mode |
|------|-----------|-----------|
| Happy | #4CAF50 (green) | #66BB6A (lighter green) |
| Sad | #FF9800 (orange) | #FFB74D (lighter orange) |
| Calm | #2196F3 (blue) | #42A5F5 (lighter blue) |
| Excited | #FFC107 (amber) | #FFCA28 (lighter amber) |
| Anxious | #F44336 (red) | #EF5350 (lighter red) |

## Migration Pattern

### Before (Static Colors)
```dart
Text(
  'Hello',
  style: TextStyle(
    color: AppColors.primaryTextColor, // Static, doesn't adapt
    fontSize: 16.sp,
  ),
)
```

### After (Theme-Aware)
```dart
Text(
  'Hello',
  style: ThemeTextStyles.bodyLarge(context), // Adapts to theme
)
```

### Before (Static Background)
```dart
Container(
  color: AppColors.whiteBackground, // Always white
  child: ...,
)
```

### After (Theme-Aware)
```dart
Container(
  color: context.extra.surfaceColor, // White in light, deep iris in dark
  child: ...,
)
```

## Theme Toggle

The theme can be toggled using the icon button in the header:
- Light mode: Shows moon icon
- Dark mode: Shows sun icon

Toggle is managed by `ThemeCubit`:
```dart
context.read<ThemeCubit>().toggleTheme();
```

## Best Practices

### ✅ DO:
- Use `context.extra` to access theme colors
- Use `ThemeTextStyles` for all text
- Test UI in both light and dark modes
- Use semantic color names (primaryColor, surfaceColor)
- Use `whiteText` styles for colored backgrounds

### ❌ DON'T:
- Hardcode colors like `Colors.white` or `Colors.black`
- Use static `AppStyles` (use `ThemeTextStyles` instead)
- Assume a color will look good in both themes
- Forget to pass `context` to `ThemeTextStyles` methods

## Testing Themes

### Manual Testing
1. Run the app
2. Click the theme toggle button (moon/sun icon)
3. Verify all text is readable
4. Check that all UI elements look good
5. Verify mood cards update properly

### Visual Checks
- ✅ All text is readable in both modes
- ✅ No white text on white backgrounds
- ✅ No black text on black backgrounds
- ✅ Mood card colors are visible
- ✅ Borders are visible but subtle
- ✅ Shadows enhance depth appropriately

## Future Enhancements

1. **System Theme Detection**: Auto-switch based on device settings
2. **Custom Theme Colors**: Let users choose accent colors
3. **High Contrast Mode**: For accessibility
4. **Theme Preview**: Show theme before applying
5. **Per-Screen Themes**: Different themes for different sections

## Files Modified for Theme Support

1. [`lib/core/styling/app_extra_colors.dart`](lib/core/styling/app_extra_colors.dart) - ✨ Enhanced
2. [`lib/core/styling/app_theme.dart`](lib/core/styling/app_theme.dart) - ✨ Updated
3. [`lib/core/styling/theme_text_styles.dart`](lib/core/styling/theme_text_styles.dart) - 🆕 New
4. [`lib/core/styling/theme_extensions.dart`](lib/core/styling/theme_extensions.dart) - ✅ Existing
5. [`lib/features/home/presentation/screens/home_screen.dart`](lib/features/home/presentation/screens/home_screen.dart) - ✨ Updated
6. [`lib/features/home/presentation/widgets/mood_entry_card.dart`](lib/features/home/presentation/widgets/mood_entry_card.dart) - ✨ Updated
7. [`lib/features/home/presentation/widgets/emoji_entry_mood.dart`](lib/features/home/presentation/widgets/emoji_entry_mood.dart) - ✨ Updated

## Summary

The app now has a robust, production-ready theme system that:
- ✅ Fully supports light and dark modes
- ✅ All colors adapt automatically
- ✅ Text is always readable
- ✅ Follows Material Design 3 guidelines
- ✅ Easy to extend with new colors
- ✅ Type-safe with compile-time checks
- ✅ Maintains consistent design language

Users can seamlessly switch between light and dark modes with all UI elements adapting beautifully! 🎨🌓
