import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/src/core/storage/token_service.dart';

class ApiService {
  // Using a specific LAN IP for local development. This allows testing on physical devices.
  // Make sure the device and the server are on the same Wi-Fi network.
  // TODO: Replace with your actual production API base URL.
  final String _baseUrl = 'http://192.168.1.14:8000/api/v1';
  final http.Client _client;
  final TokenService _tokenService;

  ApiService({http.Client? client, TokenService? tokenService})
      : _client = client ?? http.Client(),
        _tokenService = tokenService ?? TokenService();

  Future<dynamic> get(String endpoint, {bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {dynamic body, bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, {dynamic body, bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (requireAuth) {
      final token = await _tokenService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      // TODO: Implement more robust error handling
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
