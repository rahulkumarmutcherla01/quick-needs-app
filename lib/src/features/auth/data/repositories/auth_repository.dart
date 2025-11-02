import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/core/storage/token_service.dart';
import 'package:project/src/features/auth/data/models/user.dart';

class AuthRepository {
  final ApiService _apiService;
  final TokenService _tokenService;

  AuthRepository({ApiService? apiService, TokenService? tokenService})
      : _apiService = apiService ?? ApiService(),
        _tokenService = tokenService ?? TokenService();

  Future<User> login(String email, String password) async {
    final response = await _apiService.post('auth/login', body: {
      'email': email,
      'password': password,
    });
    await _tokenService.saveToken(response['accessToken']);
    // The login response doesn't contain the familyId, so we don't save it here.
    // It will be fetched when the app starts.
    return User.fromJson(response['user']);
  }

  Future<User> register({
    required String firstName,
    String? lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final response = await _apiService.post('auth/register', body: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
    });
    // The register endpoint does not return a token, so the user will need to log in after registering.
    return User.fromJson(response);
  }

  Future<void> logout() async {
    await _tokenService.deleteToken();
    await _tokenService.deleteFamilyId();
  }

  Future<User?> getCurrentUser() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        return null;
      }
      final familyId = await _tokenService.getFamilyId();
      final response = await _apiService.get('auth/me', requireAuth: true);
      final user = User.fromJson(response);
      return User(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
        familyId: familyId,
      );
    } catch (e) {
      // If the token is invalid, the 'auth/me' call will fail.
      return null;
    }
  }
}
