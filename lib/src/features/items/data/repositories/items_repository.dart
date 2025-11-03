import 'package:project/src/core/api/api_service.dart';
import 'package:project/src/features/items/data/models/item.dart';

class ItemsRepository {
  final ApiService _apiService;

  ItemsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Item>> getItems(String roomId) async {
    final response = await _apiService.get('rooms/$roomId/items', requireAuth: true);
    return (response as List).map((data) => Item.fromJson(data)).toList();
  }

  Future<Item> createItem(String roomId, String name) async {
    final response = await _apiService.post(
      'rooms/$roomId/items',
      body: {'name': name},
      requireAuth: true,
    );
    return Item.fromJson(response);
  }

  Future<Item> updateItem(String itemId, {bool? isPurchased, double? cost}) async {
    final response = await _apiService.patch(
      'items/$itemId',
      body: {
        'is_purchased': isPurchased,
        'cost': cost,
      },
      requireAuth: true,
    );
    return Item.fromJson(response);
  }
}
