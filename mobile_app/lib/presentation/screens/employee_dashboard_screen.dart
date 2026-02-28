import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/presentation/providers/auth_provider.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/presentation/widgets/glass_container.dart';
import 'package:mobile_app/presentation/widgets/glass_button.dart';
import 'package:mobile_app/presentation/widgets/fade_in_slide.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class EmployeeDashboardScreen extends ConsumerStatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  ConsumerState<EmployeeDashboardScreen> createState() => _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends ConsumerState<EmployeeDashboardScreen> {
  int _activeTab = 0; // 0: Dashboard, 1: Leaves, 2: Payroll
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _updateTime();
  }

  void _updateTime() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _now = DateTime.now());
        _updateTime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Depth
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildTabs(),
                Expanded(
                  child: IndexedStack(
                    index: _activeTab,
                    children: [
                      _DashboardTab(now: _now),
                      const _LeavesTab(),
                      const _PayrollTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final user = ref.watch(authProvider).user;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          GlassContainer(
            width: 50,
            height: 50,
            borderRadius: 15,
            child: Center(
              child: Text(
                user?.name[0] ?? 'E',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(color: AppColors.textSub, fontSize: 12),
              ),
              Text(
                user?.name ?? 'Employee',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Sora'),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GlassContainer(
        borderRadius: 20,
        opacity: 0.05,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildTabItem(0, 'Dashboard', Icons.home_rounded),
            _buildTabItem(1, 'Leaves', Icons.event_note_rounded),
            _buildTabItem(2, 'Payroll', Icons.payments_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSub, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textSub,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTab extends ConsumerWidget {
  final DateTime now;
  const _DashboardTab({required this.now});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(myTodayProvider);
    final timeFmt = DateFormat('HH:mm:ss');
    final dateFmt = DateFormat('EEEE, MMMM d, yyyy');

    return todayAsync.when(
      data: (data) {
        final settings = data['settings'];
        final record = data['record'];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeInSlide(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Clock Card
                GlassContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  gradient: [AppColors.primary.withOpacity(0.8), AppColors.secondary.withOpacity(0.8)],
                  child: Column(
                    children: [
                      Text(dateFmt.format(now), style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(
                        timeFmt.format(now),
                        style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Sora', letterSpacing: 2),
                      ),
                      const SizedBox(height: 16),
                      if (settings != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _TimeInfo(label: 'Opens', value: settings['check_in_open'], icon: Icons.lock_open_rounded),
                            _TimeInfo(label: 'Late After', value: settings['late_after'], icon: Icons.access_time_rounded),
                            _TimeInfo(label: 'Closes', value: settings['check_out_time'], icon: Icons.lock_outline_rounded),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Status Card
                Text('Today\'s Status', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: record != null
                    ? Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStatusColor(record['status']).withOpacity(0.2),
                            ),
                            child: Icon(_getStatusIcon(record['status']), color: _getStatusColor(record['status'])),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(record['status'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _getStatusColor(record['status']))),
                                Text(
                                  'In: ${record['checkIn'] ?? "--"}  ·  Out: ${record['checkOut'] ?? "--"}',
                                  style: const TextStyle(color: AppColors.textSub, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        children: [
                          Icon(Icons.hourglass_empty_rounded, color: AppColors.textSub),
                          SizedBox(width: 12),
                          Text('No check-in record for today', style: TextStyle(color: AppColors.textSub)),
                        ],
                      ),
                ),

                const SizedBox(height: 32),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        label: 'Show My QR',
                        icon: Icons.qr_code_rounded,
                        onPressed: () => _showMyQr(context, ref),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassButton(
                        label: 'Scan to In',
                        icon: Icons.camera_alt_rounded,
                        onPressed: () => _openScanner(context, ref),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GlassButton(
                  label: 'Check-Out',
                  isPrimary: false,
                  icon: Icons.exit_to_app_rounded,
                  onPressed: () => _doCheckOut(context, ref),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present': return AppColors.success;
      case 'Late': return AppColors.warning;
      case 'Absent': return AppColors.danger;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Present': return Icons.check_circle_rounded;
      case 'Late': return Icons.warning_rounded;
      case 'Absent': return Icons.cancel_rounded;
      default: return Icons.help_outline_rounded;
    }
  }

  void _showMyQr(BuildContext context, WidgetRef ref) async {
    final qrData = await ref.read(attendanceRepositoryProvider).getMyQr();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 30,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your Daily Access Token', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Sora')),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: QrImageView(
                data: qrData['qrData'],
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 24),
            Text(qrData['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${qrData['employeeId']} · ${qrData['department']}', style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
            const SizedBox(height: 32),
            GlassButton(label: 'Close', isPrimary: false, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  void _openScanner(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: [
            MobileScanner(
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final code = barcodes.first.rawValue;
                  if (code != null) {
                    Navigator.pop(context);
                    await ref.read(attendanceRepositoryProvider).qrCheckIn(code);
                    ref.invalidate(myTodayProvider);
                  }
                }
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doCheckOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(attendanceRepositoryProvider).myCheckOut();
      ref.invalidate(myTodayProvider);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked out successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

class _TimeInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _TimeInfo({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace')),
      ],
    );
  }
}

class _LeavesTab extends ConsumerWidget {
  const _LeavesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leavesAsync = ref.watch(myLeavesProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: GlassButton(
            label: 'Request New Leave',
            icon: Icons.add_rounded,
            onPressed: () => _showLeaveForm(context, ref),
          ),
        ),
        Expanded(
          child: leavesAsync.when(
            data: (leaves) => ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
              itemCount: leaves.length,
              itemBuilder: (context, index) {
                final l = leaves[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: FadeInSlide(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l['type'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              _buildStatusBadge(l['status']),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('📅 ${l['from_date']} → ${l['to_date']}', style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
                          if (l['hr_note'] != null) ...[
                            const SizedBox(height: 8),
                            Text('💬 HR: ${l['hr_note']}', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = AppColors.warning;
    if (status == 'Approved') color = AppColors.success;
    if (status == 'Rejected') color = AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  void _showLeaveForm(BuildContext context, WidgetRef ref) {
    // Basic form implementation...
  }
}

class _PayrollTab extends ConsumerWidget {
  const _PayrollTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payrollAsync = ref.watch(myPayrollProvider);

    return payrollAsync.when(
      data: (data) {
        final List payrolls = data['payroll'] ?? [];
        if (payrolls.isEmpty) return const Center(child: Text('No payroll records found.'));

        final latest = payrolls.first;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeInSlide(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('Latest Net Salary', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(
                        'EGP ${latest['netSalary']}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Sora'),
                      ),
                      const SizedBox(height: 4),
                      Text(latest['month'], style: const TextStyle(color: AppColors.textSub, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text('History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                ...payrolls.skip(1).map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['month'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Net: EGP ${p['netSalary']}', style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
                          ],
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textSub),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
