import 'package:mobile_app/data/models/inventory_model.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getInventoryItems({String? category, String? search, bool? lowStock});
  Future<List<Supplier>> getSuppliers({String? category, String? status, String? search});
}
