import 'package:equatable/equatable.dart';
import 'package:project/src/features/items/data/models/item.dart';

class Room extends Equatable {
  final String id;
  final String name;
  final String familyId;
  final String icon;
  final List<Item>? items;

  const Room({
    required this.id,
    required this.name,
    required this.familyId,
    required this.icon,
    this.items,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['room_name'],
      familyId: json['family_id'],
      icon: json['room_icon'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => Item.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_name': name,
      'family_id': familyId,
      'room_icon': icon,
      'items': items?.map((i) => i.toJson()).toList(),
    };
  }

  Room copyWith({
    String? id,
    String? name,
    String? familyId,
    String? icon,
    List<Item>? items,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      familyId: familyId ?? this.familyId,
      icon: icon ?? this.icon,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, name, familyId, icon, items];
}
