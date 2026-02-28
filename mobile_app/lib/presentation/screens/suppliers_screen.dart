import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/presentation/providers/auth_provider.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/presentation/widgets/glass_container.dart';
import 'package:mobile_app/presentation/widgets/fade_in_slide.dart';

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(suppliersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendors'),
      ),
      body: suppliersAsync.when(
        data: (suppliers) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: suppliers.length,
          itemBuilder: (context, index) {
            final supplier = suppliers[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: FadeInSlide(
                duration: Duration(milliseconds: 300 + (index * 50)),
                child: GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(child: Icon(Icons.business_rounded, color: AppColors.primary, size: 20)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(supplier.category, style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(supplier.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.phone_rounded, color: AppColors.textSub, size: 14),
                          const SizedBox(width: 8),
                          Text(supplier.contact, style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
                          const Spacer(),
                          _buildStatusIndicator(supplier.status),
                        ],
                      ),
                    ],
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

  Widget _buildStatusIndicator(String status) {
    final isActive = status == 'Active';
    final color = isActive ? AppColors.success : AppColors.danger;
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
