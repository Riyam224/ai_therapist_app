import 'package:equatable/equatable.dart';
import '../../domain/entities/mood_entry_entity.dart';

abstract class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {
  const MoodInitial();
}

class MoodLoading extends MoodState {
  const MoodLoading();
}

class MoodGenerateSuccess extends MoodState {
  final MoodEntryEntity entry;
  const MoodGenerateSuccess(this.entry);

  @override
  List<Object?> get props => [entry];
}

class MoodHistorySuccess extends MoodState {
  final List<MoodEntryEntity> entries;
  const MoodHistorySuccess(this.entries);

  @override
  List<Object?> get props => [entries];
}

class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);

  @override
  List<Object?> get props => [message];
}
