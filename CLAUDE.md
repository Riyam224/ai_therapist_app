# CLAUDE.md — MindEase Flutter Project

## Project Overview

**App Name:** MindEase  
**Tagline:** Your pocket therapist  
**Type:** AI Therapist Mood Journal — Flutter mobile app  
**Backend:** Django REST Framework deployed on Railway  
**AI:** GROQ API (llama-3.1-8b-instant)  
**Developer:** Riyam  

---

## Backend API

**Base URL:** `https://web-production-f8628.up.railway.app`

### Endpoints

```
POST /api/therapist/generate/
  Request:  { "emoji": "😔", "thoughts": "I feel overwhelmed" }
  Response: {
    "id": 1,
    "emoji": "😔",
    "thoughts": "I feel overwhelmed",
    "ai_response": "It sounds like you're carrying a lot...",
    "created_at": "2026-03-27T12:00:00Z"
  }

GET /api/therapist/history/
  Response: [ { "id": 1, "emoji": "...", "thoughts": "...", "ai_response": "...", "created_at": "..." } ]
```

---

## Architecture: Clean Architecture (Strict)

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         ← all colors defined here
│   │   ├── app_theme.dart          ← light + dark ThemeData
│   │   └── app_text_styles.dart    ← all text styles
│   ├── network/
│   │   ├── dio_client.dart         ← Dio singleton with interceptors
│   │   └── api_endpoints.dart      ← all endpoint constants
│   ├── error/
│   │   ├── failures.dart           ← Failure classes
│   │   └── exceptions.dart         ← Exception classes
│   ├── usecases/
│   │   └── usecase.dart            ← abstract UseCase<T, Params>
│   └── utils/
│       ├── date_formatter.dart
│       └── constants.dart          ← all string constants
│
├── features/
│   └── mood/
│       ├── data/
│       │   ├── models/
│       │   │   └── mood_entry_model.dart
│       │   ├── datasources/
│       │   │   ├── mood_remote_datasource.dart
│       │   │   └── mood_local_datasource.dart
│       │   └── repositories/
│       │       └── mood_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── mood_entry.dart
│       │   ├── repositories/
│       │   │   └── mood_repository.dart
│       │   └── usecases/
│       │       ├── generate_response_usecase.dart
│       │       └── get_history_usecase.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── mood_cubit.dart
│           │   └── mood_state.dart
│           ├── screens/
│           │   ├── home_screen.dart
│           │   ├── response_screen.dart
│           │   ├── history_screen.dart
│           │   └── profile_screen.dart
│           └── widgets/
│               ├── mood_card.dart
│               ├── emoji_selector.dart
│               ├── luna_avatar.dart
│               ├── loading_button.dart
│               ├── empty_state.dart
│               └── mood_chip.dart
│
├── router/
│   └── app_router.dart             ← go_router configuration
│
├── injection/
│   └── injection.dart              ← get_it dependency injection
│
└── main.dart
```

---

## Tech Stack & Packages

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Navigation
  go_router: ^14.0.0

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Network
  dio: ^5.4.3
  retrofit: ^4.1.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Dependency Injection
  get_it: ^7.7.0

  # Error Handling
  dartz: ^0.10.1

  # Environment
  flutter_dotenv: ^5.1.0

  # UI
  flutter_svg: ^2.0.10+1
  lottie: ^3.1.0
  cached_network_image: ^3.3.1

dev_dependencies:
  build_runner: ^2.4.9
  retrofit_generator: ^8.1.0
  hive_generator: ^2.0.1
  json_serializable: ^6.8.0
```

---

## Design System

### Colors (from app_colors.dart)

```dart
// Primary — Light Purple (main brand color)
AppColors.primary500  // #6C5CE7  ← buttons, active icons
AppColors.primary50   // #F0EEFF  ← backgrounds, tints
AppColors.primary200  // #C0B8FF  ← borders, soft fills

// Accent — Soft Pink
AppColors.pink500     // #E84393  ← highlights, user bubbles
AppColors.pink50      // #FFF0F5  ← user mood card background

// Lavender
AppColors.lavender500 // #9180E8  ← AI response cards
AppColors.lavender50  // #F7F5FF  ← AI bubble background

// Mint — success/positive
AppColors.mint500     // #18A887
AppColors.mint50      // #EEFBF7

// Neutral
AppColors.neutral900  // #1C1A2E  ← primary text
AppColors.neutral600  // #6E698C  ← secondary text
AppColors.neutral400  // #AEA8C8  ← tertiary/muted text
AppColors.neutral100  // #F2F0F8  ← surface variant
AppColors.neutral200  // #E4E0F0  ← borders

// Dark mode
AppColors.darkBackground   // #0F0E18
AppColors.darkSurface      // #1A1828
AppColors.darkCardBg       // #1E1C30
AppColors.darkBorder       // #2E2C42
```

### Typography

```dart
// Always use AppTextStyles — never hardcode font sizes
AppTextStyles.displayLarge(context)   // 32px Bold
AppTextStyles.headlineMedium(context) // 18px SemiBold
AppTextStyles.bodyMedium(context)     // 14px Regular
AppTextStyles.labelSmall(context)     // 11px Medium
AppTextStyles.caption(context)        // 11px Regular muted
```

### Border Radius

```dart
8.0   // chips, tags, small elements
16.0  // buttons, inputs, small cards
20.0  // cards
28.0  // bottom sheets, modals
999.0 // avatars, emoji buttons (circles)
```

### Spacing Grid (8px base)

```
4px  → micro gaps
8px  → tight spacing between elements
16px → default horizontal padding
24px → section spacing
32px → large section gaps
```

---

## State Management Pattern

### Cubit States

```dart
// mood_state.dart
abstract class MoodState extends Equatable {}

class MoodInitial extends MoodState {}
class MoodLoading extends MoodState {}
class MoodGenerateSuccess extends MoodState {
  final MoodEntry entry;
}
class MoodHistorySuccess extends MoodState {
  final List<MoodEntry> entries;
  final List<MoodEntry> filtered; // for search/filter
}
class MoodError extends MoodState {
  final String message;
}
```

### Cubit Methods

```dart
// mood_cubit.dart
class MoodCubit extends Cubit<MoodState> {
  Future<void> generateResponse(String emoji, String thoughts) async { ... }
  Future<void> getHistory() async { ... }
  void filterByEmoji(String emoji) { ... }
  void searchHistory(String query) { ... }
  void clearFilter() { ... }
}
```

---

## Navigation (go_router)

```dart
// app_router.dart
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/',          builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/response',  builder: (_, state) => ResponseScreen(entry: state.extra as MoodEntry)),
    GoRoute(path: '/history',   builder: (_, __) => const HistoryScreen()),
    GoRoute(path: '/profile',   builder: (_, __) => const ProfileScreen()),
  ],
);

// Navigate to response screen:
context.go('/response', extra: moodEntry);

// Navigate back:
context.pop();
```

---

## Error Handling

```dart
// Always use Either from dartz
Future<Either<Failure, MoodEntry>> generateResponse(String emoji, String thoughts);

// Failures
class NetworkFailure extends Failure {}   // no internet
class ServerFailure extends Failure {}    // API error (4xx, 5xx)
class CacheFailure extends Failure {}     // Hive error

// In Cubit — fold the Either:
result.fold(
  (failure) => emit(MoodError(_mapFailureToMessage(failure))),
  (entry)   => emit(MoodGenerateSuccess(entry)),
);
```

---

## Local Storage (Hive)

```dart
// Hive box names
const String kMoodBox = 'mood_entries';
const String kSettingsBox = 'settings';

// Keys
const String kLastEmoji = 'last_emoji';
const String kDarkMode  = 'dark_mode';

// Usage
final box = Hive.box<MoodEntryModel>(kMoodBox);
await box.add(moodEntryModel);
final entries = box.values.toList();
```

---

## Dependency Injection (get_it)

```dart
// injection.dart — always register in this order:
// 1. External (Dio, Hive)
// 2. DataSources
// 3. Repositories
// 4. UseCases
// 5. Cubits

final sl = GetIt.instance;

void setupInjection() {
  // Cubit — always factory (new instance per page)
  sl.registerFactory(() => MoodCubit(
    generateResponse: sl(),
    getHistory: sl(),
  ));

  // UseCases — lazy singleton
  sl.registerLazySingleton(() => GenerateResponseUseCase(sl()));
  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MoodRepository>(
    () => MoodRepositoryImpl(remote: sl(), local: sl()),
  );

  // DataSources
  sl.registerLazySingleton<MoodRemoteDatasource>(
    () => MoodRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<MoodLocalDatasource>(
    () => MoodLocalDatasourceImpl(),
  );

  // Dio
  sl.registerLazySingleton(() => DioClient().dio);
}
```

---

## Screens Reference

### HomeScreen
- Greeting hero card (purple gradient)
- Emoji mood selector (horizontal scroll, 9 emojis)
- Multiline thoughts input (max 500 chars)
- "Talk to Luna ✨" button → calls `generateResponse`
- Recent entries list (last 3 from Hive cache)
- On success → navigate to `/response`

### ResponseScreen
- Receives `MoodEntry` via `GoRouterState.extra`
- Luna avatar (🌸) + name + subtitle
- User mood card (pink bg) — shows emoji + thoughts
- AI response card (lavender bg) — typewriter animation
- Mood tags row (auto chips)
- "Save to journal" + "Talk again" buttons
- After-feeling selector (4 emojis)

### HistoryScreen
- Fetches all entries from API + Hive cache
- Search bar (filters thoughts text)
- Emoji filter chips (All + 8 emojis)
- MoodCard list with colored left border by mood
- Pull-to-refresh
- Tap card → bottom sheet with full entry
- Empty state illustration when no entries
- Shimmer loading on cards

### ProfileScreen
- Avatar with initials "R" (purple gradient)
- Stats: total entries, this week, streak
- Settings: dark mode toggle, notifications, language, about Luna, privacy

---

## MoodCard Left Border Colors

```dart
// Map emoji to color
String emoji → Color:
'😔' → AppColors.primary500   // purple
'😊' → AppColors.mint500      // green
'😢' → Color(0xFF85B7EB)      // blue
'😰' → Color(0xFFF0A500)      // amber
'😡' → Color(0xFFE84343)      // red
'😴' → AppColors.lavender500  // lavender
'😌' → AppColors.pink500      // pink
'🥰' → AppColors.pink300      // light pink
'😤' → Color(0xFFF76B3A)      // peach
```

---

## Code Rules

### Always Do
- Use `const` constructors everywhere possible
- Separate every widget into its own file
- Use `AppColors` and `AppTextStyles` — never hardcode
- Use `Either<Failure, T>` for all repository methods
- Register Cubits as `factory` in get_it (not singleton)
- Use `BlocProvider` at screen level, not app level
- Handle all 3 states: loading, success, error
- Add `SafeArea` to every screen
- Use `context.read<MoodCubit>()` for events
- Use `BlocBuilder` for UI rebuilds
- Use `BlocListener` for navigation and SnackBars

### Never Do
- Never put business logic in UI (screens/widgets)
- Never hardcode colors or text styles
- Never use `setState` — use Cubit instead
- Never call API directly from UI
- Never use `Navigator.push` — use `context.go()`
- Never ignore failures — always show user feedback
- Never store sensitive data (API keys) in code
- Never use `late` without initialization

### File Naming
```
snake_case for all files:
  home_screen.dart
  mood_entry.dart
  mood_repository_impl.dart
  generate_response_usecase.dart

PascalCase for classes:
  class HomeScreen extends StatelessWidget
  class MoodEntry extends Equatable
```

---

## API Integration Example

```dart
// mood_remote_datasource.dart
class MoodRemoteDatasourceImpl implements MoodRemoteDatasource {
  final Dio dio;

  Future<MoodEntryModel> generateResponse(String emoji, String thoughts) async {
    try {
      final response = await dio.post(
        ApiEndpoints.generate,
        data: {'emoji': emoji, 'thoughts': thoughts},
      );
      return MoodEntryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }
}
```

---

## Commands

```bash
# Install packages
flutter pub get

# Generate code (Hive adapters + Retrofit)
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
```
BASE_URL=https://web-production-f8628.up.railway.app
```

Load in main.dart:
```dart
await dotenv.load(fileName: '.env');
```

Use in code:
```dart
final baseUrl = dotenv.env['BASE_URL'] ?? '';
```

Add to `.gitignore`:
```
.env
*.env
```

---

## Key Design Decisions

1. **Cubit over Bloc** — simpler for this app size, no complex event mapping needed
2. **Hive over SQLite** — faster setup, no schema migrations, good for simple models
3. **Dio over http** — interceptors for logging and auth headers
4. **go_router over Navigator 2.0** — declarative, supports deep linking
5. **get_it over Provider for DI** — decoupled from widget tree, testable
6. **dartz Either** — explicit error handling, no silent failures

---

## Important Notes for Claude

- This project uses **Clean Architecture strictly** — never suggest mixing layers
- State management is **Cubit only** — never suggest Bloc events unless asked
- Navigation is **go_router only** — never use Navigator.push
- All API calls go through **UseCase → Repository → DataSource** chain
- The backend is **already built and deployed** — do not change API structure
- Colors come from **AppColors only** — never suggest hardcoded hex in widgets
- The app personality is **warm, feminine, calming** — keep UI soft and rounded
- Font family is **DM Sans** (display) + **Inter** (body) — not system fonts