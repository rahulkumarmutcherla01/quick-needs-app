class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String contentType;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.contentType,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      contentType: json['content_type'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
