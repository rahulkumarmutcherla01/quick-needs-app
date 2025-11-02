part of 'family_bloc.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object> get props => [];
}

class FamilyCreateRequested extends FamilyEvent {
  final String familyName;
  final String? familySurname;
  final String? city;

  const FamilyCreateRequested({
    required this.familyName,
    this.familySurname,
    this.city,
  });

  @override
  List<Object> get props => [familyName];
}

class FamilyJoinRequested extends FamilyEvent {
  final String familyCode;

  const FamilyJoinRequested({required this.familyCode});

  @override
  List<Object> get props => [familyCode];
}
