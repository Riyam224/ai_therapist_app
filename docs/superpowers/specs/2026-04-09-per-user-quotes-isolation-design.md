# Per-User Saved Quotes Isolation

**Date:** 2026-04-09  
**Status:** Approved

## Problem

`SavedQuotesLocalDatasource` stores all quotes under a single Hive key (`'quotes'`), shared across all users on the same device. When a second user logs in, they see the first user's saved quotes.

Mood entries are already isolated (fixed in commits `293e2b9`, `ac7a71d`) using per-user Hive keys (`entries_$userId`). Saved quotes need the same treatment.

## Scope

- **In scope:** Saved quotes local isolation
- **Out of scope:** Mood entries (already fixed), chat (remote-only, per-user by design), domain/cubit/UI layers

## Design

Mirror the exact pattern already used in `MoodLocalDatasource` / `MoodRepositoryImpl`.

### `SavedQuotesLocalDatasource`

Replace the hardcoded `'quotes'` key with a per-user key:

```dart
String _key(String userId) => 'quotes_$userId';
```

All methods receive a `userId` parameter and use `_key(userId)` instead of `_quotesKey`.

### `SavedQuotesRepositoryImpl`

Inject `SupabaseClient`. Add:

```dart
String get _currentUserId => _supabase.auth.currentUser?.id ?? '';
```

Pass `userId: _currentUserId` to every datasource call.

### `injection.dart`

Pass `sl<SupabaseClient>()` as the third argument to `SavedQuotesRepositoryImpl`.

## What Does Not Change

- Domain entities, repository interface, use cases — isolation is a data layer concern
- `SavedQuotesCubit` — no changes
- All UI screens — no changes

## Data Migration

Quotes saved under the old `'quotes'` key become orphaned (no user owns that key). They are invisible after this change. This is acceptable — it is a clean break with no data loss risk going forward.

## Files Changed

1. `lib/features/quotes/data/datasources/saved_quotes_local_datasource.dart`
2. `lib/features/quotes/data/repositories/saved_quotes_repository_impl.dart`
3. `lib/core/injection/injection.dart`
