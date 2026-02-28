import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/hr_screen.dart';
import '../screens/payroll_screen.dart';
import '../screens/canteen_screen.dart';
import '../screens/inventory_screen.dart';
import '../screens/suppliers_screen.dart';
import '../screens/workshop_screen.dart';
import '../screens/assets_screen.dart';
import '../screens/settings_screen.dart';
import '../../core/theme/app_colors.dart';
import 'glass_container.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AttendanceScreen(),
    const HRScreen(),
    const PayrollScreen(),
    const CanteenScreen(),
    const InventoryScreen(),
    const SuppliersScreen(),
    const WorkshopScreen(),
    const AssetsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Crucial for floating bottom bar
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GlassContainer(
            borderRadius: 30,
            blur: 20,
            opacity: isDark ? 0.08 : 0.15,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.dashboard_rounded, 'Home'),
                    _buildNavItem(1, Icons.assignment_ind_rounded, 'Attend'),
                    _buildNavItem(2, Icons.people_alt_rounded, 'HR'),
                    _buildNavItem(3, Icons.payments_rounded, 'Pay'),
                    _buildNavItem(4, Icons.restaurant_rounded, 'POS'),
                    _buildNavItem(5, Icons.inventory_2_rounded, 'Stock'),
                    _buildNavItem(6, Icons.local_shipping_rounded, 'Vend'),
                    _buildNavItem(7, Icons.build_rounded, 'Work'),
                    _buildNavItem(8, Icons.admin_panel_settings_rounded, 'Assets'),
                    _buildNavItem(9, Icons.settings_rounded, 'User'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.textSub;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
