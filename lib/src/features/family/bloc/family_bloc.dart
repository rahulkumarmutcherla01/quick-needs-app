import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/features/family/data/models/family.dart';
import 'package:project/src/features/family/data/repositories/family_repository.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FamilyRepository _familyRepository;

  FamilyBloc({FamilyRepository? familyRepository})
      : _familyRepository = familyRepository ?? FamilyRepository(),
        super(FamilyInitial()) {
    on<FamilyCreateRequested>(_onCreateRequested);
    on<FamilyJoinRequested>(_onJoinRequested);
  }

  Future<void> _onCreateRequested(
    FamilyCreateRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      final family = await _familyRepository.createFamily(
        familyName: event.familyName,
        familySurname: event.familySurname,
        city: event.city,
      );
      emit(FamilyCreationSuccess(family: family));
    } catch (e) {
      emit(FamilyError(message: 'Failed to create family: ${e.toString()}'));
    }
  }

  Future<void> _onJoinRequested(
    FamilyJoinRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      await _familyRepository.joinFamily(event.familyCode);
      emit(FamilyJoinSuccess());
    } catch (e) {
      emit(FamilyError(message: 'Failed to join family: ${e.toString()}'));
    }
  }
}
