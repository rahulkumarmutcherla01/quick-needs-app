import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/features/auth/data/models/user.dart';
import 'package:project/src/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
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
        if (user.familyId != null) {
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
      // After login, we don't know if the user has a family yet.
      // We rely on the AuthAppStarted event to fetch the familyId.
      // For a smoother UX, we can check for familyId here as well.
      final userWithFamily = await _authRepository.getCurrentUser();
      if (userWithFamily != null) {
        if (userWithFamily.familyId != null) {
          emit(AuthAuthenticated(user: userWithFamily));
        } else {
          emit(AuthAuthenticatedWithoutFamily(user: userWithFamily));
        }
      } else {
        // This should not happen if login was successful.
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Login Failed: ${e.toString()}'));
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
      // After registration, the user is not automatically logged in.
      // Emit a success state to allow the UI to show a confirmation message.
      emit(AuthRegistrationSuccess());
    } catch (e) {
      emit(AuthError(message: 'Registration Failed: ${e.toString()}'));
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
