import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/models/user.dart';
import 'package:project/src/api/api_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc({required this.apiService}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await apiService.post('auth/login', body: {
        'email': event.email,
        'password': event.password,
      });
      final user = User.fromJson(response['user']);
      // TODO: Securely store the accessToken
      emit(AuthAuthenticated(user: user));
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
      final response = await apiService.post('auth/register', body: {
        'first_name': event.firstName,
        'last_name': event.lastName,
        'email': event.email,
        'password': event.password,
      });
      final user = User.fromJson(response);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // TODO: Clear the stored accessToken
    emit(AuthUnauthenticated());
  }
}
