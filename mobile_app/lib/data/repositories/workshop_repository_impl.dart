import 'package:mobile_app/data/datasources/api_client.dart';
import 'package:mobile_app/data/models/workshop_model.dart';
import 'package:mobile_app/domain/repositories/workshop_repository.dart';

class WorkshopRepositoryImpl implements WorkshopRepository {
  final ApiClient _apiClient;

  WorkshopRepositoryImpl(this._apiClient);

  @override
  Future<List<Equipment>> getEquipment() async {
    final response = await _apiClient.get('/workshop/equipment');
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => Equipment.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<List<Asset>> getAssets() async {
    final response = await _apiClient.get('/assets');
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => Asset.fromJson(json)).toList();
    }
    return [];
  }
}
