import 'package:dio/dio.dart';
import '../../../../core/networking/api_endpoints.dart';
import '../models/mood_entry_model.dart';
import '../models/weekly_letter_model.dart';

class MoodRemoteDatasource {
  final Dio _dio;

  MoodRemoteDatasource(this._dio);

  Future<MoodEntryModel> generateResponse(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.generate, data: body);
    return MoodEntryModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<MoodEntryModel>> getHistory() async {
    final response = await _dio.get(ApiEndpoints.history);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => MoodEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WeeklyLetterModel> getWeeklyLetter() async {
    final response = await _dio.get(ApiEndpoints.weeklyLetter);
    return WeeklyLetterModel.fromJson(response.data as Map<String, dynamic>);
  }
}
