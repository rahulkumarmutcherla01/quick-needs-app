import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/features/auth/data/models/user.dart';
import 'package:project/src/features/auth/data/repositories/auth_repository.dart';
import 'package:project/src/features/family/data/repositories/family_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FamilyRepository _familyRepository;

  AuthBloc({AuthRepository? authRepository, FamilyRepository? familyRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        _familyRepository = familyRepository ?? FamilyRepository(),
        super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        final hasFamily = await _familyRepository.checkUserFamilyStatus();
        if (hasFamily) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthAuthenticatedWithoutFamily(user: user));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.email, event.password);
      final hasFamily = await _familyRepository.checkUserFamilyStatus();
      if (hasFamily) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthAuthenticatedWithoutFamily(user: user));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
      );
      emit(AuthRegistrationSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
