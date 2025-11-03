import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String roomId;
  final bool isPurchased;
  final double? cost;

  const Item({
    required this.id,
    required this.name,
    required this.roomId,
    this.isPurchased = false,
    this.cost,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      roomId: json['room_id'],
      isPurchased: json['is_purchased'] ?? false,
      cost: json['cost']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'room_id': roomId,
      'is_purchased': isPurchased,
      'cost': cost,
    };
  }

  @override
  List<Object?> get props => [id, name, roomId, isPurchased, cost];
}
