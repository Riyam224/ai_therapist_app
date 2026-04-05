import 'package:dio/dio.dart';

class StreakRepository {
  final Dio dio;
  StreakRepository(this.dio);

  Future<int> calculateStreak() async {
    try {
      final response = await dio.get('/api/journal/entries/');

      final List entries = response.data['results'] ?? response.data ?? [];

      if (entries.isEmpty) return 0;

      final dates = entries
          .map((e) {
            final dateStr = e['created_at'] as String;
            final date = DateTime.parse(dateStr);
            return DateTime(date.year, date.month, date.day);
          })
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));

      int streak = 0;
      DateTime expected = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      for (final date in dates) {
        final diff = expected.difference(date).inDays;
        if (diff > 1) break;
        streak++;
        expected = date.subtract(const Duration(days: 1));
      }

      return streak;
    } catch (_) {
      return 0;
    }
  }
}
