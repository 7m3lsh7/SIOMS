import 'package:mobile_app/data/datasources/api_client.dart';
import 'package:mobile_app/data/models/attendance_model.dart';
import 'package:mobile_app/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final ApiClient _apiClient;

  AttendanceRepositoryImpl(this._apiClient);

  @override
  Future<List<AttendanceRecord>> getAttendance({String? date}) async {
    final response = await _apiClient.get('/attendance', queryParameters: {
      if (date != null) 'date': date,
    });
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((json) => AttendanceRecord.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> checkIn(String employeeId) async {
    await _apiClient.post('/attendance/check-in', data: {'employeeId': employeeId});
  }

  @override
  Future<void> checkOut(int recordId) async {
    await _apiClient.post('/attendance/check-out/$recordId');
  }

  @override
  Future<Map<String, dynamic>> getMyToday() async {
    final response = await _apiClient.get('/attendance/my-today');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getMyQr() async {
    final response = await _apiClient.get('/attendance/my-qr');
    return response.data;
  }

  @override
  Future<void> qrCheckIn(String qrData, {double? lat, double? lng}) async {
    await _apiClient.post('/attendance/qr-checkin', data: {
      'qrData': qrData,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
  }

  @override
  Future<void> myCheckOut() async {
    await _apiClient.post('/attendance/my-checkout');
  }

  @override
  Future<void> markLateNow() async {
    await _apiClient.post('/attendance/mark-late-now');
  }

  @override
  Future<void> processDay() async {
    await _apiClient.post('/attendance/process-day');
  }
}
