import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood_entry_model.dart';

class MoodLocalDatasource {
  static const String boxName = 'mood_cache';
  static const String _entriesKey = 'entries';

  Box<String> get _box => Hive.box<String>(boxName);

  List<MoodEntryModel> getCachedHistory() {
    final jsonStr = _box.get(_entriesKey);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => MoodEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheHistory(List<MoodEntryModel> entries) async {
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _box.put(_entriesKey, encoded);
  }

  /// Prepends a new entry to the cache, avoiding duplicates by id.
  Future<void> addEntry(MoodEntryModel entry) async {
    final existing = getCachedHistory();
    final updated = [entry, ...existing.where((e) => e.id != entry.id)];
    await cacheHistory(updated);
  }

  /// Removes the entry with the given id from the cache.
  Future<void> deleteEntry(int id) async {
    final existing = getCachedHistory();
    final updated = existing.where((e) => e.id != id).toList();
    await cacheHistory(updated);
  }
}
