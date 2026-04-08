import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood_entry_model.dart';

class MoodLocalDatasource {
  static const String boxName = 'mood_cache';
  static const String _entriesKey = 'entries';

  Box<String> get _box => Hive.box<String>(boxName);

  /// Get cached mood entries
  List<MoodEntryModel> getCachedHistory() {
    final jsonStr = _box.get(_entriesKey);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => MoodEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Cache the entire list of entries
  Future<void> cacheHistory(List<MoodEntryModel> entries) async {
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _box.put(_entriesKey, encoded);
  }

  /// Add a new entry, avoiding duplicates by id
  Future<void> addEntry(MoodEntryModel entry) async {
    final existing = getCachedHistory();
    final updated = [
      entry,
      ...existing.where((e) => e.id != entry.id),
    ];
    await cacheHistory(updated);
  }

  /// Delete an entry by id
  Future<void> deleteEntry(int id) async {
    final existing = getCachedHistory();
    final updated = existing.where((e) => e.id != id).toList();
    await cacheHistory(updated);
  }

  /// Clears all cached entries
  Future<void> deleteAllEntries() async {
    await _box.delete(_entriesKey);
  }
}
