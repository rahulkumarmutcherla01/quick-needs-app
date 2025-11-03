import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String name;
  final String familyId;

  const Room({
    required this.id,
    required this.name,
    required this.familyId,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      familyId: json['family_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'family_id': familyId,
    };
  }

  @override
  List<Object?> get props => [id, name, familyId];
}
