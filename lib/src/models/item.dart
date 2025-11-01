enum ItemStatus { NEEDED, IN_CART, PURCHASED }

class Item {
  final String id;
  final String roomId;
  final String itemName;
  final ItemStatus status;
  final String addedByUserId;
  final String? purchasedByUserId;
  final int quantity;
  final double cost;
  final DateTime? lastPurchasedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.roomId,
    required this.itemName,
    required this.status,
    required this.addedByUserId,
    this.purchasedByUserId,
    required this.quantity,
    required this.cost,
    this.lastPurchasedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      roomId: json['room_id'],
      itemName: json['item_name'],
      status: ItemStatus.values.byName(json['status']),
      addedByUserId: json['added_by_user_id'],
      purchasedByUserId: json['purchased_by_user_id'],
      quantity: json['quantity'],
      cost: json['cost'].toDouble(),
      lastPurchasedAt: json['last_purchased_at'] != null
          ? DateTime.parse(json['last_purchased_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
