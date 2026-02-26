import 'package:mobile_app/data/models/payroll_model.dart';

abstract class PayrollRepository {
  Future<List<PayrollRecord>> getPayrollRecords({String? month, String? department, String? status});
}
