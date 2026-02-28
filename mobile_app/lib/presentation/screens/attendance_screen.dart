import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/presentation/providers/auth_provider.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/presentation/widgets/glass_container.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider);
    final user = ref.watch(authProvider).user;
    final isAdmin = user?.role == 'Admin' || user?.role == 'HR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logistics'),
        actions: [
          if (isAdmin) ...[
            IconButton(
              onPressed: () => _markLate(context, ref),
              icon: const Icon(Icons.timer_off_rounded, color: AppColors.warning),
            ),
            IconButton(
              onPressed: () => _processDay(context, ref),
              icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: attendanceAsync.when(
        data: (records) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          record.employeeName[0],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(record.department, style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
                        ],
                      ),
                    ),
                    _buildIndicator(record.status),
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

  void _markLate(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(attendanceRepositoryProvider).markLateNow();
      ref.invalidate(attendanceProvider);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Late status processed.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _processDay(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(attendanceRepositoryProvider).processDay();
      ref.invalidate(attendanceProvider);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Day processed successfully.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildIndicator(String status) {
    Color color;
    switch (status) {
      case 'Present': color = AppColors.success; break;
      case 'Late': color = AppColors.warning; break;
      case 'Absent': color = AppColors.danger; break;
      default: color = Colors.grey;
    }

    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
