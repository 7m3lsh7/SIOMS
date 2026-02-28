import 'package:mobile_app/data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees({String? search, String? department});
  Future<List<Map<String, dynamic>>> getMyLeaves();
  Future<void> submitLeaveRequest(Map<String, dynamic> data);
}
