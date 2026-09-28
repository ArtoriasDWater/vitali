class ChatMessage {
  final String role;
  final String text;
  final DateTime createdAt;

  ChatMessage({required this.role, required this.text, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  factory ChatMessage.user(String text) =>
      ChatMessage(role: 'user', text: text);

  factory ChatMessage.assistant(String text) =>
      ChatMessage(role: 'assistant', text: text);
}
