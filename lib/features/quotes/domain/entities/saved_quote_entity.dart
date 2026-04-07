class SavedQuoteEntity {
  final String id;
  final String text;
  final DateTime savedAt;

  const SavedQuoteEntity({
    required this.id,
    required this.text,
    required this.savedAt,
  });
}
