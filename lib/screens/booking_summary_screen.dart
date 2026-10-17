import 'dart:async';
import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'complete_payment_screen.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Doctor doctor;
  final String selectedDate;
  final String selectedDayName;
  final String selectedTimeSlot;
  final ConsultationType consultationType;
  final double consultationFee;
  final String patientName;
  final String patientPhone;
  final int patientAge;
  final String patientGender;
  final String reasonForVisit;
  final List<String> symptoms;
  final String? notes;
  final String? attachedFile;

  const BookingSummaryScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedDayName,
    required this.selectedTimeSlot,
    required this.consultationType,
    required this.consultationFee,
    required this.patientName,
    required this.patientPhone,
    required this.patientAge,
    required this.patientGender,
    required this.reasonForVisit,
    required this.symptoms,
    this.notes,
    this.attachedFile,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  Timer? _slotTimer;
  int _secondsLeft = 9 * 60 + 54; // 09:54

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _slotTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _secondsLeft--;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _slotTimer?.cancel();
    super.dispose();
  }

  String get _formattedCountdown {
    final mins = _secondsLeft ~/ 60;
    final secs = _secondsLeft % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _proceedToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletePaymentScreen(
          doctor: widget.doctor,
          selectedDate: widget.selectedDate,
          selectedDayName: widget.selectedDayName,
          selectedTimeSlot: widget.selectedTimeSlot,
          consultationType: widget.consultationType,
          consultationFee: widget.consultationFee,
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
              'Review & Confirm',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            Text(
              'Step 5 of 5',
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
            // Stepper (100%)
            _buildStepper(),
            const SizedBox(height: 14),

            // Slot Held Countdown Timer
            _buildUrgencyTimer(),
            const SizedBox(height: 18),

            // Heading
            Row(
              children: [
                const Text(
                  'Review & confirm booking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: ClinicalColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock, size: 14, color: ClinicalColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Verify your clinical appointment details before finalizing your slot.',
              style: TextStyle(
                fontSize: 12,
                color: ClinicalColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),

            // Card 1: Doctor & Appointment Details
            _buildDoctorCard(),
            const SizedBox(height: 14),

            // Card 2: Patient Info Card
            _buildPatientCard(),
            const SizedBox(height: 14),

            // Card 3: Clinic Location & Instructions
            _buildClinicDetailsCard(),
            const SizedBox(height: 14),

            // Card 4: Fee Breakdown
            _buildFeeCard(),
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
                Icon(Icons.verified, size: 16, color: ClinicalColors.primary),
                const SizedBox(width: 4),
                const Text(
                  'Step 5 of 5: Final Review',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.primary),
                ),
              ],
            ),
            const Text(
              '100% Completed',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.tertiary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: 1.0,
            minHeight: 4,
            backgroundColor: ClinicalColors.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(ClinicalColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencyTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: ClinicalColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.alarm, color: ClinicalColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Slot Held in Real-Time',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Release in $_formattedCountdown if unconfirmed',
                    style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ClinicalColors.tertiaryFixed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'RESERVED',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onTertiaryFixed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard() {
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
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(widget.doctor.imageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.doctor.specialty} · ${widget.doctor.hospital}',
                      style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: ClinicalColors.outlineVariant),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: ClinicalColors.primary),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date', style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
                        Text(widget.selectedDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: ClinicalColors.primary),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Time Slot', style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
                        Text(widget.selectedTimeSlot, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                widget.consultationType == ConsultationType.inPerson
                    ? Icons.meeting_room
                    : (widget.consultationType == ConsultationType.video ? Icons.videocam : Icons.call),
                size: 16,
                color: ClinicalColors.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.consultationType.label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ClinicalColors.onSurface),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Patient Information',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Edit',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Name', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
              Text(widget.patientName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Contact Phone', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
              Text(widget.patientPhone, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Age & Gender', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
              Text('${widget.patientAge} Yrs · ${widget.patientGender}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Reason', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  widget.reasonForVisit,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          if (widget.symptoms.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.symptoms
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ClinicalColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(s, style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
                      ))
                  .toList(),
            ),
          ],
          if (widget.attachedFile != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.attach_file, size: 14, color: ClinicalColors.primary),
                const SizedBox(width: 4),
                Text(
                  widget.attachedFile!,
                  style: const TextStyle(fontSize: 11, color: ClinicalColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClinicDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: ClinicalColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.consultationType == ConsultationType.inPerson
                      ? 'St. Jude Heart Clinic · Floor 3, Rm 304'
                      : 'CareFlow Telehealth Room (Online)',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.consultationType == ConsultationType.inPerson
                ? '450 Medical Boulevard, Suite 302, Downtown Medical District. Free clinic parking available.'
                : 'A secure high-definition encrypted video link will be sent to your phone and email 15 minutes before slot time.',
            style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Consultation Fee', style: TextStyle(fontSize: 13, color: ClinicalColors.onSurfaceVariant)),
              Text('₹${widget.consultationFee.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Clinic Convenience Fee',
                      style: TextStyle(fontSize: 13, color: ClinicalColors.onSurfaceVariant)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: ClinicalColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('WAIVED',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalColors.onTertiaryFixed)),
                  ),
                ],
              ),
              const Text('₹0.00',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ClinicalColors.tertiary)),
            ],
          ),
          const Divider(height: 20, color: ClinicalColors.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Payable', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(
                '₹${widget.consultationFee.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalColors.primary),
              ),
            ],
          ),
        ],
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
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _proceedToCheckout,
            icon: const Icon(Icons.lock, size: 16),
            label: Text(
              'Proceed to Payment (₹${widget.consultationFee.toStringAsFixed(0)})',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
    );
  }
}
