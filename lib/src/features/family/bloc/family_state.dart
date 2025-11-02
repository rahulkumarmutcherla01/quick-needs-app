part of 'family_bloc.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object> get props => [];
}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyCreationSuccess extends FamilyState {
  final Family family;

  const FamilyCreationSuccess({required this.family});

  @override
  List<Object> get props => [family];
}

class FamilyJoinSuccess extends FamilyState {}

class FamilyError extends FamilyState {
  final String message;

  const FamilyError({required this.message});

  @override
  List<Object> get props => [message];
}
