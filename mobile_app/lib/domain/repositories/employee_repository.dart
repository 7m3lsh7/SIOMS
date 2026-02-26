import 'package:mobile_app/data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees({String? search, String? department});
}
