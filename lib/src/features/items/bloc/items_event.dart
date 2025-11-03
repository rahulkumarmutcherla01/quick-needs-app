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

  const ItemCreateRequested({required this.roomId, required this.name});

  @override
  List<Object> get props => [roomId, name];
}

class ItemUpdateRequested extends ItemsEvent {
  final String roomId;
  final String itemId;
  final bool? isPurchased;
  final double? cost;

  const ItemUpdateRequested({
    required this.roomId,
    required this.itemId,
    this.isPurchased,
    this.cost,
  });

  @override
  List<Object> get props => [roomId, itemId, isPurchased ?? '', cost ?? ''];
}
