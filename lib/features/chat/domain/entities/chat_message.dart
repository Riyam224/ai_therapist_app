// lib/features/chat/domain/entities/chat_message.dart

class ChatMessage {
  final String role;
  final String content;

  const ChatMessage({
    required this.role,
    required this.content,
  });
}
