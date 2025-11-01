import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Replace with your actual production API base URL
  final String _baseUrl = 'http://localhost:8000/api/v1';
  final http.Client client;

  ApiService({http.Client? client}) : this.client = client ?? http.Client();

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        ...?headers,
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        ...?headers,
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
