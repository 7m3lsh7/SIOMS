import 'package:mobile_app/data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees({String? search, String? department});
  Future<void> createEmployee(Map<String, dynamic> data);
  Future<void> updateEmployee(int id, Map<String, dynamic> data);
  Future<void> deleteEmployee(int id);
  Future<List<Map<String, dynamic>>> getMyLeaves();
  Future<void> submitLeaveRequest(Map<String, dynamic> data);
}
