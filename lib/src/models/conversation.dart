enum ConversationType { GROUP, DIRECT, CONFIDENTIAL_THREAD }

class Conversation {
  final String id;
  final String familyId;
  final ConversationType type;
  final String createdByUserId;

  Conversation({
    required this.id,
    required this.familyId,
    required this.type,
    required this.createdByUserId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      familyId: json['family_id'],
      type: ConversationType.values.byName(json['type']),
      createdByUserId: json['created_by_user_id'],
    );
  }
}
