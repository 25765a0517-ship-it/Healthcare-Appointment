import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  String _selectedDateRange = 'This Month';

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
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Reports & Analytics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
            ),
            Text(
              'Hospital Operations & Financial Intelligence',
              style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: ClinicalColors.onSurfaceVariant),
            onPressed: () => _exportReport('PDF'),
            tooltip: 'Download report',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ClinicalColors.primary,
              child: const Icon(Icons.analytics, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Live Status Strip
            _buildLiveStatusStrip(),
            const SizedBox(height: 12),

            // Export Actions Bar
            _buildExportActionsBar(),
            const SizedBox(height: 14),

            // Date Range Filter Chips
            _buildDateRangeSelector(),
            const SizedBox(height: 16),

            // Appointment Fulfillment Section
            _buildAppointmentFulfillmentCard(),
            const SizedBox(height: 16),

            // Financial Performance Section
            _buildFinancialPerformanceCard(),
            const SizedBox(height: 16),

            // Department Performance Ranking
            _buildDepartmentRankingCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusStrip() {
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
                'Live Sync Active • Updated 10m ago',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.tertiary),
              ),
            ],
          ),
          const Text(
            'EHR Telemetry v2.4',
            style: TextStyle(fontSize: 10, color: ClinicalColors.outline, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExportActionsBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => _exportReport('PDF'),
            icon: const Icon(Icons.picture_as_pdf, size: 16),
            label: const Text('Export PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.surfaceContainerLow,
              foregroundColor: ClinicalColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _exportReport('Excel'),
            icon: const Icon(Icons.table_chart, size: 16),
            label: const Text('Export Excel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.surfaceContainerLow,
              foregroundColor: ClinicalColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _exportReport('Comprehensive'),
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download Report'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    final ranges = ['Today', 'This Week', 'This Month', 'Oct 1 - Oct 31'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ranges.map((r) {
          final isSelected = _selectedDateRange == r;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(r),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedDateRange = r),
              selectedColor: ClinicalColors.primary,
              backgroundColor: ClinicalColors.surfaceContainerLow,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : ClinicalColors.onSurface,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAppointmentFulfillmentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appointment Fulfillment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Scheduled intake volume & completion', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                ],
              ),
              Icon(Icons.event_available, color: ClinicalColors.primary, size: 24),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: const [
                  Text('4,820', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface)),
                  SizedBox(width: 6),
                  Text('total', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ClinicalColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, size: 12, color: ClinicalColors.onTertiaryFixed),
                    SizedBox(width: 4),
                    Text('+8.6% MoM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onTertiaryFixed)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Multi-color Segmented Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: const [
                  Expanded(flex: 87, child: ColoredBox(color: ClinicalColors.tertiary)),
                  Expanded(flex: 9, child: ColoredBox(color: ClinicalColors.secondaryContainer)),
                  Expanded(flex: 4, child: ColoredBox(color: ClinicalColors.error)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('87.3% Completed', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
              Text('9.0% Pending', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
              Text('3.7% Cancelled', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Breakdown Sub-Cards
          Row(
            children: [
              Expanded(child: _buildSubKpi('Completed', '4,210', '87.3% rate', ClinicalColors.tertiary)),
              const SizedBox(width: 8),
              Expanded(child: _buildSubKpi('Pending', '432', 'Queue state', ClinicalColors.secondary)),
              const SizedBox(width: 8),
              Expanded(child: _buildSubKpi('Cancelled', '178', '<5% safe', ClinicalColors.error)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubKpi(String label, String value, String sub, Color dotColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 10, color: dotColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFinancialPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
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
                  Text('Financial Performance', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Billing, consultations & clinical procedures', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ClinicalColors.primaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.payments, size: 20, color: ClinicalColors.onPrimaryFixed),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Total Oct Revenue', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                      SizedBox(height: 4),
                      Text('\$148,250', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface)),
                      SizedBox(height: 4),
                      Text('105% of \$140k goal', style: TextStyle(fontSize: 10, color: ClinicalColors.tertiary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Avg Ticket Size', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                      SizedBox(height: 4),
                      Text('\$85 / Visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface)),
                      SizedBox(height: 4),
                      Text('Copay + Insurance', style: TextStyle(fontSize: 10, color: ClinicalColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentRankingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Department Performance Ranking', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          const Text('Volume & satisfaction across hospital wings', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 14),
          _buildRankingRow('1', 'Cardiology & Vascular', '1,420 visits', '98% CSAT', ClinicalColors.primary),
          _buildRankingRow('2', 'Pediatrics & Neonatal', '1,180 visits', '97% CSAT', ClinicalColors.secondary),
          _buildRankingRow('3', 'General & Family Medicine', '980 visits', '95% CSAT', ClinicalColors.tertiary),
          _buildRankingRow('4', 'Orthopedics & Spine', '760 visits', '94% CSAT', ClinicalColors.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildRankingRow(String rank, String dept, String volume, String csat, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(rank, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dept, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(volume, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(csat, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.tertiary)),
          ),
        ],
      ),
    );
  }

  void _exportReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type report generated & sent to hospital administration email'),
      ),
    );
  }
}
