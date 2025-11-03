part of 'rooms_bloc.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object> get props => [];
}

class RoomsFetchRequested extends RoomsEvent {}

class RoomAddRequested extends RoomsEvent {
  final String roomName;
  final String roomIcon;

  const RoomAddRequested({required this.roomName, required this.roomIcon});

  @override
  List<Object> get props => [roomName, roomIcon];
}

class RoomDeleteRequested extends RoomsEvent {
  final String roomId;

  const RoomDeleteRequested({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
