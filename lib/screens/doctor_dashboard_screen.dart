import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';
import 'manage_availability_screen.dart';
import 'patient_details_consultation_screen.dart';
import 'admin_dashboard_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  String _selectedFilter = 'All';
  bool _isOnDuty = true;

  final List<Map<String, dynamic>> _filterOptions = [
    {'label': 'All', 'count': 12, 'color': ClinicalColors.primary},
    {'label': 'Confirmed', 'count': 5, 'color': ClinicalColors.secondary},
    {'label': 'Completed', 'count': 4, 'color': ClinicalColors.tertiary},
    {'label': 'Pending', 'count': 2, 'color': ClinicalColors.secondaryContainer},
    {'label': 'Cancelled', 'count': 1, 'color': ClinicalColors.error},
  ];

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
          tooltip: 'Return to Patient Mode',
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ClinicalColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_hospital, color: ClinicalColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _isOnDuty ? ClinicalColors.tertiary : ClinicalColors.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isOnDuty ? 'On Duty • Dr. Sarah Adams' : 'Off Duty',
                      style: const TextStyle(
                        fontSize: 11,
                        color: ClinicalColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminDashboardScreen(),
                ),
              );
            },
            tooltip: 'Hospital Admin Console',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(showBackButton: true),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isOnDuty = !_isOnDuty;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isOnDuty ? 'Duty status: ON DUTY' : 'Duty status: OFF DUTY (Break)'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 17,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=300&q=80',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _isOnDuty ? ClinicalColors.tertiary : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Physician Greeting Banner
            _buildGreetingBanner(),
            const SizedBox(height: 16),

            // 2x2 Metric Statistics Cards
            _buildMetricsGrid(),
            const SizedBox(height: 20),

            // Quick Access Actions
            _buildQuickActions(),
            const SizedBox(height: 20),

            // Schedule Header & Filter Chips
            _buildScheduleHeader(),
            const SizedBox(height: 12),

            // Chronological Timeline Cards
            _buildTimelineFeed(),
            const SizedBox(height: 20),

            // View All Consultations Button
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All 12 consultations loaded in full schedule')),
                  );
                },
                icon: const Text('View All Today\'s Consultations (12)', style: TextStyle(fontWeight: FontWeight.w600)),
                label: const Icon(Icons.arrow_forward, size: 16),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ClinicalColors.primary,
                  side: const BorderSide(color: ClinicalColors.primaryFixed),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=300&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, Dr. Sarah 👋',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Senior Cardiologist • St. Jude Heart Clinic',
                      style: TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ClinicalColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'On Duty • Clinic Room 304',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onTertiaryFixed,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Shift: 08:30 – 17:00',
                style: TextStyle(
                  fontSize: 12,
                  color: ClinicalColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.45,
      children: [
        _buildMetricCard(
          title: "Today's Visits",
          value: '12',
          trend: '+3 vs yesterday',
          icon: Icons.calendar_today,
          iconColor: ClinicalColors.primary,
          iconBg: ClinicalColors.primary.withValues(alpha: 0.1),
          trendColor: ClinicalColors.tertiary,
        ),
        _buildMetricCard(
          title: 'Next 7 Days',
          value: '28',
          trend: '4 pending check-in',
          icon: Icons.event_available,
          iconColor: ClinicalColors.secondary,
          iconBg: ClinicalColors.secondaryContainer.withValues(alpha: 0.3),
          trendColor: ClinicalColors.onSurfaceVariant,
        ),
        _buildMetricCard(
          title: 'Completed',
          value: '156',
          trend: 'This month',
          icon: Icons.task_alt,
          iconColor: ClinicalColors.tertiary,
          iconBg: ClinicalColors.tertiaryFixed,
          trendColor: ClinicalColors.onSurfaceVariant,
        ),
        _buildMetricCard(
          title: 'Registered',
          value: '1,240',
          trend: '+14 new patients',
          icon: Icons.folder_shared,
          iconColor: ClinicalColors.primary,
          iconBg: ClinicalColors.primaryFixed,
          trendColor: ClinicalColors.tertiary,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Color trendColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: ClinicalColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ClinicalColors.onSurface,
            ),
          ),
          Text(
            trend,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: trendColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK ACCESS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: ClinicalColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                icon: Icons.more_time,
                label: 'Slots',
                color: ClinicalColors.primary,
                bgColor: ClinicalColors.primary.withValues(alpha: 0.1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAvailabilityScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.event_available,
                label: 'Visits',
                color: ClinicalColors.secondary,
                bgColor: ClinicalColors.secondaryContainer.withValues(alpha: 0.3),
                onTap: () {
                  setState(() => _selectedFilter = 'All');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Showing all doctor appointments queue')),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.people,
                label: 'Patients',
                color: ClinicalColors.tertiary,
                bgColor: ClinicalColors.tertiaryFixed,
                onTap: _showPatientsDirectoryModal,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.payments,
                label: 'Billing',
                color: ClinicalColors.primary,
                bgColor: ClinicalColors.primaryFixed,
                onTap: _showBillingModal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ClinicalColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ClinicalColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_month, size: 14, color: ClinicalColors.primary),
                  SizedBox(width: 5),
                  Text(
                    'Oct 15, 2024',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Horizontal filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _filterOptions.map((opt) {
              final isSelected = _selectedFilter == opt['label'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(opt['label'] as String),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : ClinicalColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${opt['count']}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? ClinicalColors.primary
                                : ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = opt['label'] as String;
                    });
                  },
                  backgroundColor: ClinicalColors.surfaceContainer,
                  selectedColor: ClinicalColors.primary,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : ClinicalColors.onSurfaceVariant,
                  ),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineFeed() {
    return Column(
      children: [
        // 09:00 AM: John Doe (Completed)
        if (_shouldShow('Completed'))
          _buildTimelineRow(
            time: '09:00',
            period: 'AM',
            connectorColor: ClinicalColors.tertiaryFixed,
            child: _buildCompletedCard(),
          ),

        // 10:00 AM: Alex Kumar (Confirmed & Active)
        if (_shouldShow('Confirmed'))
          _buildTimelineRow(
            time: '10:00',
            period: 'AM',
            connectorColor: ClinicalColors.primaryFixed,
            isCurrent: true,
            child: _buildActivePatientCard(),
          ),

        // 11:30 AM: Maria Santos (Pending)
        if (_shouldShow('Pending'))
          _buildTimelineRow(
            time: '11:30',
            period: 'AM',
            connectorColor: ClinicalColors.surfaceVariant,
            child: _buildPendingCard(),
          ),

        // 02:15 PM: David Miller (Cancelled)
        if (_shouldShow('Cancelled'))
          _buildTimelineRow(
            time: '02:15',
            period: 'PM',
            connectorColor: Colors.transparent,
            child: _buildCancelledCard(),
          ),
      ],
    );
  }

  bool _shouldShow(String status) {
    if (_selectedFilter == 'All') return true;
    return _selectedFilter.toLowerCase() == status.toLowerCase();
  }

  Widget _buildTimelineRow({
    required String time,
    required String period,
    required Color connectorColor,
    required Widget child,
    bool isCurrent = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 48,
              child: Column(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    period,
                    style: TextStyle(
                      fontSize: 10,
                      color: isCurrent ? ClinicalColors.primary : ClinicalColors.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: connectorColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('General Consultation • Room 304', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ClinicalColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: ClinicalColors.tertiary),
                    SizedBox(width: 4),
                    Text('Completed', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onTertiaryFixed)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.medication, size: 14, color: ClinicalColors.tertiary),
                  SizedBox(width: 4),
                  Text('Rx Issued • 2 Follow-ups', style: TextStyle(fontSize: 11, color: ClinicalColors.tertiary, fontWeight: FontWeight.w600)),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _showConsultationSummaryModal('John Doe'),
                icon: const Icon(Icons.description, size: 14),
                label: const Text('Summary', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(0, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivePatientCard() {
    return Container(
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ClinicalColors.primary.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3)),
        ],
        border: Border.all(color: ClinicalColors.primary.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top indicator bar
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: ClinicalColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: ClinicalColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Alex Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              SizedBox(width: 6),
                              Text('#PT-9420', style: TextStyle(fontSize: 10, color: ClinicalColors.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text('Follow-up • ECG Review', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ClinicalColors.secondaryFixed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 12, color: ClinicalColors.onSecondaryFixedVariant),
                          SizedBox(width: 4),
                          Text('Confirmed', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onSecondaryFixedVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.meeting_room, size: 14, color: ClinicalColors.primary),
                          SizedBox(width: 6),
                          Text('Waiting Room • Intake ready', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                        ],
                      ),
                      Text('Vitals: Normal (118/76)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.secondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PatientDetailsConsultationScreen(
                                patientName: 'Alex Kumar',
                                mrn: '#PT-9420',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.medical_services, size: 16),
                        label: const Text('Start Visit', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClinicalColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: () => _showPatientEmrChart('Alex Kumar'),
                        icon: const Icon(Icons.medical_information, size: 16),
                        label: const Text('Chart'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ClinicalColors.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Maria Santos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(
                      children: [
                        Icon(Icons.videocam, size: 12, color: ClinicalColors.secondary),
                        SizedBox(width: 4),
                        Text('Telehealth / Video', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ClinicalColors.secondaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Pending', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onSecondaryFixedVariant)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Awaiting patient check-in', style: TextStyle(fontSize: 11, color: ClinicalColors.outline)),
              Text('Link active in 45m', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ClinicalColors.primary)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _reviewIntakeForm('Maria Santos'),
                  icon: const Icon(Icons.preview, size: 14),
                  label: const Text('Review Intake', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reschedule reminder sent to Maria Santos')),
                  );
                },
                icon: const Icon(Icons.event_repeat, size: 18, color: ClinicalColors.primary),
                tooltip: 'Reschedule',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_off, size: 18, color: ClinicalColors.onSurfaceVariant),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'David Miller',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: ClinicalColors.outline,
                      ),
                    ),
                    Text('Cardiac Assessment', style: TextStyle(fontSize: 11, color: ClinicalColors.outline)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ClinicalColors.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Cancelled', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onErrorContainer)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Reason: Patient rescheduled to Oct 19', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: ClinicalColors.onErrorContainer)),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('2:15 PM slot reopened for general booking')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ClinicalColors.surfaceContainerLowest,
                  foregroundColor: ClinicalColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(0, 28),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Reopen Slot', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _showPatientEmrChart(String patientName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('EMR Chart: $patientName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            const Text('DIAGNOSIS HISTORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.outline)),
            const SizedBox(height: 4),
            const Text('Essential Primary Hypertension (I10) · Sinus Bradycardia (R00.1)'),
            const SizedBox(height: 12),
            const Text('CURRENT MEDICATIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.outline)),
            const SizedBox(height: 4),
            const Text('• Lisinopril 10mg daily oral\n• Atorvastatin 20mg at bedtime'),
            const SizedBox(height: 12),
            const Text('ALLERGIES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.outline)),
            const SizedBox(height: 4),
            const Text('Penicillin (Severe rash)'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close Chart'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConsultationSummaryModal(String patientName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Encounter Summary: $patientName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Text(
          'Completed at 09:42 AM. Vital signs recorded within standard limits. E-Prescription dispatched to clinic pharmacy. Follow-up scheduled in 4 weeks.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _reviewIntakeForm(String patientName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Intake Form: $patientName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submitted Symptoms: Palpitations when climbing stairs for 3 days.'),
            SizedBox(height: 8),
            Text('Pre-visit Questionnaires: Completed (Score: 2/10 Mild Discomfort)'),
            SizedBox(height: 8),
            Text('Insurance Authorization: Approved'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Acknowledge')),
        ],
      ),
    );
  }


  void _showPatientsDirectoryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Registered Patients Directory (1,240)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Recent active patients under Dr. Sarah Johnson:\n• Alex Kumar (#PT-9420)\n• John Doe (#PT-8712)\n• Maria Santos (#PT-9031)\n• Michael Chang (#PT-8821)'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close Directory'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBillingModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Clinical Billings & Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('• Weekly Gross: \$4,850.00\n• Telehealth Payout: \$1,920.00\n• In-Clinic Visits: \$2,930.00\n• Pending Insurance Claims: 14 claims (\$1,120)'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Download Financial Statement'),
            ),
          ],
        ),
      ),
    );
  }
}
