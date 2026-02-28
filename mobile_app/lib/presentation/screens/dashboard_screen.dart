import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/fade_in_slide.dart';
import '../../core/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          _buildActionIcon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            () => ref.read(themeProvider.notifier).toggleTheme(),
            isDark,
          ),
          const SizedBox(width: 8),
          _buildActionIcon(
            Icons.notifications_none_rounded,
            () {},
            isDark,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: FadeInSlide(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                Hero(
                  tag: 'app_logo',
                  child: GlassContainer(
                    width: 44,
                    height: 44,
                    borderRadius: 12,
                    child: Center(
                      child: Text(
                        user?.name?[0] ?? 'S',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello,', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                    Text(
                      user?.name ?? "Explorer",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // KPI Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                GlassKPICard(label: 'Active Staff', value: '1,240', color: AppColors.primary, icon: Icons.people_rounded),
                GlassKPICard(label: 'Attendance', value: '92%', color: AppColors.success, icon: Icons.check_circle_rounded),
                GlassKPICard(label: 'Op. Budget', value: 'EGP 420K', color: AppColors.secondary, icon: Icons.account_balance_wallet_rounded),
                GlassKPICard(label: 'Inventory', value: '14 Low', color: AppColors.danger, icon: Icons.inventory_2_rounded),
              ],
            ),

            const SizedBox(height: 24),

            // Chart Section
             FadeInSlide(
              offset: 50,
              child: GlassContainer(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Resource Utilization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Sora')),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Live', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(
                    height: 180,
                    child: PremiumLineChart(),
                  ),
                ],
              ),
            ),),
          ],
        ),),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        width: 40,
        height: 40,
        borderRadius: 12,
        blur: 10,
        opacity: isDark ? 0.1 : 0.05,
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class GlassKPICard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const GlassKPICard({super.key, required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSub, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Sora')),
        ],
      ),
    );
  }
}

class PremiumLineChart extends StatelessWidget {
  const PremiumLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(2, 4.5),
              FlSpot(4, 3.2),
              FlSpot(6, 5.5),
              FlSpot(8, 4),
              FlSpot(10, 6),
              FlSpot(12, 5),
            ],
            isCurved: true,
            color: AppColors.primary,
            barWidth: 4,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
