class PayrollRecord {
  final String employeeId;
  final String employeeName;
  final String department;
  final double baseSalary;
  final double overtime;
  final double bonus;
  final double penalties;
  final double taxDeduction;
  final double insuranceDeduction;
  final double netSalary;
  final String month;
  final String status;

  PayrollRecord({
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.baseSalary,
    required this.overtime,
    required this.bonus,
    required this.penalties,
    required this.taxDeduction,
    required this.insuranceDeduction,
    required this.netSalary,
    required this.month,
    required this.status,
  });

  factory PayrollRecord.fromJson(Map<String, dynamic> json) {
    return PayrollRecord(
      employeeId: json['employeeId'] ?? json['employee_id'],
      employeeName: json['employeeName'] ?? json['employee_name'],
      department: json['department'],
      baseSalary: (json['baseSalary'] ?? json['base_salary'] as num).toDouble(),
      overtime: (json['overtime'] as num).toDouble(),
      bonus: (json['bonus'] as num).toDouble(),
      penalties: (json['penalties'] as num).toDouble(),
      taxDeduction: (json['taxDeduction'] ?? json['tax_deduction'] as num).toDouble(),
      insuranceDeduction: (json['insuranceDeduction'] ?? json['insurance_deduction'] as num).toDouble(),
      netSalary: (json['netSalary'] ?? json['net_salary'] as num).toDouble(),
      month: json['month'],
      status: json['status'],
    );
  }
}
