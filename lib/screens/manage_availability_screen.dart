import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ManageAvailabilityScreen extends StatefulWidget {
  const ManageAvailabilityScreen({super.key});

  @override
  State<ManageAvailabilityScreen> createState() => _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  final Map<String, bool> _workingDays = {
    'Mon': true,
    'Tue': true,
    'Wed': true,
    'Thu': true,
    'Fri': true,
    'Sat': false,
    'Sun': false,
  };

  TimeOfDay _shiftStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _shiftEnd = const TimeOfDay(hour: 17, minute: 0);
  int _selectedDuration = 30; // 15, 30, 45, 60
  bool _enableBuffer = true;
  String _selectedSlotFilter = 'All';

  late List<Map<String, dynamic>> _slots;

  @override
  void initState() {
    super.initState();
    _initializeSlots();
  }

  void _initializeSlots() {
    _slots = [
      {'time': '09:00 AM', 'status': 'available', 'patient': null},
      {'time': '09:30 AM', 'status': 'available', 'patient': null},
      {'time': '10:00 AM', 'status': 'booked', 'patient': 'Alex Kumar (ECG Review)'},
      {'time': '10:30 AM', 'status': 'available', 'patient': null},
      {'time': '11:00 AM', 'status': 'available', 'patient': null},
      {'time': '11:30 AM', 'status': 'booked', 'patient': 'Maria Santos (Telehealth)'},
      {'time': '12:00 PM', 'status': 'available', 'patient': null},
      {'time': '12:30 PM', 'status': 'available', 'patient': null},
      {'time': '02:00 PM', 'status': 'available', 'patient': null},
      {'time': '02:30 PM', 'status': 'blocked', 'patient': 'Blocked for Staff Meeting'},
      {'time': '03:00 PM', 'status': 'available', 'patient': null},
      {'time': '03:30 PM', 'status': 'booked', 'patient': 'John Doe (Follow-up)'},
      {'time': '04:00 PM', 'status': 'available', 'patient': null},
      {'time': '04:30 PM', 'status': 'available', 'patient': null},
    ];
  }

  int get _activeDaysCount => _workingDays.values.where((v) => v).length;

  List<Map<String, dynamic>> get _filteredSlots {
    if (_selectedSlotFilter == 'All') return _slots;
    return _slots.where((s) => s['status'] == _selectedSlotFilter.toLowerCase()).toList();
  }

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
        title: const Text(
          'Manage Availability',
          style: TextStyle(
            color: ClinicalColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              setState(() {
                _initializeSlots();
                _workingDays.updateAll((key, val) => key != 'Sat' && key != 'Sun');
                _selectedDuration = 30;
                _enableBuffer = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Schedule reset to default clinic template')),
              );
            },
            tooltip: 'Reset to default',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ClinicalColors.primary,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Provider Context & EHR Sync
            _buildProviderContextBanner(),
            const SizedBox(height: 16),

            // 1. Recurring Working Days
            _buildWorkingDaysSection(),
            const SizedBox(height: 16),

            // 2. Daily Practice Hours & Lunch
            _buildDailyHoursSection(),
            const SizedBox(height: 16),

            // 3. Appointment Duration & Buffer
            _buildDurationSection(),
            const SizedBox(height: 16),

            // 4. Quick Action Deck
            _buildQuickActionDeck(),
            const SizedBox(height: 16),

            // 5. Upcoming Leave Spotlight
            _buildLeaveSpotlight(),
            const SizedBox(height: 16),

            // 6. Live Generated Slots Preview
            _buildLiveSlotsPreview(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ClinicalColors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton.icon(
            onPressed: _saveAvailabilitySchedule,
            icon: const Icon(Icons.check_circle, size: 20),
            label: const Text('Save Availability Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderContextBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
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
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClinicalColors.primaryFixed,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Text(
                          'Dr. Sarah Johnson',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.verified, size: 16, color: ClinicalColors.primary),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Cardiology • St. Jude Health',
                      style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ClinicalColors.secondaryFixed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 7, color: ClinicalColors.secondary),
                    SizedBox(width: 5),
                    Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSecondaryFixedVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.sync, color: ClinicalColors.primary, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-synchronized with St. Jude EHR',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Real-time availability broadcast to patient booking apps.',
                        style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                      ),
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

  Widget _buildWorkingDaysSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
          ),
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
                  Text('Working Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Recurring days you accept visits', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
                ],
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _workingDays.updateAll((day, _) => day != 'Sat' && day != 'Sun');
                  });
                },
                child: const Text('Weekdays Only', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _workingDays.keys.map((day) {
              final isSelected = _workingDays[day]!;
              return InkWell(
                onTap: () {
                  setState(() {
                    _workingDays[day] = !isSelected;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 42,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected ? ClinicalColors.primary : ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day[0],
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white70 : ClinicalColors.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : ClinicalColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: ClinicalColors.tertiary),
              const SizedBox(width: 6),
              Text(
                'Active $_activeDaysCount days weekly (${_activeDaysCount * 8} clinical hours scheduled)',
                style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyHoursSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daily Practice Hours', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          const Text('Set patient intake start and wrap-up times', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTimePickerBox(
                  label: 'Shift Begins',
                  time: _shiftStart.format(context),
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: _shiftStart);
                    if (picked != null && mounted) setState(() => _shiftStart = picked);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePickerBox(
                  label: 'Shift Ends',
                  time: _shiftEnd.format(context),
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: _shiftEnd);
                    if (picked != null && mounted) setState(() => _shiftEnd = picked);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.restaurant, size: 20, color: ClinicalColors.secondary),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lunch & Clinical Rounds Break', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(height: 1),
                      Text('1:00 PM – 2:00 PM (60 min protected)', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
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

  Widget _buildTimePickerBox({
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: ClinicalColors.outline, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: ClinicalColors.primary),
                    const SizedBox(width: 8),
                    Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const Icon(Icons.expand_more, size: 18, color: ClinicalColors.outline),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSection() {
    final durations = [15, 30, 45, 60];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Appointment Duration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          const Text('Default slot length for standard consultations', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 12),
          Row(
            children: durations.map((dur) {
              final isSelected = _selectedDuration == dur;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => _selectedDuration = dur),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? ClinicalColors.primary : ClinicalColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '$dur min',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : ClinicalColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('5 Min Slot Buffer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text('Prevents appointment back-to-back overrun', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Switch(
                value: _enableBuffer,
                activeThumbColor: ClinicalColors.primary,
                onChanged: (val) => setState(() => _enableBuffer = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionDeck() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        _buildActionDeckCard(
          icon: Icons.add_circle,
          title: 'Add Custom Slot',
          subtitle: 'Single ad-hoc slot',
          iconBg: ClinicalColors.secondaryFixed,
          iconColor: ClinicalColors.onSecondaryFixed,
          onTap: _addCustomSlotDialog,
        ),
        _buildActionDeckCard(
          icon: Icons.lock_clock,
          title: 'Block Time Slot',
          subtitle: 'Freeze single window',
          iconBg: ClinicalColors.errorContainer,
          iconColor: ClinicalColors.error,
          onTap: _blockTimeSlotDialog,
        ),
        _buildActionDeckCard(
          icon: Icons.event_busy,
          title: 'Block Date',
          subtitle: 'Full-day outage',
          iconBg: ClinicalColors.surfaceContainer,
          iconColor: ClinicalColors.primary,
          onTap: _blockDateDialog,
        ),
        _buildActionDeckCard(
          icon: Icons.beach_access,
          title: 'Vacation / Leave',
          subtitle: 'Multi-day pause',
          iconBg: ClinicalColors.tertiaryFixed,
          iconColor: ClinicalColors.tertiary,
          onTap: _vacationLeaveDialog,
        ),
      ],
    );
  }

  Widget _buildActionDeckCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
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
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveSpotlight() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: ClinicalColors.surfaceContainerLowest,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flight_takeoff, color: ClinicalColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Cardiology Summit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Text('3 Days', style: TextStyle(fontSize: 10, color: ClinicalColors.outline, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 2),
                Text('Oct 24 – Oct 26 • Bookings Paused', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave dates can be edited in provider calendar')),
              );
            },
            child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveSlotsPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Live Slot Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Wednesday, Oct 16', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${_slots.length} Slots generated based on active schedule',
            style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          // Filter Badges
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Available', 'Booked', 'Blocked'].map((f) {
                final isSelected = _selectedSlotFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedSlotFilter = f),
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
          ),
          const SizedBox(height: 12),

          // Slots List
          ..._filteredSlots.map((slot) {
            Color statusColor;
            String statusText;

            if (slot['status'] == 'available') {
              statusColor = ClinicalColors.tertiary;
              statusText = 'Available';
            } else if (slot['status'] == 'booked') {
              statusColor = ClinicalColors.secondary;
              statusText = 'Booked';
            } else {
              statusColor = ClinicalColors.error;
              statusText = 'Blocked';
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ClinicalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        slot['time'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      if (slot['patient'] != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(${slot['patient']})',
                          style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (slot['status'] == 'available') {
                          slot['status'] = 'blocked';
                        } else if (slot['status'] == 'blocked') {
                          slot['status'] = 'available';
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _addCustomSlotDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Slot'),
        content: const Text('Select a custom one-time clinical slot (e.g., 05:15 PM) to open for emergency booking.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _slots.add({'time': '05:00 PM', 'status': 'available', 'patient': 'Custom Emergency Slot'});
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added 05:00 PM ad-hoc slot to schedule')),
              );
            },
            child: const Text('Add Slot'),
          ),
        ],
      ),
    );
  }

  void _blockTimeSlotDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Block Time Slot'),
        content: const Text('Choose a time slot to lock out from patient online scheduling.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Time slot locked for provider review')),
              );
            },
            child: const Text('Lock Slot'),
          ),
        ],
      ),
    );
  }

  void _blockDateDialog() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Full day outage saved for ${picked.month}/${picked.day}/${picked.year}')),
      );
    }
  }

  void _vacationLeaveDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Schedule Vacation / Leave'),
        content: const Text('Pause all patient bookings for multi-day clinical leaves or annual conferences.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave dates broadcasted to hospital roster')),
              );
            },
            child: const Text('Confirm Leave'),
          ),
        ],
      ),
    );
  }

  void _saveAvailabilitySchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Availability updated & broadcasted to St. Jude EHR!'),
          ],
        ),
        backgroundColor: ClinicalColors.tertiary,
      ),
    );
  }
}
