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

  @override
  Future<List<Map<String, dynamic>>> getMyLeaves() async {
    final response = await _apiClient.get('/hr/my-leaves');
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  @override
  Future<void> submitLeaveRequest(Map<String, dynamic> data) async {
    await _apiClient.post('/hr/my-leaves', data: data);
  }

  @override
  Future<void> createEmployee(Map<String, dynamic> data) async {
    await _apiClient.post('/employees', data: data);
  }

  @override
  Future<void> updateEmployee(int id, Map<String, dynamic> data) async {
    await _apiClient.put('/employees/$id', data: data);
  }

  @override
  Future<void> deleteEmployee(int id) async {
    await _apiClient.delete('/employees/$id');
  }
}
