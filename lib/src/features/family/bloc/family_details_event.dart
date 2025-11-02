part of 'family_details_bloc.dart';

abstract class FamilyDetailsEvent extends Equatable {
  const FamilyDetailsEvent();

  @override
  List<Object> get props => [];
}

class FamilyDetailsFetchRequested extends FamilyDetailsEvent {}
