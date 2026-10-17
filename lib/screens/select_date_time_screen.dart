import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'appointment_type_screen.dart';

class SelectDateTimeScreen extends StatefulWidget {
  final Doctor doctor;
  final String? initialDate;
  final String? initialTimeSlot;
  final ConsultationType? initialType;

  const SelectDateTimeScreen({
    super.key,
    required this.doctor,
    this.initialDate,
    this.initialTimeSlot,
    this.initialType,
  });

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  int _selectedDateIdx = 1; // Tue 15 Oct
  String _selectedSlot = '10:30 AM';
  int _selectedFilterPeriod = 0; // 0 = All, 1 = Morning, 2 = Afternoon, 3 = Evening

  final List<Map<String, dynamic>> _availableDates = [
    {'day': 'Mon', 'date': '14', 'month': 'Oct', 'full': 'Mon, Oct 14', 'available': true},
    {'day': 'Tue', 'date': '15', 'month': 'Oct', 'full': 'Tue, Oct 15', 'available': true},
    {'day': 'Wed', 'date': '16', 'month': 'Oct', 'full': 'Wed, Oct 16', 'available': true},
    {'day': 'Thu', 'date': '17', 'month': 'Oct', 'full': 'Thu, Oct 17', 'available': true},
    {'day': 'Fri', 'date': '18', 'month': 'Oct', 'full': 'Fri, Oct 18', 'available': true},
    {'day': 'Sat', 'date': '19', 'month': 'Oct', 'full': 'Sat, Oct 19', 'available': true},
    {'day': 'Sun', 'date': '20', 'month': 'Oct', 'full': 'Sun, Oct 20', 'available': false},
  ];

  final List<Map<String, dynamic>> _morningSlots = [
    {'time': '09:00 AM', 'available': true},
    {'time': '09:30 AM', 'available': true},
    {'time': '10:00 AM', 'available': false},
    {'time': '10:30 AM', 'available': true},
    {'time': '11:00 AM', 'available': true},
    {'time': '11:30 AM', 'available': false},
  ];

  final List<Map<String, dynamic>> _afternoonSlots = [
    {'time': '02:00 PM', 'available': true},
    {'time': '02:30 PM', 'available': true},
    {'time': '03:00 PM', 'available': false},
    {'time': '03:30 PM', 'available': true},
    {'time': '04:00 PM', 'available': true},
  ];

  final List<Map<String, dynamic>> _eveningSlots = [
    {'time': '05:00 PM', 'available': true},
    {'time': '05:30 PM', 'available': true},
    {'time': '06:00 PM', 'available': false},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTimeSlot != null) {
      _selectedSlot = widget.initialTimeSlot!;
    }
  }

  void _onNext() {
    final selectedDay = _availableDates[_selectedDateIdx];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentTypeScreen(
          doctor: widget.doctor,
          selectedDate: selectedDay['full'] as String,
          selectedDayName: selectedDay['day'] as String,
          selectedTimeSlot: _selectedSlot,
          initialType: widget.initialType ?? ConsultationType.inPerson,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final selectedDay = _availableDates[_selectedDateIdx];

    return Scaffold(
      backgroundColor: ClinicalColors.surface,
      appBar: AppBar(
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            Text(
              'Step 2 of 5',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ClinicalColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: ClinicalColors.onSurfaceVariant),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stepper
            _buildStepper(),
            const SizedBox(height: 14),

            // Doctor Snapshot Banner
            _buildDoctorBanner(doctor),
            const SizedBox(height: 18),

            // Select Date Section
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                ),
                Text(
                  'October 2026',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ClinicalColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDateStrip(),
            const SizedBox(height: 22),

            // Slot Filter Segment (All, Morning, Afternoon, Evening)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Time Slots',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: ClinicalColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      '30 min slot',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ClinicalColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildPeriodChips(),
            const SizedBox(height: 16),

            // Time Slots Grid
            _buildTimeSlots(),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(selectedDay),
    );
  }

  Widget _buildStepper() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: ClinicalColors.tertiaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: ClinicalColors.onTertiaryFixed),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Doctor',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.tertiary,
                  ),
                ),
              ],
            ),
            Container(width: 16, height: 2, color: ClinicalColors.tertiaryFixed),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: ClinicalColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Date & Time',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.primary,
                  ),
                ),
              ],
            ),
            Container(width: 16, height: 2, color: ClinicalColors.surfaceContainerHighest),
            Text(
              'Type',
              style: TextStyle(fontSize: 11, color: ClinicalColors.outline.withValues(alpha: 0.8)),
            ),
            Container(width: 16, height: 2, color: ClinicalColors.surfaceContainerHighest),
            Text(
              'Details',
              style: TextStyle(fontSize: 11, color: ClinicalColors.outline.withValues(alpha: 0.8)),
            ),
            Container(width: 16, height: 2, color: ClinicalColors.surfaceContainerHighest),
            Text(
              'Confirm',
              style: TextStyle(fontSize: 11, color: ClinicalColors.outline.withValues(alpha: 0.8)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: 0.40,
            minHeight: 4,
            backgroundColor: ClinicalColors.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(ClinicalColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorBanner(Doctor doctor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(doctor.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 14, color: ClinicalColors.primary),
                  ],
                ),
                Text(
                  '${doctor.specialty} · ${doctor.hospital}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: ClinicalColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ClinicalColors.tertiaryFixed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, size: 12, color: ClinicalColors.onTertiaryFixed),
                SizedBox(width: 2),
                Text(
                  'Instant Hold',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onTertiaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStrip() {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _availableDates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final item = _availableDates[idx];
          final isSelected = _selectedDateIdx == idx;
          final isAvailable = item['available'] as bool;

          return GestureDetector(
            onTap: isAvailable
                ? () {
                    setState(() {
                      _selectedDateIdx = idx;
                    });
                  }
                : null,
            child: Opacity(
              opacity: isAvailable ? 1.0 : 0.4,
              child: Container(
                width: 62,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ClinicalColors.primary
                      : ClinicalColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? ClinicalColors.primary : ClinicalColors.outlineVariant,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: ClinicalColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['day'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white70 : ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['date'] as String,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : ClinicalColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['month'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white70 : ClinicalColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodChips() {
    final periods = ['All Slots', 'Morning', 'Afternoon', 'Evening'];
    return Row(
      children: List.generate(periods.length, (idx) {
        final isSelected = _selectedFilterPeriod == idx;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: ChoiceChip(
            label: Text(periods[idx]),
            selected: isSelected,
            selectedColor: ClinicalColors.primaryFixed,
            backgroundColor: ClinicalColors.surfaceContainerLow,
            labelStyle: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? ClinicalColors.primary : ClinicalColors.onSurface,
            ),
            onSelected: (val) {
              if (val) {
                setState(() => _selectedFilterPeriod = idx);
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildTimeSlots() {
    List<Widget> sections = [];

    if (_selectedFilterPeriod == 0 || _selectedFilterPeriod == 1) {
      sections.add(_buildSlotGroup('Morning Slots (09:00 AM – 12:00 PM)', _morningSlots));
    }
    if (_selectedFilterPeriod == 0 || _selectedFilterPeriod == 2) {
      sections.add(_buildSlotGroup('Afternoon Slots (02:00 PM – 04:30 PM)', _afternoonSlots));
    }
    if (_selectedFilterPeriod == 0 || _selectedFilterPeriod == 3) {
      sections.add(_buildSlotGroup('Evening Slots (05:00 PM – 07:00 PM)', _eveningSlots));
    }

    return Column(children: sections);
  }

  Widget _buildSlotGroup(String title, List<Map<String, dynamic>> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ClinicalColors.onSurfaceVariant,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final time = slot['time'] as String;
            final isAvailable = slot['available'] as bool;
            final isSelected = _selectedSlot == time;

            return InkWell(
              onTap: isAvailable
                  ? () {
                      setState(() {
                        _selectedSlot = time;
                      });
                    }
                  : null,
              borderRadius: BorderRadius.circular(10),
              child: Opacity(
                opacity: isAvailable ? 1.0 : 0.35,
                child: Container(
                  width: 104,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ClinicalColors.primary
                        : (isAvailable
                            ? ClinicalColors.surfaceContainerLowest
                            : ClinicalColors.surfaceContainerLow),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? ClinicalColors.primary : ClinicalColors.outlineVariant,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : ClinicalColors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBottomBar(Map<String, dynamic> selectedDay) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Slot',
                  style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                ),
                Text(
                  '${selectedDay['full']} · $_selectedSlot',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _onNext,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text(
                    'Next: Select Type',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
