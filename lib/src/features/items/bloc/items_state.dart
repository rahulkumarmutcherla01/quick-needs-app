part of 'items_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:project/src/features/items/data/models/item.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoadSuccess extends ItemsState {
  final List<Item> items;

  const ItemsLoadSuccess({required this.items});

  @override
  List<Object> get props => [items];
}

class ItemsError extends ItemsState {
  final String message;

  const ItemsError({required this.message});

  @override
  List<Object> get props => [message];
}
