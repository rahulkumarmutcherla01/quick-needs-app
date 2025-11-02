part of 'family_details_bloc.dart';

abstract class FamilyDetailsState extends Equatable {
  const FamilyDetailsState();

  @override
  List<Object> get props => [];
}

class FamilyDetailsInitial extends FamilyDetailsState {}

class FamilyDetailsLoading extends FamilyDetailsState {}

class FamilyDetailsLoadSuccess extends FamilyDetailsState {
  final Family family;

  const FamilyDetailsLoadSuccess({required this.family});

  @override
  List<Object> get props => [family];
}

class FamilyDetailsError extends FamilyDetailsState {
  final String message;

  const FamilyDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
