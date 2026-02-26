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
}
