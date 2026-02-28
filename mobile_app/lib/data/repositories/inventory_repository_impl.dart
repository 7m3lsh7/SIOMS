import 'package:mobile_app/data/datasources/api_client.dart';
import 'package:mobile_app/data/models/inventory_model.dart';
import 'package:mobile_app/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final ApiClient _apiClient;

  InventoryRepositoryImpl(this._apiClient);

  @override
  Future<List<InventoryItem>> getInventoryItems({String? category, String? search, bool? lowStock}) async {
    final response = await _apiClient.get('/inventory', queryParameters: {
      if (category != null) 'category': category,
      if (search != null) 'search': search,
      if (lowStock != null) 'lowStock': lowStock,
    });

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => InventoryItem.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<List<Supplier>> getSuppliers({String? category, String? status, String? search}) async {
    final response = await _apiClient.get('/suppliers', queryParameters: {
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (search != null) 'search': search,
    });

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => Supplier.fromJson(json)).toList();
    }
    return [];
  }
}
