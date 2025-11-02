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

  Future<bool> checkUserFamilyStatus() async {
    final familyId = await _tokenService.getFamilyId();
    if (familyId == null) {
      return false;
    }

    try {
      // This endpoint will confirm if the user is still a member of the family.
      // If the user was removed, the backend should return a 403 Forbidden error.
      await _apiService.get('families/$familyId', requireAuth: true);
      return true;
    } catch (e) {
      // If the API call fails (e.g., 403 or 404), it means the user is no longer in that family.
      await _tokenService.deleteFamilyId();
      return false;
    }
  }

  Future<Family> getFamilyDetails() async {
    final familyId = await _tokenService.getFamilyId();
    if (familyId == null) {
      throw Exception('No family ID found');
    }
    final response = await _apiService.get('families/$familyId', requireAuth: true);
    return Family.fromJson(response);
  }
}
