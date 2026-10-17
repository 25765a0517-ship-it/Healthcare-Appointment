import 'dart:async';
import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../data/mock_healthcare_data.dart';
import '../theme/app_theme.dart';
import 'appointment_confirmed_screen.dart';
import 'payment_failed_screen.dart';
import 'booking_cancelled_screen.dart';

class ProcessingPaymentScreen extends StatefulWidget {
  final Doctor doctor;
  final String selectedDate;
  final String selectedDayName;
  final String selectedTimeSlot;
  final ConsultationType consultationType;
  final double totalAmount;
  final String paymentMethod;
  final PaymentOptionType paymentOptionType;

  const ProcessingPaymentScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedDayName,
    required this.selectedTimeSlot,
    required this.consultationType,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentOptionType,
  });

  @override
  State<ProcessingPaymentScreen> createState() => _ProcessingPaymentScreenState();
}

class _ProcessingPaymentScreenState extends State<ProcessingPaymentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  Timer? _progressTimer;
  double _progressValue = 0.15;
  String _stepLabel = 'Connecting to bank network...';
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _startSimulatedProgress();
  }

  void _startSimulatedProgress() {
    // Stage 1
    _progressTimer = Timer(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _progressValue = 0.45;
        _stepLabel = 'Verifying 3D Secure credentials...';
      });

      // Stage 2
      _progressTimer = Timer(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        setState(() {
          _progressValue = 0.85;
          _stepLabel = 'Securing appointment with ${widget.doctor.hospital}...';
        });

        // Stage 3
        _progressTimer = Timer(const Duration(milliseconds: 1200), () {
          if (!mounted) return;
          setState(() {
            _progressValue = 1.0;
            _stepLabel = 'Transaction verified & approved!';
          });

          // Navigate to Confirmation
          _progressTimer = Timer(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            _completeSuccess();
          });
        });
      });
    });
  }

  void _completeSuccess() {
    if (_isNavigating) return;
    _isNavigating = true;

    // Create and add appointment into AppointmentRepository
    final newId = '#CF-${(100000 + (DateTime.now().millisecondsSinceEpoch % 899999))}';
    final location = widget.consultationType == ConsultationType.inPerson
        ? 'In-Person Consultation · ${widget.doctor.hospital}'
        : 'Video Consultation · Telehealth Room';

    final newAppointment = Appointment(
      id: newId,
      doctor: widget.doctor,
      patientName: 'Alex Morgan',
      date: DateTime.now(),
      dateDisplay: widget.selectedDate,
      dayDisplay: widget.selectedDayName,
      timeSlot: widget.selectedTimeSlot,
      consultationType: widget.consultationType,
      locationOrRoom: location,
      status: AppointmentStatus.upcoming,
      consultationFee: widget.totalAmount,
      bookingFee: 0,
      totalAmount: widget.totalAmount,
      paymentMethod: widget.paymentMethod,
      isPaid: widget.paymentOptionType != PaymentOptionType.clinic,
      countdownLabel: 'Confirmed',
    );

    AppointmentRepository.addAppointment(newAppointment);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentConfirmedScreen(
          appointment: newAppointment,
        ),
      ),
    );
  }

  void _simulateFailure() {
    if (_isNavigating) return;
    _isNavigating = true;
    _progressTimer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFailedScreen(
          doctor: widget.doctor,
          selectedDate: widget.selectedDate,
          selectedDayName: widget.selectedDayName,
          selectedTimeSlot: widget.selectedTimeSlot,
          consultationType: widget.consultationType,
          totalAmount: widget.totalAmount,
          paymentMethod: widget.paymentMethod,
          errorCode: 'ERR_BANK_TIMEOUT',
          errorMessage: 'Bank server did not respond in time',
        ),
      ),
    );
  }

  void _simulateCancel() {
    if (_isNavigating) return;
    _isNavigating = true;
    _progressTimer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingCancelledScreen(
          doctor: widget.doctor,
          selectedDate: widget.selectedDate,
          selectedTimeSlot: widget.selectedTimeSlot,
          reason: 'Session cancelled by user',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _simulateCancel();
        }
      },
      child: Scaffold(
        backgroundColor: ClinicalColors.surface,
        appBar: AppBar(
          backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
            onPressed: _simulateCancel,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Processing',
                style: TextStyle(
                  color: ClinicalColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.lock, size: 12, color: ClinicalColors.tertiary),
                  const SizedBox(width: 4),
                  Text(
                    'HIPAA 256-Bit Encrypted',
                    style: TextStyle(
                      fontSize: 11,
                      color: ClinicalColors.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Ambient Beacon & Radial Pulse Container
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient Glowing Bubble
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 170 * _pulseAnimation.value,
                            height: 170 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ClinicalColors.secondaryFixed.withValues(alpha: 0.25),
                            ),
                          );
                        },
                      ),
                      // Outer circular progress ring
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: _progressValue,
                          strokeWidth: 5,
                          backgroundColor: ClinicalColors.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            ClinicalColors.primary,
                          ),
                        ),
                      ),
                      // Center Emblem with Verified Shield
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: ClinicalColors.surfaceContainerLowest,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: ClinicalColors.primaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user,
                              color: ClinicalColors.primary,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title & Advisory
              const Text(
                'Processing payment...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please do not refresh, close the app, or press the back button.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: ClinicalColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              // Real-time Status Stepper Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                    Text(
                      _stepLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ClinicalColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Linear Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progressValue,
                  minHeight: 6,
                  backgroundColor: ClinicalColors.surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ClinicalColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(_progressValue * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                  const Text(
                    'Securing transaction',
                    style: TextStyle(
                      fontSize: 12,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Transaction Details Mini-Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 11,
                                color: ClinicalColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '₹${widget.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: ClinicalColors.tertiaryContainer.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.verified, size: 14, color: ClinicalColors.tertiary),
                              SizedBox(width: 4),
                              Text(
                                'Verified Request',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: ClinicalColors.outlineVariant),

                    // Payee Info
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: ClinicalColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.local_hospital,
                            color: ClinicalColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Paying To',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ClinicalColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                widget.doctor.hospital,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${widget.doctor.name} · Consultation',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: ClinicalColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Payment Method Row
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: ClinicalColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: ClinicalColors.onSecondaryFixedVariant,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Method',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ClinicalColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                widget.paymentMethod,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.bolt, size: 16, color: ClinicalColors.tertiary),
                            Text(
                              'Instant',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Simulation testing options (helpful for testing error states)
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: ClinicalColors.surfaceContainerLowest,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (ctx) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Test Outcome Simulation',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You can test different transaction branches:',
                              style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.check_circle, color: ClinicalColors.tertiary),
                              title: const Text('Simulate Immediate Success'),
                              onTap: () {
                                Navigator.pop(ctx);
                                _completeSuccess();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.error_outline, color: ClinicalColors.error),
                              title: const Text('Simulate Payment Failure'),
                              onTap: () {
                                Navigator.pop(ctx);
                                _simulateFailure();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.cancel_outlined, color: ClinicalColors.outline),
                              title: const Text('Simulate Booking Cancelled'),
                              onTap: () {
                                Navigator.pop(ctx);
                                _simulateCancel();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.tune, size: 16, color: ClinicalColors.outline),
                label: const Text(
                  'Simulation options',
                  style: TextStyle(fontSize: 12, color: ClinicalColors.outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
