import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/api/api_service.dart';
import 'package:project/src/blocs/auth/auth_bloc.dart';
import 'package:project/src/models/user.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      authBloc = AuthBloc(apiService: mockApiService);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthLoginRequested is successful',
      build: () {
        when(mockApiService.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => {
            'user': {
              'id': '1',
              'email': 'test@test.com',
              'first_name': 'Test',
              'last_name': 'User',
              'phone_number': '1234567890',
              'created_at': '2023-01-01T00:00:00.000Z',
              'updated_at': '2023-01-01T00:00:00.000Z',
            }
          },
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(email: 'test@test.com', password: 'password'),
      ),
      expect: () => [
        AuthLoading(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when AuthLoginRequested fails',
      build: () {
        when(mockApiService.post(any, body: anyNamed('body')))
            .thenThrow(Exception('Failed to login'));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(email: 'test@test.com', password: 'password'),
      ),
      expect: () => [
        AuthLoading(),
        isA<AuthError>(),
      ],
    );
  });
}
