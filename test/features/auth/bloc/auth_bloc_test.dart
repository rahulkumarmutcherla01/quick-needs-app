import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/core/storage/token_service.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/auth/data/models/user.dart';
import 'package:project/src/features/auth/data/repositories/auth_repository.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository, TokenService])
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;
    late MockTokenService mockTokenService;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockTokenService = MockTokenService();
      authBloc = AuthBloc(
        authRepository: mockAuthRepository,
        tokenService: mockTokenService,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthAuthenticated] when user is already logged in and has a family',
      build: () {
        when(mockAuthRepository.getCurrentUser()).thenAnswer(
          (_) async => const User(id: '1', email: 'test@test.com', firstName: 'Test'),
        );
        when(mockTokenService.getFamilyId()).thenAnswer((_) async => 'family1');
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthAppStarted()),
      expect: () => [isA<AuthAuthenticated>()],
    );
  });
}
