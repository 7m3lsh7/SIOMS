import 'package:mobile_app/data/datasources/api_client.dart';
import 'package:mobile_app/data/models/payroll_model.dart';
import 'package:mobile_app/domain/repositories/payroll_repository.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final ApiClient _apiClient;

  PayrollRepositoryImpl(this._apiClient);

  @override
  Future<List<PayrollRecord>> getPayrollRecords({String? month, String? department, String? status}) async {
    final response = await _apiClient.get('/payroll', queryParameters: {
      if (month != null) 'month': month,
      if (department != null) 'department': department,
      if (status != null) 'status': status,
    });

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => PayrollRecord.fromJson(json)).toList();
    }
    return [];
  }
}
