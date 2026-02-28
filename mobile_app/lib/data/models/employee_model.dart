class Employee {
  final int id;
  final String employeeId;
  final String name;
  final String department;
  final String position;
  final double salary;
  final String status;
  final String joinDate;
  final String phone;
  final String email;
  final double attendance;
  final String avatar;

  Employee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.department,
    required this.position,
    required this.salary,
    required this.status,
    required this.joinDate,
    required this.phone,
    required this.email,
    required this.attendance,
    required this.avatar,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      employeeId: json['employeeId'] ?? json['employee_id'],
      name: json['name'],
      department: json['department'],
      position: json['position'],
      salary: (json['salary'] as num).toDouble(),
      status: json['status'],
      joinDate: json['joinDate'] ?? json['join_date'],
      phone: json['phone'],
      email: json['email'],
      attendance: (json['attendance'] as num).toDouble(),
      avatar: json['avatar'],
    );
  }
}
