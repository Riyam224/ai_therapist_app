import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/saved_quote_model.dart';

class SavedQuotesLocalDatasource {
  static const String boxName = 'saved_quotes';
  static const String _quotesKey = 'quotes';

  Box<String> get _box => Hive.box<String>(boxName);

  List<SavedQuoteModel> getQuotes() {
    final jsonStr = _box.get(_quotesKey);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => SavedQuoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveQuote(SavedQuoteModel quote) async {
    final existing = getQuotes();
    final updated = [
      quote,
      ...existing.where((q) => q.text != quote.text),
    ];
    final encoded = jsonEncode(updated.map((q) => q.toJson()).toList());
    await _box.put(_quotesKey, encoded);
  }

  Future<void> deleteQuote(String id) async {
    final existing = getQuotes();
    final updated = existing.where((q) => q.id != id).toList();
    final encoded = jsonEncode(updated.map((q) => q.toJson()).toList());
    await _box.put(_quotesKey, encoded);
  }
}
