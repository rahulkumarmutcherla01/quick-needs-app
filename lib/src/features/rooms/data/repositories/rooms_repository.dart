import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/features/rooms/data/models/room.dart';

class RoomsRepository {
  final ApiService _apiService;

  RoomsRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  Future<List<Room>> getRooms(String familyId) async {
    final response = await _apiService.get('items/rooms?family_id=$familyId', requireAuth: true);
    return (response as List).map((data) => Room.fromJson(data)).toList();
  }

  Future<Room> createRoom(String name, String familyId, String icon) async {
    final response = await _apiService.post(
      'items/rooms',
      body: {'room_name': name, 'family_id': familyId, 'room_icon': icon},
      requireAuth: true,
    );
    return Room.fromJson(response);
  }
}
