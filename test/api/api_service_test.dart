import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package.mockito/annotations.dart';
import 'package.mockito/mockito.dart';
import 'package:project/src/api/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    test('get returns data when the response code is 200', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('{"data": "test"}', 200),
      );

      final result = await apiService.get('test');

      expect(result, {'data': 'test'});
    });

    test('get throws an exception when the response code is not 200', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(() => apiService.get('test'), throwsException);
    });
  });
}
