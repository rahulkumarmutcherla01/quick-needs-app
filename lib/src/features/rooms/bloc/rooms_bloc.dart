import 'package:bloc/bloc.dart';
import 'package.equatable/equatable.dart';
import 'package:project/src/features/rooms/data/models/room.dart';
import 'package:project/src/features/rooms/data/repositories/rooms_repository.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final RoomsRepository _roomsRepository;

  RoomsBloc({required RoomsRepository roomsRepository})
      : _roomsRepository = roomsRepository,
        super(RoomsInitial()) {
    on<RoomsFetchRequested>(_onFetchRequested);
    on<RoomCreateRequested>(_onCreateRequested);
  }

  Future<void> _onFetchRequested(
    RoomsFetchRequested event,
    Emitter<RoomsState> emit,
  ) async {
    emit(RoomsLoading());
    try {
      final rooms = await _roomsRepository.getRooms();
      emit(RoomsLoadSuccess(rooms: rooms));
    } catch (e) {
      emit(RoomsError(message: e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    RoomCreateRequested event,
    Emitter<RoomsState> emit,
  ) async {
    try {
      await _roomsRepository.createRoom(event.name);
      add(RoomsFetchRequested());
    } catch (e) {
      emit(RoomsError(message: e.toString()));
    }
  }
}
