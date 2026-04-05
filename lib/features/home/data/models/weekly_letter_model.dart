class WeeklyLetterStats {
  final int entryCount;
  final String dominantEmoji;
  final int streak;
  final String weekStart;
  final String weekEnd;

  const WeeklyLetterStats({
    required this.entryCount,
    required this.dominantEmoji,
    required this.streak,
    required this.weekStart,
    required this.weekEnd,
  });

  factory WeeklyLetterStats.fromJson(Map<String, dynamic> json) {
    return WeeklyLetterStats(
      entryCount: (json['entry_count'] as num).toInt(),
      dominantEmoji: json['dominant_emoji'] as String,
      streak: (json['streak'] as num).toInt(),
      weekStart: json['week_start'] as String,
      weekEnd: json['week_end'] as String,
    );
  }
}

class WeeklyLetterModel {
  final String? letter;
  final WeeklyLetterStats stats;

  const WeeklyLetterModel({
    required this.letter,
    required this.stats,
  });

  factory WeeklyLetterModel.fromJson(Map<String, dynamic> json) {
    return WeeklyLetterModel(
      letter: json['letter'] as String?,
      stats: WeeklyLetterStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }
}
