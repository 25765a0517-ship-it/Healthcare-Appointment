import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'patient_details_screen.dart';

class AppointmentTypeScreen extends StatefulWidget {
  final Doctor doctor;
  final String selectedDate;
  final String selectedDayName;
  final String selectedTimeSlot;
  final ConsultationType initialType;

  const AppointmentTypeScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedDayName,
    required this.selectedTimeSlot,
    this.initialType = ConsultationType.inPerson,
  });

  @override
  State<AppointmentTypeScreen> createState() => _AppointmentTypeScreenState();
}

class _AppointmentTypeScreenState extends State<AppointmentTypeScreen> {
  late ConsultationType _selectedType;

  final Map<ConsultationType, double> _fees = {
    ConsultationType.inPerson: 500.0,
    ConsultationType.video: 450.0,
    ConsultationType.phone: 350.0,
  };

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  double get _currentFee => _fees[_selectedType] ?? 500.0;

  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(
          doctor: widget.doctor,
          selectedDate: widget.selectedDate,
          selectedDayName: widget.selectedDayName,
          selectedTimeSlot: widget.selectedTimeSlot,
          consultationType: _selectedType,
          consultationFee: _currentFee,
        ),
      ),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Appointment Type',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            Text(
              'Step 3 of 5',
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
            // Stepper Indicator
            _buildStepper(),
            const SizedBox(height: 14),

            // Context Summary Strip
            _buildContextSummary(),
            const SizedBox(height: 18),

            // Title & Subtitle
            const Text(
              'Select appointment type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose how you would like to connect with your doctor',
              style: TextStyle(
                fontSize: 13,
                color: ClinicalColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),

            // 1. In-Person Visit Card
            _buildTypeCard(
              type: ConsultationType.inPerson,
              icon: Icons.local_hospital,
              title: 'In-Person Visit',
              subtitle: '${widget.doctor.hospital} · Downtown',
              bullets: [
                'Full comprehensive physical examination',
                'In-clinic diagnostics (ECG, vitals & blood pressure)',
                'Direct, focused physician interaction',
              ],
              footerNote: 'Arrive 15 min prior to check in',
              price: '₹500.00',
            ),
            const SizedBox(height: 14),

            // 2. Video Consultation Card
            _buildTypeCard(
              type: ConsultationType.video,
              icon: Icons.videocam,
              title: 'Video Consultation',
              subtitle: 'Secure HD Video via CareFlow Telehealth',
              bullets: [
                'Join comfortably from home or office',
                'Instant digital prescription & clinical notes',
                'Zero travel & waiting room friction',
              ],
              footerNote: 'Encrypted HD telehealth room link sent via SMS',
              price: '₹450.00',
            ),
            const SizedBox(height: 14),

            // 3. Phone Consultation Card
            _buildTypeCard(
              type: ConsultationType.phone,
              icon: Icons.call,
              title: 'Phone Consultation',
              subtitle: 'Direct Voice Call with Physician',
              bullets: [
                'Ideal for follow-ups, test reviews & quick questions',
                'Prescription renewals and medication adjustment',
                'Works anywhere without high-speed internet',
              ],
              footerNote: 'Physician will call your registered number',
              price: '₹350.00',
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(),
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
                const Text('Doctor', style: TextStyle(fontSize: 11, color: ClinicalColors.tertiary)),
              ],
            ),
            Container(width: 12, height: 2, color: ClinicalColors.tertiaryFixed),
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
                const Text('Date/Time', style: TextStyle(fontSize: 11, color: ClinicalColors.tertiary)),
              ],
            ),
            Container(width: 12, height: 2, color: ClinicalColors.primaryFixed),
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
                    child: Text('3', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Type', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.primary)),
              ],
            ),
            Container(width: 12, height: 2, color: ClinicalColors.surfaceContainerHighest),
            Text('Details', style: TextStyle(fontSize: 11, color: ClinicalColors.outline.withValues(alpha: 0.8))),
            Container(width: 12, height: 2, color: ClinicalColors.surfaceContainerHighest),
            Text('Confirm', style: TextStyle(fontSize: 11, color: ClinicalColors.outline.withValues(alpha: 0.8))),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: 0.60,
            minHeight: 4,
            backgroundColor: ClinicalColors.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(ClinicalColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildContextSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.doctor.imageUrl),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurface,
                    ),
                  ),
                  Text(
                    '${widget.selectedDate} · ${widget.selectedTimeSlot}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock, size: 12, color: ClinicalColors.primary),
                SizedBox(width: 4),
                Text(
                  'Slot Held',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required ConsultationType type,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> bullets,
    required String footerNote,
    required String price,
  }) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? ClinicalColors.surfaceContainerHigh
              : ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? ClinicalColors.primary : ClinicalColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ClinicalColors.primary.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ClinicalColors.primary
                        : ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected ? Colors.white : ClinicalColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.onSurface,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? ClinicalColors.primary : ClinicalColors.outline,
                      width: 2,
                    ),
                    color: isSelected ? ClinicalColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(Icons.check, size: 14, color: Colors.white),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bullets
            ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 14, color: ClinicalColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          b,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ClinicalColors.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 10),

            // Footer info & price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? ClinicalColors.surfaceContainerLowest
                    : ClinicalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: ClinicalColors.tertiary),
                      const SizedBox(width: 6),
                      Text(
                        footerNote,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
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
                  'Consultation Fee',
                  style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                ),
                Text(
                  '₹${_currentFee.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _onNext,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text(
                    'Next: Patient Details',
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
