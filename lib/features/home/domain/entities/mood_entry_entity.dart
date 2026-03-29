import 'package:equatable/equatable.dart';

class MoodEntryEntity extends Equatable {
  final int id;
  final String emoji;
  final String thoughts;
  final String aiResponse;
  final DateTime createdAt;

  const MoodEntryEntity({
    required this.id,
    required this.emoji,
    required this.thoughts,
    required this.aiResponse,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, emoji, thoughts, aiResponse, createdAt];
}