import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/core/storage/token_service.dart';
import 'package:project/src/features/family/data/models/family.dart';

class FamilyRepository {
  final ApiService _apiService;
  final TokenService _tokenService;

  FamilyRepository({ApiService? apiService, TokenService? tokenService})
      : _apiService = apiService ?? ApiService(),
        _tokenService = tokenService ?? TokenService();

  Future<Family> createFamily({
    required String familyName,
    String? familySurname,
    String? city,
  }) async {
    final response = await _apiService.post(
      'families/create',
      body: {
        'family_name': familyName,
        'family_surname': familySurname,
        'city': city,
      },
      requireAuth: true,
    );
    final family = Family.fromJson(response);
    await _tokenService.saveFamilyId(family.id);
    return family;
  }

  Future<void> joinFamily(String familyCode) async {
    final response = await _apiService.post(
      'families/join',
      body: {'family_code': familyCode},
      requireAuth: true,
    );
    await _tokenService.saveFamilyId(response['familyId']);
  }

  // TODO: Create a GET /api/v1/families/me endpoint in the backend that returns the user's family.
  Future<Family?> getMyFamily() async {
    try {
      final response = await _apiService.get('families/me', requireAuth: true);
      if (response == null) {
        await _tokenService.deleteFamilyId();
        return null;
      }
      final family = Family.fromJson(response);
      await _tokenService.saveFamilyId(family.id);
      return family;
    } catch (e) {
      // If the user has no family, the backend might return a 404, which the ApiService will throw as an exception.
      await _tokenService.deleteFamilyId();
      return null;
    }
  }
}
