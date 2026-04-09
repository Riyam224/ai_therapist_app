# Per-User Saved Quotes Isolation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Isolate saved quotes per user so no two users on the same device can see each other's quotes.

**Architecture:** Mirror the exact pattern already used for mood entries — add a per-user Hive key (`quotes_$userId`) in the datasource, inject `SupabaseClient` into the repository to resolve the current user ID at runtime, and wire the updated constructor in DI. No domain, cubit, or UI changes needed.

**Tech Stack:** Flutter, Hive (local storage), Supabase (auth / current user), GetIt (DI), Clean Architecture

---

## File Map

| File | Change |
|------|--------|
| `lib/features/quotes/data/datasources/saved_quotes_local_datasource.dart` | Replace hardcoded key with `_key(userId)`, add `userId` param to all methods |
| `lib/features/quotes/data/repositories/saved_quotes_repository_impl.dart` | Inject `SupabaseClient`, add `_currentUserId`, pass to datasource |
| `lib/core/injection/injection.dart` | Pass `sl<SupabaseClient>()` to `SavedQuotesRepositoryImpl` |

---

### Task 1: Update `SavedQuotesLocalDatasource` — per-user key

**Files:**
- Modify: `lib/features/quotes/data/datasources/saved_quotes_local_datasource.dart`

- [ ] **Step 1: Replace the file contents**

Replace the entire file with:

```dart
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/saved_quote_model.dart';

class SavedQuotesLocalDatasource {
  static const String boxName = 'saved_quotes';

  Box<String> get _box => Hive.box<String>(boxName);

  /// Per-user Hive key so quotes never bleed between accounts on the same device
  String _key(String userId) => 'quotes_$userId';

  List<SavedQuoteModel> getQuotes({required String userId}) {
    final jsonStr = _box.get(_key(userId));
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => SavedQuoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveQuote(SavedQuoteModel quote, {required String userId}) async {
    final existing = getQuotes(userId: userId);
    final updated = [
      quote,
      ...existing.where((q) => q.text != quote.text),
    ];
    final encoded = jsonEncode(updated.map((q) => q.toJson()).toList());
    await _box.put(_key(userId), encoded);
  }

  Future<void> deleteQuote(String id, {required String userId}) async {
    final existing = getQuotes(userId: userId);
    final updated = existing.where((q) => q.id != id).toList();
    final encoded = jsonEncode(updated.map((q) => q.toJson()).toList());
    await _box.put(_key(userId), encoded);
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/quotes/data/datasources/saved_quotes_local_datasource.dart
git commit -m "feat: isolate saved quotes by user in Hive cache"
```

---

### Task 2: Update `SavedQuotesRepositoryImpl` — inject SupabaseClient

**Files:**
- Modify: `lib/features/quotes/data/repositories/saved_quotes_repository_impl.dart`

- [ ] **Step 1: Replace the file contents**

```dart
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/saved_quote_entity.dart';
import '../../domain/repositories/saved_quotes_repository.dart';
import '../datasources/saved_quotes_local_datasource.dart';
import '../models/saved_quote_model.dart';

class SavedQuotesRepositoryImpl implements SavedQuotesRepository {
  final SavedQuotesLocalDatasource _local;
  final SupabaseClient _supabase;
  final Logger _logger = Logger();

  SavedQuotesRepositoryImpl(this._local, this._supabase);

  String get _currentUserId => _supabase.auth.currentUser?.id ?? '';

  @override
  Future<Either<Failure, List<SavedQuoteEntity>>> getQuotes() async {
    try {
      final quotes = _local.getQuotes(userId: _currentUserId);
      return Right(quotes.map((q) => q.toEntity()).toList());
    } catch (e) {
      _logger.e('Failed to load quotes: $e');
      return Left(NetworkFailure('Failed to load saved quotes'));
    }
  }

  @override
  Future<Either<Failure, SavedQuoteEntity>> saveQuote(String text) async {
    try {
      final quote = SavedQuoteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        savedAt: DateTime.now(),
      );
      await _local.saveQuote(quote, userId: _currentUserId);
      return Right(quote.toEntity());
    } catch (e) {
      _logger.e('Failed to save quote: $e');
      return Left(NetworkFailure('Failed to save quote'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuote(String id) async {
    try {
      await _local.deleteQuote(id, userId: _currentUserId);
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to delete quote: $e');
      return Left(NetworkFailure('Failed to delete quote'));
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/quotes/data/repositories/saved_quotes_repository_impl.dart
git commit -m "feat: pass current user id to SavedQuotesLocalDatasource"
```

---

### Task 3: Update DI — wire SupabaseClient into SavedQuotesRepositoryImpl

**Files:**
- Modify: `lib/core/injection/injection.dart:78-80`

- [ ] **Step 1: Update the registration**

Find this block in `injection.dart`:

```dart
  // ── Saved Quotes Repository ──
  sl.registerLazySingleton<SavedQuotesRepository>(
    () => SavedQuotesRepositoryImpl(sl()),
  );
```

Replace it with:

```dart
  // ── Saved Quotes Repository ──
  sl.registerLazySingleton<SavedQuotesRepository>(
    () => SavedQuotesRepositoryImpl(sl(), sl()),
  );
```

The second `sl()` resolves `SupabaseClient`, already registered as a lazySingleton above.

- [ ] **Step 2: Verify no compile errors**

```bash
flutter analyze lib/features/quotes/ lib/core/injection/injection.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/core/injection/injection.dart
git commit -m "fix: wire SupabaseClient into SavedQuotesRepositoryImpl"
```

---

### Task 4: Manual verification

- [ ] **Step 1: Run the app**

```bash
flutter run
```

- [ ] **Step 2: Test isolation**

1. Log in as **User A** → save 1–2 quotes from the AI response screen
2. Log out (Profile → Logout)
3. Log in as **User B** (register a new account if needed) → navigate to Saved Quotes
4. Confirm User B sees **no quotes**
5. Log out and log back in as **User A**
6. Confirm User A's quotes are still there

- [ ] **Step 3: Done**

All three data types (mood entries, saved quotes, chat) are now fully isolated per user.
