import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/features/items/data/models/room.dart';
import 'package:project/src/features/items/data/repositories/items_repository.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final ItemsRepository _itemsRepository;

  RoomsBloc({ItemsRepository? itemsRepository})
      : _itemsRepository = itemsRepository ?? ItemsRepository(),
        super(RoomsInitial()) {
    on<RoomsFetchRequested>(_onFetchRequested);
    on<RoomAddRequested>(_onAddRequested);
    on<RoomDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onFetchRequested(
    RoomsFetchRequested event,
    Emitter<RoomsState> emit,
  ) async {
    emit(RoomsLoading());
    try {
      final rooms = await _itemsRepository.getRooms();
      emit(RoomsLoadSuccess(rooms: rooms));
    } catch (e) {
      emit(RoomsError(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(
    RoomAddRequested event,
    Emitter<RoomsState> emit,
  ) async {
    try {
      await _itemsRepository.addRoom(
        roomName: event.roomName,
        roomIcon: event.roomIcon,
      );
      add(RoomsFetchRequested());
    } catch (e) {
      emit(RoomsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    RoomDeleteRequested event,
    Emitter<RoomsState> emit,
  ) async {
    try {
      await _itemsRepository.deleteRoom(event.roomId);
      add(RoomsFetchRequested());
    } catch (e) {
      emit(RoomsError(message: e.toString()));
    }
  }
}
