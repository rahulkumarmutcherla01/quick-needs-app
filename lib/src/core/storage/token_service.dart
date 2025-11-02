import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _familyIdKey = 'family_id';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveFamilyId(String familyId) async {
    await _storage.write(key: _familyIdKey, value: familyId);
  }

  Future<String?> getFamilyId() async {
    return await _storage.read(key: _familyIdKey);
  }

  Future<void> deleteFamilyId() async {
    await _storage.delete(key: _familyIdKey);
  }
}
