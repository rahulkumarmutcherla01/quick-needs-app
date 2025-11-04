import 'package:equatable/equatable.dart';

enum ItemStatus { PENDING, PURCHASED }

class Item extends Equatable {
  final String id;
  final String name;
  final String roomId;
  final ItemStatus status;
  final int quantity;
  final double? cost;

  const Item({
    required this.id,
    required this.name,
    required this.roomId,
    required this.status,
    required this.quantity,
    this.cost,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['item_name'],
      roomId: json['room_id'],
      status: (json['status'] as String).toItemStatus(),
      quantity: json['quantity'],
      cost: json['cost']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': name,
      'room_id': roomId,
      'status': status.name.toLowerCase(),
      'quantity': quantity,
      'cost': cost,
    };
  }

  Item copyWith({
    String? id,
    String? name,
    String? roomId,
    ItemStatus? status,
    int? quantity,
    double? cost,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      cost: cost ?? this.cost,
    );
  }

  @override
  List<Object?> get props => [id, name, roomId, status, quantity, cost];
}

extension on String {
  ItemStatus toItemStatus() {
    if (this == 'pending') {
      return ItemStatus.PENDING;
    }
    return ItemStatus.PURCHASED;
  }
}
