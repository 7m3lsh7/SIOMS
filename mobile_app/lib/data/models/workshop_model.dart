class Equipment {
  final int id;
  final String name;
  final String model;
  final String status;
  final String department;
  final String lastMaintenance;
  final String nextMaintenance;
  final String condition;

  Equipment({
    required this.id,
    required this.name,
    required this.model,
    required this.status,
    required this.department,
    required this.lastMaintenance,
    required this.nextMaintenance,
    required this.condition,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      status: json['status'],
      department: json['department'],
      lastMaintenance: json['lastMaintenance'] ?? json['last_maintenance'],
      nextMaintenance: json['nextMaintenance'] ?? json['next_maintenance'],
      condition: json['condition'],
    );
  }
}

class Asset {
  final int id;
  final String assetId;
  final String name;
  final String assignedTo;
  final String employeeId;
  final String assignDate;
  final String? returnDate;
  final String status;
  final String condition;

  Asset({
    required this.id,
    required this.assetId,
    required this.name,
    required this.assignedTo,
    required this.employeeId,
    required this.assignDate,
    this.returnDate,
    required this.status,
    required this.condition,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      assetId: json['assetId'] ?? json['asset_id'],
      name: json['name'],
      assignedTo: json['assignedTo'] ?? json['assigned_to'],
      employeeId: json['employeeId'] ?? json['employee_id'],
      assignDate: json['assignDate'] ?? json['assign_date'],
      returnDate: json['returnDate'] ?? json['return_date'],
      status: json['status'],
      condition: json['condition'],
    );
  }
}
