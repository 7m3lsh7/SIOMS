import 'package:mobile_app/data/models/workshop_model.dart';

abstract class WorkshopRepository {
  Future<List<Equipment>> getEquipment();
  Future<List<Asset>> getAssets();
}
