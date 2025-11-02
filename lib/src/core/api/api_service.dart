import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project/src/core/storage/token_service.dart';

class ApiService {
  // Using a specific LAN IP for local development. This allows testing on physical devices.
  // Make sure the device and the server are on the same Wi-Fi network.
  // TODO: Replace with your actual production API base URL.
  final String _baseUrl = 'http://192.168.1.14:8000/api/v1';
  final http.Client _client;
  final TokenService _tokenService;
  static const _timeoutDuration = Duration(seconds: 15);

  ApiService({http.Client? client, TokenService? tokenService})
      : _client = client ?? http.Client(),
        _tokenService = tokenService ?? TokenService();

  Future<dynamic> get(String endpoint, {bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: headers,
      ).timeout(_timeoutDuration);
      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('The connection timed out. Please try again.');
    } on SocketException {
      throw Exception('Could not connect to the server. Please check your internet connection.');
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body, bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(_timeoutDuration);
      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('The connection timed out. Please try again.');
    } on SocketException {
      throw Exception('Could not connect to the server. Please check your internet connection.');
    }
  }

  Future<dynamic> put(String endpoint, {dynamic body, bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(_timeoutDuration);
      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('The connection timed out. Please try again.');
    } on SocketException {
      throw Exception('Could not connect to the server. Please check your internet connection.');
    }
  }

  Future<dynamic> delete(String endpoint, {bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: headers,
      ).timeout(_timeoutDuration);
      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('The connection timed out. Please try again.');
    } on SocketException {
      throw Exception('Could not connect to the server. Please check your internet connection.');
    }
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
      try {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'An unknown error occurred';
        throw Exception('API Error (${response.statusCode}): $errorMessage');
      } catch (e) {
        throw Exception('API Error (${response.statusCode}): Could not parse error response.');
      }
    }
  }
}
