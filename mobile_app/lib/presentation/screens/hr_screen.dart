import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/presentation/providers/auth_provider.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/presentation/widgets/glass_container.dart';
import 'package:mobile_app/presentation/widgets/glass_button.dart';

class HRScreen extends ConsumerWidget {
  const HRScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personnel'),
        actions: [
          IconButton(
            onPressed: () => _showAddEmployee(context, ref),
            icon: const Icon(Icons.person_add_alt_1_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: employeesAsync.when(
        data: (employees) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GlassContainer(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(employee.avatar),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(
                            '${employee.position} · ${employee.department}',
                            style: const TextStyle(color: AppColors.textSub, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        _buildStatusBadge(employee.status),
                        IconButton(
                          onPressed: () => _deleteEmployee(context, ref, employee.id),
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showAddEmployee(BuildContext context, WidgetRef ref) {
    // Show premium modal for adding employee...
  }

  void _deleteEmployee(BuildContext context, WidgetRef ref, int id) async {
    try {
      await ref.read(employeeRepositoryProvider).deleteEmployee(id);
      ref.invalidate(employeesProvider);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee deleted.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'Active';
    final color = isActive ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
