import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/presentation/providers/auth_provider.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/presentation/widgets/glass_container.dart';
import 'package:mobile_app/presentation/widgets/fade_in_slide.dart';

class PayrollScreen extends ConsumerWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payrollAsync = ref.watch(payrollProvider);
    final currencyFormatter = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financials'),
      ),
      body: payrollAsync.when(
        data: (records) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FadeInSlide(
                duration: Duration(milliseconds: 300 + (index * 50)),
                child: GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(record.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Sora')),
                              Text(record.department, style: const TextStyle(color: AppColors.textSub, fontSize: 11)),
                            ],
                          ),
                          _buildStatusBadge(record.status),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SalaryItem(label: 'Gross', value: currencyFormatter.format(record.baseSalary)),
                          _SalaryItem(label: 'Deductions', value: '- ${currencyFormatter.format(record.taxDeduction + record.insuranceDeduction)}', isRed: true),
                          _SalaryItem(label: 'Net Pay', value: currencyFormatter.format(record.netSalary), isBold: true),
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

  Widget _buildStatusBadge(String status) {
    final isPaid = status == 'Paid';
    final color = isPaid ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _SalaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isRed;

  const _SalaryItem({required this.label, required this.value, this.isBold = false, this.isRed = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSub, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 15 : 13,
            color: isRed ? AppColors.danger : (isBold ? AppColors.primary : AppColors.textMain),
          ),
        ),
      ],
    );
  }
}
