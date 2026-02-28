import 'package:mobile_app/data/models/canteen_model.dart';

abstract class CanteenRepository {
  Future<List<CanteenProduct>> getProducts();
  Future<void> checkout(List<CartItem> items);
  Future<void> createProduct(Map<String, dynamic> data);
  Future<void> updateProduct(int id, Map<String, dynamic> data);
  Future<void> deleteProduct(int id);
}
