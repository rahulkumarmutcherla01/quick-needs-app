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

class ItemCreateRequested extends ItemsEvent {
  final String roomId;
  final String name;
  final int quantity;

  const ItemCreateRequested(
      {required this.roomId, required this.name, required this.quantity});

  @override
  List<Object> get props => [roomId, name, quantity];
}

class ItemUpdateRequested extends ItemsEvent {
  final String roomId;
  final String itemId;
  final ItemStatus? status;
  final double? cost;
  final int? quantity;
  final String? name;

  const ItemUpdateRequested({
    required this.roomId,
    required this.itemId,
    this.status,
    this.cost,
    this.quantity,
    this.name,
  });

  @override
  List<Object> get props => [
        roomId,
        itemId,
        status ?? '',
        cost ?? '',
        quantity ?? '',
        name ?? ''
      ];
}
