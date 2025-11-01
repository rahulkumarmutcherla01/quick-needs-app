import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/core/storage/token_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client, TokenService])
void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;
    late MockTokenService mockTokenService;

    setUp(() {
      mockClient = MockClient();
      mockTokenService = MockTokenService();
      apiService = ApiService(client: mockClient, tokenService: mockTokenService);
    });

    test('get returns data when the response code is 200', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('{"data": "test"}', 200),
      );

      final result = await apiService.get('test');

      expect(result, {'data': 'test'});
    });

    test('get includes auth token when requireAuth is true', () async {
      when(mockTokenService.getToken()).thenAnswer((_) async => 'test_token');
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('{"data": "test"}', 200),
      );

      await apiService.get('test', requireAuth: true);

      verify(mockClient.get(
        any,
        headers: containsPair('Authorization', 'Bearer test_token'),
      ));
    });

    test('get throws an exception when the response code is not 200', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(() => apiService.get('test'), throwsException);
    });
  });
}
