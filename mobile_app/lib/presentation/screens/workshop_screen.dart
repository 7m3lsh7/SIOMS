import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/presentation/providers/auth_provider.dart';
import 'package:mobile_app/core/theme/app_colors.dart';

class WorkshopScreen extends ConsumerWidget {
  const WorkshopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentAsync = ref.watch(equipmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workshop', style: TextStyle(fontFamily: 'Sora', fontWeight: FontWeight.bold)),
      ),
      body: equipmentAsync.when(
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${item.model} · ${item.department}'),
                trailing: Text(
                  item.status,
                  style: TextStyle(
                    color: item.status == 'Active' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
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
}
