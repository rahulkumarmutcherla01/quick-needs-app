part of 'items_bloc.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class ItemsFetchRequested extends ItemsEvent {
  final String roomId;

  const ItemsFetchRequested({required this.roomId});

  @override
  List<Object> get props => [roomId];
}

class ItemAddRequested extends ItemsEvent {
  final String roomId;
  final String itemName;
  final int quantity;
  final double? cost;

  const ItemAddRequested({
    required this.roomId,
    required this.itemName,
    required this.quantity,
    this.cost,
  });

  @override
  List<Object> get props => [roomId, itemName, quantity];
}

class ItemUpdateRequested extends ItemsEvent {
  final String roomId;
  final String itemId;
  final ItemStatus status;
  final double? cost;

  const ItemUpdateRequested({
    required this.roomId,
    required this.itemId,
    required this.status,
    this.cost,
  });

  @override
  List<Object> get props => [roomId, itemId, status];
}
