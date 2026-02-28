import 'package:mobile_app/data/models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceRecord>> getAttendance({String? date});
  Future<void> checkIn(String employeeId);
  Future<void> checkOut(int recordId);
  Future<Map<String, dynamic>> getMyToday();
  Future<Map<String, dynamic>> getMyQr();
  Future<void> qrCheckIn(String qrData, {double? lat, double? lng});
  Future<void> myCheckOut();
}
