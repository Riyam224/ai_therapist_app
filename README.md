---

## Setup

### Prerequisites

- Flutter SDK ≥ 3.0
- Dart SDK ≥ 3.0
- Xcode (iOS) or Android Studio (Android)
- A Supabase project

### Environment Variables

Create a `.env` file in the project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

> ⚠️ Never commit `.env` — it is already in `.gitignore`

### Install & Run

```bash
# Install dependencies
flutter pub get

# Generate code (Hive adapters + JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run on specific device
flutter run -d ios
flutter run -d android
```

### Build for Release

```bash
flutter build apk --release
flutter build ios --release
```

---

## Design System

### Color Palette

| Role | Light mode | Dark mode |
|---|---|---|
| Primary | Peach `#E8621A` | Purple `#7C5CDB` |
| Background | Cream `#FFF8F5` | Deep `#16132A` |
| Surface | `#FFF0E8` | `#1E1A35` |
| Text primary | `#2D2016` | `#EDE9FE` |
| Text secondary | `#7A5038` | `#6B6490` |

### Rules
- Typography: `AppTextStyles` — never hardcode font sizes
- Spacing: 8px base grid via `AppSpacing` constants
- Colors: always use `AppColors` constants — never hardcode hex

---

## Key Design Decisions

| Decision | Reason |
|---|---|
| Cubit over Bloc | Simpler for this app size — no complex event streams needed |
| Hive over SQLite | No schema migrations, fast for simple key-value models |
| GetIt over Provider | Decoupled from widget tree, easier to test |
| MoodCubit as singleton | Shared state across all bottom nav tabs |
| Supabase for auth | Handles email + Google OAuth with minimal boilerplate |
| Offline fallback | History cached in Hive, served when API unavailable |
| Theme persisted in Hive | No flash on cold start, consistent across logout |

---

## State Management Pattern

```dart
// Cubit
emit(Loading());
final result = await repository.doSomething();
result.fold(
  (failure) => emit(Error(failure.message)),
  (data)    => emit(Success(data)),
);

// UI
BlocBuilder<XCubit, XState>(
  builder: (context, state) => switch (state) {
    XSuccess(:final data)  => DataWidget(data),
    XLoading()             => const LoadingWidget(),
    XError(:final message) => ErrorWidget(message),
    _                      => const SizedBox(),
  },
);
```

---

## Developer

**Riyam Hazim** — Flutter & Django full-stack developer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Riyam_Hazim-0077B5?logo=linkedin&logoColor=white)](https://linkedin.com/in/your-profile)
[![GitHub](https://img.shields.io/badge/GitHub-Riyam224-181717?logo=github&logoColor=white)](https://github.com/Riyam224)
[![API Docs](https://img.shields.io/badge/API-Live_Docs-FF6B35)](https://web-production-f8628.up.railway.app)