import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/auth/data/models/user.dart';
import 'package:project/src/features/auth/data/repositories/auth_repository.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthAuthenticated] when user is already logged in',
      build: () {
        when(mockAuthRepository.getCurrentUser()).thenAnswer(
          (_) async => const User(id: '1', email: 'test@test.com', firstName: 'Test'),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthAppStarted()),
      expect: () => [isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when user is not logged in',
      build: () {
        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthAppStarted()),
      expect: () => [isA<AuthUnauthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(mockAuthRepository.login(any, any)).thenAnswer(
          (_) async => const User(id: '1', email: 'test@test.com', firstName: 'Test'),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(email: 'test@test.com', password: 'password')),
      expect: () => [AuthLoading(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockAuthRepository.login(any, any)).thenThrow(Exception('Login failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(email: 'test@test.com', password: 'password')),
      expect: () => [AuthLoading(), isA<AuthError>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when logout is successful',
      build: () {
        when(mockAuthRepository.logout()).thenAnswer((_) async => {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [AuthLoading(), isA<AuthUnauthenticated>()],
    );
  });
}
