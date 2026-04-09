// lib/features/chat/data/repositories/chat_repository_impl.dart

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> sendMessage({
    required String userId,
    required String emoji,
    required String thoughts,
    required List<ChatMessage> history,
  }) async {
    return await remoteDataSource.sendMessage(
      userId: userId,
      emoji: emoji,
      thoughts: thoughts,
      history: history,
    );
  }
}
