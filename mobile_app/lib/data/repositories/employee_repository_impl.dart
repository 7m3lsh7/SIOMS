import 'package:mobile_app/data/datasources/api_client.dart';
import 'package:mobile_app/data/models/employee_model.dart';
import 'package:mobile_app/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final ApiClient _apiClient;

  EmployeeRepositoryImpl(this._apiClient);

  @override
  Future<List<Employee>> getEmployees({String? search, String? department}) async {
    final response = await _apiClient.get('/employees', queryParameters: {
      if (search != null) 'search': search,
      if (department != null) 'department': department,
    });

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => Employee.fromJson(json)).toList();
    }
    return [];
  }
}
