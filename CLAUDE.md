# CLAUDE.md — LunaSpace Flutter Project

## Project Overview

**App Name:** LunaSpace
**Tagline:** Your pocket therapist
**Type:** AI Therapist Mood Journal — Flutter mobile app
**Backend:** Django REST Framework deployed on Railway
**Auth:** Supabase (email/password + Google OAuth)
**AI:** GROQ API (llama-3.1-8b-instant)
**Developer:** Riyam

---

## Backend API

**Base URL:** `https://web-production-f8628.up.railway.app`

### Endpoints

```
POST /api/therapist/generate/
  Request:  { "user_id": "<uuid>", "emoji": "😔", "thoughts": "I feel overwhelmed" }
  Response: {
    "id": 1,
    "user_id": "abc123",
    "emoji": "😔",
    "thoughts": "I feel overwhelmed",
    "ai_response": "It sounds like you're carrying a lot...",
    "created_at": "2026-04-08T12:00:00Z"
  }

GET /api/therapist/history/?user_id=<uuid>
  Response: [ { "id": 1, "user_id": "...", "emoji": "...", "thoughts": "...", "ai_response": "...", "created_at": "..." } ]

GET /api/therapist/weekly-letter/
  Response: { "letter": "...", "stats": { "entryCount": 5, "dominantEmoji": "😔", "streak": 3, "weekStart": "...", "weekEnd": "..." } }
```

---

## Architecture: Clean Architecture (Strict)

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_spacing.dart        ← spacing constants
│   │   └── app_sizes.dart          ← size constants
│   ├── cubits/
│   │   └── theme_cubit.dart        ← dark/light mode, persisted in Hive
│   ├── errors/
│   │   └── failures.dart           ← NetworkFailure, ServerFailure
│   ├── injection/
│   │   └── injection.dart          ← GetIt DI setup
│   ├── models/
│   │   └── mood_entry.dart         ← UI display model (not domain entity)
│   ├── navigation/
│   │   ├── main_shell_screen.dart  ← bottom nav shell
│   │   └── app_bottom_nav_bar.dart ← glass-morphism bottom nav
│   ├── networking/
│   │   ├── dio_helper.dart         ← Dio singleton with PrettyDioLogger
│   │   └── api_endpoints.dart      ← all endpoint constants + base URL
│   ├── routing/
│   │   ├── router_generation_config.dart ← GoRouter with all routes
│   │   └── app_routes.dart         ← route path constants
│   └── styling/
│       ├── app_colors.dart         ← all color constants (light + dark)
│       ├── app_theme.dart          ← ThemeData light + dark
│       ├── app_extra_colors.dart   ← ThemeExtension for mood colors
│       ├── theme_extensions.dart   ← context.extra helper
│       ├── theme_text_styles.dart  ← all text styles
│       ├── app_fonts.dart          ← font family names
│       └── app_assets.dart         ← asset path constants
│
├── features/
│   ├── affirmation/
│   │   ├── data/
│   │   │   └── affirmations_data.dart   ← emoji → affirmation list map
│   │   └── presentation/
│   │       └── screens/affirmation_screen.dart
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/supabase_auth_datasource.dart
│   │   │   ├── models/user_model.dart
│   │   │   └── repositories/auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/user_entity.dart
│   │   │   ├── repositories/auth_repository.dart
│   │   │   └── usecases/ (login, register, logout)
│   │   └── presentation/
│   │       ├── cubit/ (auth_cubit, auth_state)
│   │       └── screens/ (splash, login, register)
│   │
│   ├── breathing/
│   │   └── presentation/
│   │       ├── screens/breathing_screen.dart
│   │       └── widgets/breathing_circle.dart
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── mood_remote_datasource.dart
│   │   │   │   └── mood_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── mood_entry_model.dart       ← @JsonSerializable
│   │   │   │   ├── mood_entry_model.g.dart     ← generated
│   │   │   │   └── weekly_letter_model.dart
│   │   │   └── repositories/mood_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/mood_entry_entity.dart
│   │   │   └── repositories/mood_repository.dart
│   │   └── presentation/
│   │       ├── cubit/ (mood_cubit, mood_state, weekly_letter_cubit)
│   │       ├── screens/home_screen.dart
│   │       └── widgets/ (greeting_card, mood_input_section, weekly_letter_banner, etc.)
│   │
│   ├── journal/
│   │   └── presentation/
│   │       ├── screens/journal_history_screen.dart
│   │       └── widgets/ (search, emoji filter, mood graph)
│   │
│   ├── plant/
│   │   ├── data/repositories/streak_repository.dart
│   │   ├── domain/entities/plant_stage.dart
│   │   └── presentation/cubit/ (plant_cubit, plant_state)
│   │
│   ├── profile/
│   │   └── presentation/
│   │       ├── screens/profile_screen.dart
│   │       └── widgets/ (avatar, stats, settings section)
│   │
│   ├── quotes/
│   │   ├── data/
│   │   │   ├── datasources/saved_quotes_local_datasource.dart
│   │   │   ├── models/saved_quote_model.dart
│   │   │   └── repositories/saved_quotes_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/saved_quote_entity.dart
│   │   │   ├── repositories/saved_quotes_repository.dart
│   │   │   └── usecases/ (get, save, delete)
│   │   └── presentation/
│   │       ├── cubit/ (saved_quotes_cubit, saved_quotes_state)
│   │       └── screens/saved_quotes_screen.dart
│   │
│   └── response/
│       └── presentation/
│           ├── screens/response_ai_screen.dart
│           └── widgets/ (luna_avatar, user_mood_card, ai_response_card, etc.)
│
└── main.dart
```

---

## Tech Stack & Packages

```yaml
dependencies:
  flutter_bloc: ^8.x        # state management (Cubit)
  go_router: ^14.x          # navigation
  get_it: ^7.x              # dependency injection
  dartz: ^0.10.x            # Either for error handling
  dio: ^5.x                 # HTTP client
  hive_flutter: ^1.x        # local storage
  supabase_flutter: ^2.x    # auth + Supabase client
  json_annotation: ^4.x     # JSON serialization
  equatable: ^2.x           # value equality
  flutter_dotenv: ^5.x      # .env loading
  lottie: ^3.x              # animations
  flutter_screenutil: ^5.x  # responsive sizing
  logger: ^2.x              # structured logging

dev_dependencies:
  build_runner: ^2.x
  json_serializable: ^6.x
  hive_generator: ^2.x
```

---

## Design System

### Colors (from app_colors.dart)

```dart
// Light theme
AppColors.primary            // #E8621A — peach, CTA buttons
AppColors.lightBackground    // #FFF8F5 — scaffold
AppColors.lightSurface       // #FFF0E8 — cards
AppColors.lightOnBackground  // #2D2016 — primary text
AppColors.lightSecondaryText // #7A5038 — labels, hints
AppColors.lightBorder        // #FFD4B8 — borders
AppColors.primaryContainer   // #5BBFA0 — mint, AI bubbles

// Dark theme
AppColors.darkBackground     // #16132A — scaffold
AppColors.darkSurface        // #1E1A35 — cards
AppColors.primaryDark        // #7C5CDB — purple, buttons
AppColors.darkOnBackground   // #EDE9FE — primary text
AppColors.darkSecondaryText  // #6B6490 — labels
AppColors.darkBorder         // #2D2850 — borders

// Mood colors
AppColors.moodHappy   // #4CAF50
AppColors.moodCalm    // #2196F3
AppColors.moodSad     // #FF9800
AppColors.moodExcited // #FFC107
AppColors.moodAnxious // #F44336
AppColors.moodNeutral // #9E9E9E

// Breathing exercise
AppColors.breathInColor   // #E8621A
AppColors.breathHoldColor // #2D6A4F
AppColors.breathOutColor  // #85B7EB
```

### Theme-aware colors in widgets

Always use `context.extra` (AppExtraColors ThemeExtension) or `Theme.of(context).colorScheme`:

```dart
final extra = context.extra;
extra.primaryColor        // adapts to light/dark
extra.cardBackgroundColor
extra.primaryTextColor
extra.secondaryTextColor
extra.borderColor

// Or via colorScheme
final cs = Theme.of(context).colorScheme;
cs.primary    // button color
cs.surface    // card/input fill
cs.outline    // borders
cs.error      // error states
cs.onSurface  // text on surface
```

### Typography

Always use `ThemeTextStyles` — never hardcode font sizes:

```dart
ThemeTextStyles.headlineLarge(context)
ThemeTextStyles.headlineSmall(context)
ThemeTextStyles.bodyMedium(context)
ThemeTextStyles.labelSmall(context)
```

### Border Radius

```dart
8.0   // chips, tags
14.0  // input fields
16.0  // buttons
20.0  // cards
28.0  // bottom sheets, modals
999.0 // circles (avatars, emoji buttons)
```

### Spacing (8px grid)

```dart
AppSpacing.spaceSm              // 8px
AppSpacing.spaceMd              // 16px
AppSpacing.spaceLg              // 24px
AppSpacing.horizontalPaddingLg  // main horizontal padding
AppSpacing.sectionSpacingSm     // between sections
AppSpacing.topPaddingSafeArea   // top of scrollable content
```

---

## State Management Pattern

### Cubit States

```dart
sealed class MoodState extends Equatable {
  const MoodState();
}
class MoodInitial extends MoodState { const MoodInitial(); }
class MoodLoading extends MoodState { const MoodLoading(); }
class MoodHistorySuccess extends MoodState {
  final List<MoodEntryEntity> entries;
  final MoodEntryEntity? justGenerated;
  const MoodHistorySuccess(this.entries, {this.justGenerated});
}
class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);
}
```

### Cubit in DI

```dart
// Singletons — shared across all screens/tabs
sl.registerLazySingleton(() => MoodCubit(sl()));

// Factories — new instance per screen
sl.registerFactory(() => AuthCubit(...));
sl.registerFactory(() => WeeklyLetterCubit(sl()));
sl.registerFactory(() => PlantCubit(sl()));
sl.registerFactory(() => SavedQuotesCubit(sl(), sl(), sl()));
```

---

## Domain Entities

### MoodEntryEntity

```dart
class MoodEntryEntity extends Equatable {
  final int id;
  final String userId;     // Supabase user UUID
  final String emoji;
  final String thoughts;
  final String aiResponse;
  final DateTime createdAt;
}
```

### UserEntity

```dart
class UserEntity {
  final String id;     // Supabase UUID
  final String email;
  final String? name;  // from full_name metadata
}
```

### SavedQuoteEntity

```dart
class SavedQuoteEntity {
  final String id;       // timestamp-based string ID
  final String text;
  final DateTime savedAt;
}
```

### PlantStage

```dart
enum PlantStage { seed, sprout, seedling, youngPlant, blooming }
// PlantStage.fromStreak(int days) → maps days to stage
// 0 → seed, 1-6 → sprout, 7-13 → seedling, 14-27 → youngPlant, 28+ → blooming
```

---

## Navigation (go_router)

```dart
// All routes defined in AppRoutes constants
AppRoutes.splash         // '/splash'
AppRoutes.loginScreen    // '/loginScreen'
AppRoutes.registerScreen // '/registerScreen'
AppRoutes.home           // '/home'    (bottom nav tab 0)
AppRoutes.journal        // '/journal' (bottom nav tab 1)
AppRoutes.profile        // '/profile' (bottom nav tab 2)
AppRoutes.response       // '/response'
AppRoutes.breathing      // '/breathing'
AppRoutes.affirmation    // '/affirmation'
AppRoutes.savedQuotes    // '/savedQuotes'

// Navigate
context.go(AppRoutes.home);
context.go(AppRoutes.response, extra: {
  'emojiPath': path,        // nullable — image-based emoji
  'emojiUnicode': '😔',    // nullable — unicode emoji
  'thoughts': thoughts,
});
```

---

## Error Handling

```dart
// All repository methods return Either
Future<Either<Failure, MoodEntryEntity>> generateResponse(...);

// Failure types
class NetworkFailure extends Failure {}  // connectivity / unexpected errors
class ServerFailure extends Failure {}   // API 4xx/5xx

// In cubit — fold the Either
result.fold(
  (failure) => emit(MoodError(failure.message)),
  (entry)   => emit(MoodHistorySuccess([entry], justGenerated: entry)),
);
```

---

## Local Storage (Hive)

```dart
// Box names + types
Hive.box<String>('mood_cache')    // key: 'entries'   — JSON list of MoodEntryModel
Hive.box<String>('saved_quotes')  // key: 'quotes'    — JSON list of SavedQuoteModel
Hive.box<bool>('settings')        // key: 'dark_mode' — theme preference (bool)

// All boxes opened in main() before runApp
```

---

## Dependency Injection (get_it)

```dart
// Registration order in setupInjection():
// 1. External  (DioHelper, SupabaseClient)
// 2. DataSources
// 3. Repositories
// 4. UseCases
// 5. Cubits

final sl = GetIt.instance;

// Access anywhere in the app
sl<MoodCubit>()
sl<AuthCubit>()         // creates new instance each time (factory)
sl<DioHelper>().dio     // the Dio instance
sl<SupabaseClient>()    // Supabase.instance.client
```

---

## Auth Flow

```
User opens app
  → SplashScreen (4s)
  → Supabase auth listener in main.dart
      → session exists → go('/home')
      → no session    → go('/loginScreen')

Login / Register:
  Screen → AuthCubit → UseCase → AuthRepository
  → SupabaseAuthDatasource → Supabase SDK
  → success: emit AuthAuthenticated → main.dart listener → go('/home')

Logout:
  ProfileScreen → AuthCubit.logout() → Supabase.auth.signOut()
  → Shell BlocListener detects AuthUnauthenticated → go('/loginScreen')
```

---

## Screens Reference

### HomeScreen

- Provides: `PlantCubit..loadPlant()`, `MoodCubit` (value), `WeeklyLetterCubit..load()`
- `GreetingCard` — time-based greeting, Lottie animation, streak badge (PlantCubit)
- `WeeklyLetterBanner` — weekly reflection stats
- `MoodInputSection` — emoji selector + thoughts TextField
- `RecentEntriesList` — entries from MoodCubit state
- First-entry confetti animation (blooming.json, one-time)

### ResponseAiScreen

- Receives via route extra: `emojiImagePath`, `emojiUnicode`, `thoughts`
- Calls `MoodCubit.generateResponse(emoji, thoughts)` on init
- `BlocListener` on `MoodHistorySuccess(justGenerated:)` → renders AI response
- Mood tag chips, after-feeling emoji selector
- Save quote → `SavedQuotesCubit.saveQuote(aiResponse)`
- Share → screenshot + Share.shareXFiles()

### JournalHistoryScreen

- Search bar filters by thoughts text
- Emoji chip filter
- Pull-to-refresh → `MoodCubit.getHistory()`
- Mood graph visualization

### ProfileScreen

- Avatar with user initials
- Stats: total entries, this week, streak days
- Dark mode toggle → `ThemeCubit.toggleTheme()`
- Navigate to SavedQuotes
- Logout → `AuthCubit.logout()`

### BreathingScreen

- 4-7-8 technique: breathe in 4s → hold 7s → breathe out 8s × 3 rounds
- Animated circle (scale + color per phase)
- Haptic feedback on phase transitions

### AffirmationScreen

- Emoji-specific affirmation cards from `affirmations_data.dart`
- Swipe/tap to cycle through
- Emoji map: 😔 😢 😰 😩 😭 😑 🙁 + default fallback

---

## Code Rules

### Always Do

- Use `const` constructors everywhere possible
- Use `AppColors`, `context.extra`, `Theme.of(context).colorScheme` — never hardcode hex in widgets
- Use `ThemeTextStyles` — never hardcode font sizes
- Use `Either<Failure, T>` for all repository methods
- Register shared Cubits as `lazySingleton`, per-screen Cubits as `factory`
- Use `BlocBuilder` for UI rebuilds, `BlocListener` for navigation and SnackBars
- Add `SafeArea` to every screen
- Handle all 3 states: loading, success, error

### Never Do

- Never put business logic in UI (screens/widgets)
- Never hardcode colors, sizes, or text styles in widgets
- Never use `setState` — use Cubit instead
- Never call API directly from UI
- Never use `Navigator.push` — use `context.go()`
- Never ignore failures — always show user feedback
- Never store secrets (API keys, Supabase keys) in code — use `.env`
- Never use `late` without initialization
- Never mix architecture layers (no Dio calls in Cubit)

### File Naming

```
snake_case for all files:
  home_screen.dart
  mood_entry_entity.dart
  mood_repository_impl.dart

PascalCase for classes:
  class HomeScreen extends StatelessWidget
  class MoodEntryEntity extends Equatable
```

---

## Important Notes for Claude

- **Clean Architecture strictly** — never suggest mixing layers
- **Cubit only** — never suggest Bloc events unless explicitly asked
- **go_router only** — never use Navigator.push
- All API calls go through **Repository → DataSource** chain
- The backend is **already built and deployed** — do not change API structure
- Colors and styles from **AppColors / context.extra / ThemeTextStyles only** — never hardcode in widgets
- **MoodCubit is a lazy singleton** — all tabs share the same instance
- **Theme is persisted in Hive** — ThemeCubit reads Hive on init, writes on toggle
- **User isolation** — all API calls include `user_id` from `Supabase.auth.currentUser?.id`; local cache fallback filters by userId
- **Login and Register screens are theme-aware** — use `context.extra` and `Theme.of(context).colorScheme`, never hardcoded light colors
- The app personality is **warm, calming, supportive** — keep UI soft and rounded

---

## Commands

```bash
# Install packages
flutter pub get

# Generate code (Hive adapters + JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run on specific device
flutter run -d ios
flutter run -d android

# Build release
flutter build apk --release
flutter build ios --release
```

---

## Environment Variables

Create `.env` in project root (never commit to git):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

Add to `.gitignore`:

```gitignore
.env
*.env
```
