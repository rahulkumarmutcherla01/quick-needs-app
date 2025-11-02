import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/auth/data/models/user.dart';
import 'package/project/src/features/auth/data/repositories/auth_repository.dart';
import 'package:project/src/features/family/data/repositories/family_repository.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository, FamilyRepository])
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;
    late MockFamilyRepository mockFamilyRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockFamilyRepository = MockFamilyRepository();
      authBloc = AuthBloc(
        authRepository: mockAuthRepository,
        familyRepository: mockFamilyRepository,
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
        when(mockFamilyRepository.checkUserFamilyStatus()).thenAnswer((_) async => true);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthAppStarted()),
      expect: () => [isA<AuthAuthenticated>()],
    );
  });
}
