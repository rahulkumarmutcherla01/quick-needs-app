part of 'rooms_bloc.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object> get props => [];
}

class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsLoadSuccess extends RoomsState {
  final List<Room> rooms;

  const RoomsLoadSuccess({required this.rooms});

  @override
  List<Object> get props => [rooms];
}

class RoomsError extends RoomsState {
  final String message;

  const RoomsError({required this.message});

  @override
  List<Object> get props => [message];
}
