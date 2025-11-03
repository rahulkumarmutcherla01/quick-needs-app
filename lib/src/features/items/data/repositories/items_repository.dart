import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/core/storage/token_service.dart';
import 'package:project/src/features/items/data/models/item.dart';
import 'package:project/src/features/items/data/models/room.dart';

class ItemsRepository {
  final ApiService _apiService;
  final TokenService _tokenService;

  ItemsRepository({ApiService? apiService, TokenService? tokenService})
      : _apiService = apiService ?? ApiService(),
        _tokenService = tokenService ?? TokenService();

  Future<List<Room>> getRooms() async {
    final familyId = await _tokenService.getFamilyId();
    if (familyId == null) {
      throw Exception('No family ID found');
    }
    final response = await _apiService.get('items/rooms?family_id=$familyId', requireAuth: true);
    return (response as List).map((room) => Room.fromJson(room)).toList();
  }

  Future<Room> addRoom({
    required String roomName,
    required String roomIcon,
  }) async {
    final familyId = await _tokenService.getFamilyId();
    if (familyId == null) {
      throw Exception('No family ID found');
    }
    final response = await _apiService.post(
      'items/rooms',
      body: {
        'room_name': roomName,
        'room_icon': roomIcon,
        'family_id': familyId,
      },
      requireAuth: true,
    );
    return Room.fromJson(response);
  }

  Future<List<Item>> getItemsInRoom(String roomId) async {
    final response = await _apiService.get('items/rooms/$roomId/items', requireAuth: true);
    return (response as List).map((item) => Item.fromJson(item)).toList();
  }

  Future<Item> addItemToRoom({
    required String roomId,
    required String itemName,
    required int quantity,
    double? cost,
  }) async {
    final response = await _apiService.post(
      'items/rooms/$roomId/items',
      body: {
        'item_name': itemName,
        'quantity': quantity,
        'cost': cost,
      },
      requireAuth: true,
    );
    return Item.fromJson(response);
  }

  Future<void> deleteRoom(String roomId) async {
    await _apiService.delete('items/rooms/$roomId', requireAuth: true);
  }

  Future<Item> updateItem({
    required String itemId,
    required ItemStatus status,
    double? cost,
  }) async {
    final response = await _apiService.put(
      'items/$itemId',
      body: {
        'status': status.toString().split('.').last,
        'cost': cost,
      },
      requireAuth: true,
    );
    return Item.fromJson(response);
  }
}
