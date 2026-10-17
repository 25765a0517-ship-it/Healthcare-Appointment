import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'admin_doctors_management_screen.dart';
import 'reports_analytics_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedPeriod = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalColors.surface,
      appBar: AppBar(
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Return to portal',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: ClinicalColors.secondaryFixed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: ClinicalColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.onSecondaryFixedVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Text(
              'Admin Console',
              style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Global administrative search activated')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hospital system alerts: All services operational')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ClinicalColors.primary,
              child: const Icon(Icons.admin_panel_settings, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Live System Health & Compliance Strip
            _buildComplianceStrip(),
            const SizedBox(height: 14),

            // Top Search & Date Bar
            _buildTopControlsBar(),
            const SizedBox(height: 18),

            // Executive KPIs Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.insights, size: 20, color: ClinicalColors.primary),
                    SizedBox(width: 6),
                    Text(
                      'Executive KPIs',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Text(
                  'Real-time Telemetry',
                  style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 6-Card Executive Grid
            _buildExecutiveGrid(),
            const SizedBox(height: 16),

            // Clinical Care Efficiency Micro-Ribbon
            _buildCareEfficiencyRibbon(),
            const SizedBox(height: 18),

            // Quick Portal Access Cards
            _buildQuickPortalLinks(),
            const SizedBox(height: 18),

            // Visual Charts Section
            _buildRevenueTrendChart(),
            const SizedBox(height: 16),
            _buildDepartmentLoadChart(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: ClinicalColors.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'HIPAA Compliant • Uptime 99.98% • EHR Live Sync',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.tertiary),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'v2.4 SECURE',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopControlsBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.calendar_today, size: 16, color: ClinicalColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Last 30 Days (Oct 1 – Oct 30)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.expand_more, size: 16, color: ClinicalColors.outline),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exporting executive report (PDF & CSV)...')),
            );
          },
          icon: const Icon(Icons.download, size: 16),
          label: const Text('Export', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: ClinicalColors.secondaryFixed,
            foregroundColor: ClinicalColors.onSecondaryFixedVariant,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildExecutiveGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        _buildKpiCard(
          title: 'Total Patients',
          value: '24,850',
          badgeText: '+12.4%',
          badgeColor: ClinicalColors.tertiaryFixed,
          badgeTextColor: ClinicalColors.onTertiaryFixed,
          subtitle: 'Active profiles synced',
        ),
        _buildKpiCard(
          title: 'Staff Doctors',
          value: '184',
          badgeText: '42 On Duty',
          badgeColor: ClinicalColors.primaryFixed,
          badgeTextColor: ClinicalColors.onPrimaryFixed,
          subtitle: '18 Clinical depts',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDoctorsManagementScreen(),
              ),
            );
          },
        ),
        _buildKpiCard(
          title: 'Today\'s Visits',
          value: '142',
          badgeText: '18 In Queue',
          badgeColor: ClinicalColors.secondaryFixed,
          badgeTextColor: ClinicalColors.onSecondaryFixedVariant,
          subtitle: '84 In-clinic • 58 Tele',
        ),
        _buildKpiCard(
          title: 'Completed',
          value: '3,890',
          badgeText: '96.2% Rate',
          badgeColor: ClinicalColors.surfaceContainerHigh,
          badgeTextColor: ClinicalColors.onSurfaceVariant,
          subtitle: 'Current billing cycle',
        ),
        _buildKpiCard(
          title: 'Net Revenue',
          value: '\$284,500',
          badgeText: '+18.5%',
          badgeColor: ClinicalColors.tertiaryFixed,
          badgeTextColor: ClinicalColors.onTertiaryFixed,
          subtitle: 'Insurance & Out-of-pocket',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportsAnalyticsScreen(),
              ),
            );
          },
        ),
        _buildKpiCard(
          title: 'Cancellations',
          value: '3.8%',
          badgeText: '-0.6%',
          badgeColor: ClinicalColors.surfaceContainerHigh,
          badgeTextColor: ClinicalColors.tertiary,
          subtitle: 'Below 5% threshold',
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                  child: Text(badgeText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeTextColor)),
                ),
              ],
            ),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface)),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildCareEfficiencyRibbon() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('CLINICAL CARE EFFICIENCY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onSurfaceVariant, letterSpacing: 0.6)),
              Text('Benchmarks Passed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.primary)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildEfficiencyStat('Avg Wait Time', '12 min', 'Target: <15m', ClinicalColors.tertiary)),
              const SizedBox(width: 8),
              Expanded(child: _buildEfficiencyStat('Doctor Util.', '88%', '+4% Optimized', ClinicalColors.tertiary)),
              const SizedBox(width: 8),
              Expanded(child: _buildEfficiencyStat('Patient CSAT', '4.9 ★', '3,120 reviews', ClinicalColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyStat(String label, String value, String sub, Color subColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface)),
          const SizedBox(height: 1),
          Text(sub, style: TextStyle(fontSize: 9, color: subColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickPortalLinks() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminDoctorsManagementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.badge, size: 18),
            label: const Text('Doctors Directory'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportsAnalyticsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.analytics, size: 18),
            label: const Text('Reports & Analytics'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueTrendChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Trend', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 1),
                  Text('Growth trajectory (\$50k to \$284k)', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: ['Monthly', 'Daily'].map((p) {
                    final isSel = _selectedPeriod == p;
                    return InkWell(
                      onTap: () => setState(() => _selectedPeriod = p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSel ? ClinicalColors.surfaceContainerLowest : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSel ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual Bar Representation
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRevenueBar('May', 0.2, '\$52k'),
                _buildRevenueBar('Jun', 0.35, '\$98k'),
                _buildRevenueBar('Jul', 0.5, '\$140k'),
                _buildRevenueBar('Aug', 0.65, '\$185k'),
                _buildRevenueBar('Sep', 0.75, '\$210k'),
                _buildRevenueBar('Oct', 1.0, '\$284k', isHighlight: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBar(String month, double heightFraction, String amount, {bool isHighlight = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(amount, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isHighlight ? ClinicalColors.primary : ClinicalColors.outline)),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: 60 * heightFraction,
          decoration: BoxDecoration(
            color: isHighlight ? ClinicalColors.primary : ClinicalColors.secondaryFixed,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(month, style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildDepartmentLoadChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Departmental Load', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text('Capacity 82%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.tertiary)),
            ],
          ),
          const SizedBox(height: 2),
          const Text('Daily appointment distribution', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 12),
          _buildDeptBar('Cardiology', 48, 60, ClinicalColors.primary),
          _buildDeptBar('Pediatrics', 38, 60, ClinicalColors.secondaryContainer),
          _buildDeptBar('General Medicine', 32, 60, ClinicalColors.tertiary),
          _buildDeptBar('Orthopedics', 24, 60, ClinicalColors.secondary),
        ],
      ),
    );
  }

  Widget _buildDeptBar(String dept, int count, int max, Color barColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dept, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
              Text('$count', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count / max,
              minHeight: 8,
              backgroundColor: ClinicalColors.surfaceContainerLow,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}
