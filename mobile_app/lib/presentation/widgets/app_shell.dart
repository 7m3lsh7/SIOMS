import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/employee_dashboard_screen.dart';
import '../widgets/bottom_nav_shell.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SIOMS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    if (authState.user == null) {
      return const LoginScreen();
    }

    // Role-based logic
    if (authState.user!.role == 'Employee') {
      return const EmployeeDashboardScreen();
    }

    return const BottomNavShell();
  }
}
