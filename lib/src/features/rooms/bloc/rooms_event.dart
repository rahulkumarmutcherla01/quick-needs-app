part of 'rooms_bloc.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object> get props => [];
}

class RoomsFetchRequested extends RoomsEvent {
  final String familyId;

  const RoomsFetchRequested({required this.familyId});

  @override
  List<Object> get props => [familyId];
}

class RoomCreateRequested extends RoomsEvent {
  final String name;
  final String familyId;
  final String icon;

  const RoomCreateRequested({required this.name, required this.familyId, required this.icon});

  @override
  List<Object> get props => [name, familyId, icon];
}
