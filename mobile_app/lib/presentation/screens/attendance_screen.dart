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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logistics'),
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
