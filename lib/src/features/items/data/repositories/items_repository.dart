import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/features/items/data/models/item.dart';

class ItemsRepository {
  final ApiService _apiService;

  ItemsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Item>> getItems(String roomId) async {
    final response = await _apiService.get('items/rooms/$roomId/items',
        requireAuth: true);
    return (response as List).map((data) => Item.fromJson(data)).toList();
  }

  Future<Item> createItem(String roomId, String name, int quantity) async {
    final response = await _apiService.post(
      'items/rooms/$roomId/items',
      body: {'item_name': name, 'quantity': quantity},
      requireAuth: true,
    );
    return Item.fromJson(response);
  }

  Future<Item> updateItem(
    String itemId, {
    ItemStatus? status,
    double? cost,
    int? quantity,
    String? name,
  }) async {
    final response = await _apiService.patch(
      'items/$itemId',
      body: {
        'status': status?.name.toLowerCase(),
        'cost': cost,
        'quantity': quantity,
        'item_name': name,
      },
      requireAuth: true,
    );
    return Item.fromJson(response);
  }

  Future<void> deleteItem(String itemId) async {
    await _apiService.delete('items/$itemId', requireAuth: true);
  }
}
