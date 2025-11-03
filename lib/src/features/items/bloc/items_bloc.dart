import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/features/items/data/models/item.dart';
import 'package:project/src/features/items/data/repositories/items_repository.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemsRepository _itemsRepository;

  ItemsBloc({ItemsRepository? itemsRepository})
      : _itemsRepository = itemsRepository ?? ItemsRepository(),
        super(ItemsInitial()) {
    on<ItemsFetchRequested>(_onFetchRequested);
    on<ItemAddRequested>(_onAddRequested);
    on<ItemUpdateRequested>(_onUpdateRequested);
  }

  Future<void> _onFetchRequested(
    ItemsFetchRequested event,
    Emitter<ItemsState> emit,
  ) async {
    emit(ItemsLoading());
    try {
      final items = await _itemsRepository.getItemsInRoom(event.roomId);
      emit(ItemsLoadSuccess(items: items));
    } catch (e) {
      emit(ItemsError(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(
    ItemAddRequested event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      await _itemsRepository.addItemToRoom(
        roomId: event.roomId,
        itemName: event.itemName,
        quantity: event.quantity,
        cost: event.cost,
      );
      add(ItemsFetchRequested(roomId: event.roomId));
    } catch (e) {
      emit(ItemsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    ItemUpdateRequested event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      await _itemsRepository.updateItem(
        itemId: event.itemId,
        status: event.status,
        cost: event.cost,
      );
      add(ItemsFetchRequested(roomId: event.roomId));
    } catch (e) {
      emit(ItemsError(message: e.toString()));
    }
  }
}
