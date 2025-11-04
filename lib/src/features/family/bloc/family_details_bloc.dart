import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/features/family/data/models/family.dart';
import 'package/project/src/features/family/data/repositories/family_repository.dart';

part 'family_details_event.dart';
part 'family_details_state.dart';

class FamilyDetailsBloc extends Bloc<FamilyDetailsEvent, FamilyDetailsState> {
  final FamilyRepository _familyRepository;

  FamilyDetailsBloc({FamilyRepository? familyRepository})
      : _familyRepository = familyRepository ?? FamilyRepository(),
        super(FamilyDetailsInitial()) {
    on<FamilyDetailsFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    FamilyDetailsFetchRequested event,
    Emitter<FamilyDetailsState> emit,
  ) async {
    emit(FamilyDetailsLoading());
    try {
      final family = await _familyRepository.getFamilyDetails();
      emit(FamilyDetailsLoadSuccess(family: family));
    } catch (e) {
      emit(FamilyDetailsError(message: e.toString()));
    }
  }
}
