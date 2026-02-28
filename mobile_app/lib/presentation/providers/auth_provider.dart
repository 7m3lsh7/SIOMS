import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/data/datasources/api_client.dart';
import 'package:mobile_app/data/repositories/auth_repository_impl.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/data/models/user_model.dart';
import 'package:mobile_app/domain/repositories/employee_repository.dart';
import 'package:mobile_app/data/repositories/employee_repository_impl.dart';
import 'package:mobile_app/data/models/employee_model.dart';
import 'package:mobile_app/domain/repositories/payroll_repository.dart';
import 'package:mobile_app/data/repositories/payroll_repository_impl.dart';
import 'package:mobile_app/data/models/payroll_model.dart';
import 'package:mobile_app/domain/repositories/inventory_repository.dart';
import 'package:mobile_app/data/repositories/inventory_repository_impl.dart';
import 'package:mobile_app/data/models/inventory_model.dart';
import 'package:mobile_app/domain/repositories/canteen_repository.dart';
import 'package:mobile_app/data/repositories/canteen_repository_impl.dart';
import 'package:mobile_app/data/models/canteen_model.dart';
import 'package:mobile_app/domain/repositories/workshop_repository.dart';
import 'package:mobile_app/data/repositories/workshop_repository_impl.dart';
import 'package:mobile_app/data/models/workshop_model.dart';
import 'package:mobile_app/domain/repositories/attendance_repository.dart';
import 'package:mobile_app/data/repositories/attendance_repository_impl.dart';
import 'package:mobile_app/data/models/attendance_model.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AttendanceRepositoryImpl(apiClient);
});

final attendanceProvider = FutureProvider.autoDispose<List<AttendanceRecord>>((ref) async {
  return ref.watch(attendanceRepositoryProvider).getAttendance();
});

final workshopRepositoryProvider = Provider<WorkshopRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkshopRepositoryImpl(apiClient);
});

final equipmentProvider = FutureProvider.autoDispose<List<Equipment>>((ref) async {
  return ref.watch(workshopRepositoryProvider).getEquipment();
});

final assetsProvider = FutureProvider.autoDispose<List<Asset>>((ref) async {
  return ref.watch(workshopRepositoryProvider).getAssets();
});

final canteenRepositoryProvider = Provider<CanteenRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CanteenRepositoryImpl(apiClient);
});

final canteenProductsProvider = FutureProvider.autoDispose<List<CanteenProduct>>((ref) async {
  return ref.watch(canteenRepositoryProvider).getProducts();
});

final cartProvider = StateProvider<List<CartItem>>((ref) => []);

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return InventoryRepositoryImpl(apiClient);
});

final inventoryProvider = FutureProvider.autoDispose<List<InventoryItem>>((ref) async {
  return ref.watch(inventoryRepositoryProvider).getInventoryItems();
});

final suppliersProvider = FutureProvider.autoDispose<List<Supplier>>((ref) async {
  return ref.watch(inventoryRepositoryProvider).getSuppliers();
});

final payrollRepositoryProvider = Provider<PayrollRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PayrollRepositoryImpl(apiClient);
});

final payrollProvider = FutureProvider.autoDispose<List<PayrollRecord>>((ref) async {
  return ref.watch(payrollRepositoryProvider).getPayrollRecords();
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EmployeeRepositoryImpl(apiClient);
});

final employeesProvider = FutureProvider.autoDispose<List<Employee>>((ref) async {
  return ref.watch(employeeRepositoryProvider).getEmployees();
});

final dioProvider = Provider((ref) => Dio());
final storageProvider = Provider((ref) => const FlutterSecureStorage());

final apiClientProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return ApiClient(dio, storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(storageProvider);
  return AuthRepositoryImpl(apiClient, storage);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    final user = await _repository.getCurrentUser();
    state = AuthState(user: user, isLoading: false);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(user: null);
  }
}
