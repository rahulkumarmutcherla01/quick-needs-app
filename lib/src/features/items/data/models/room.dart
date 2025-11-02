import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String familyId;
  final String roomName;
  final String roomIcon;
  final bool isCustom;
  final DateTime createdAt;

  const Room({
    required this.id,
    required this.familyId,
    required this.roomName,
    required this.roomIcon,
    required this.isCustom,
    required this.createdAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      familyId: json['family_id'],
      roomName: json['room_name'],
      roomIcon: json['room_icon'],
      isCustom: json['is_custom'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, familyId, roomName, roomIcon, isCustom, createdAt];
}
