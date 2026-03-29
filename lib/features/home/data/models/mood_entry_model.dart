import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/mood_entry_entity.dart';

part 'mood_entry_model.g.dart';

@JsonSerializable()
class MoodEntryModel {
  final int id;
  final String emoji;
  final String thoughts;

  @JsonKey(name: 'ai_response')
  final String aiResponse;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const MoodEntryModel({
    required this.id,
    required this.emoji,
    required this.thoughts,
    required this.aiResponse,
    required this.createdAt,
  });

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) =>
      _$MoodEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoodEntryModelToJson(this);

  // Convert Model → Entity
  MoodEntryEntity toEntity() => MoodEntryEntity(
    id: id,
    emoji: emoji,
    thoughts: thoughts,
    aiResponse: aiResponse,
    createdAt: createdAt,
  );
}
