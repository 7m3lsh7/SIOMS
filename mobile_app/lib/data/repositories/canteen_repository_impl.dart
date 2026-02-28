import 'package:mobile_app/data/datasources/api_client.dart';
import 'package:mobile_app/data/models/canteen_model.dart';
import 'package:mobile_app/domain/repositories/canteen_repository.dart';

class CanteenRepositoryImpl implements CanteenRepository {
  final ApiClient _apiClient;

  CanteenRepositoryImpl(this._apiClient);

  @override
  Future<List<CanteenProduct>> getProducts() async {
    final response = await _apiClient.get('/canteen/products');
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => CanteenProduct.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> checkout(List<CartItem> items) async {
    await _apiClient.post('/canteen/checkout', data: {
      'items': items.map((i) => {'id': i.product.id, 'qty': i.quantity}).toList(),
    });
  }

  @override
  Future<void> createProduct(Map<String, dynamic> data) async {
    await _apiClient.post('/canteen/products', data: data);
  }

  @override
  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    await _apiClient.put('/canteen/products/$id', data: data);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await _apiClient.delete('/canteen/products/$id');
  }
}
