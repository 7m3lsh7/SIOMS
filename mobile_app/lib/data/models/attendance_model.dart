class AttendanceRecord {
  final int id;
  final String employeeId;
  final String employeeName;
  final String department;
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String status;

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      employeeId: json['employeeId'] ?? json['employee_id'],
      employeeName: json['employeeName'] ?? json['employee_name'],
      department: json['department'],
      date: json['date'],
      checkIn: json['checkIn'] ?? json['check_in'],
      checkOut: json['checkOut'] ?? json['check_out'],
      status: json['status'],
    );
  }
}
