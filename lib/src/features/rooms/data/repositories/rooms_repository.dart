import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/core/storage/token_service.dart';
import 'package:project/src/features/rooms/data/models/room.dart';

class RoomsRepository {
  final ApiService _apiService;
  final TokenService _tokenService;

  RoomsRepository({ApiService? apiService, TokenService? tokenService})
      : _apiService = apiService ?? ApiService(),
        _tokenService = tokenService ?? TokenService();

  Future<List<Room>> getRooms() async {
    final familyId = await _tokenService.getFamilyId();
    if (familyId == null) {
      throw Exception('No family ID found.');
    }
    final response = await _apiService.get('families/$familyId/rooms', requireAuth: true);
    return (response as List).map((data) => Room.fromJson(data)).toList();
  }

  Future<Room> createRoom(String name) async {
    final familyId = await _tokenService.getFamilyId();
    if (familyId == null) {
      throw Exception('No family ID found.');
    }
    final response = await _apiService.post(
      'families/$familyId/rooms',
      body: {'name': name},
      requireAuth: true,
    );
    return Room.fromJson(response);
  }
}
