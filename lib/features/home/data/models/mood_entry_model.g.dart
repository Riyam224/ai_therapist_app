// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodEntryModel _$MoodEntryModelFromJson(Map<String, dynamic> json) =>
    MoodEntryModel(
      id: (json['id'] as num).toInt(),
      emoji: json['emoji'] as String,
      thoughts: json['thoughts'] as String,
      aiResponse: json['ai_response'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MoodEntryModelToJson(MoodEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emoji': instance.emoji,
      'thoughts': instance.thoughts,
      'ai_response': instance.aiResponse,
      'created_at': instance.createdAt.toIso8601String(),
    };
