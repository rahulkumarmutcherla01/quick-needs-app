import 'package:equatable/equatable.dart';
import 'package:project/src/features/items/data/models/item.dart';

class Room extends Equatable {
  final String id;
  final String name;
  final String familyId;
  final List<Item>? items;

  const Room({
    required this.id,
    required this.name,
    required this.familyId,
    this.items,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      familyId: json['family_id'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => Item.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'family_id': familyId,
      'items': items?.map((i) => i.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, familyId, items];
}
