part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthAppStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String firstName;
  final String? lastName;
  final String email;
  final String password;
  final String? phoneNumber;

  const AuthRegisterRequested({
    required this.firstName,
    this.lastName,
    required this.email,
    required this.password,
    this.phoneNumber,
  });

  @override
  List<Object> get props => [firstName, email, password];
}

class AuthLogoutRequested extends AuthEvent {}
