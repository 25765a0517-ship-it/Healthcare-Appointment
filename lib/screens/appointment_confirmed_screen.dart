import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import '../widgets/main_scaffold.dart';

class AppointmentConfirmedScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentConfirmedScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentConfirmedScreen> createState() => _AppointmentConfirmedScreenState();
}

class _AppointmentConfirmedScreenState extends State<AppointmentConfirmedScreen> {
  bool _copied = false;
  Timer? _copyTimer;

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _copyReferenceId() {
    Clipboard.setData(ClipboardData(text: widget.appointment.id));
    setState(() {
      _copied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied ${widget.appointment.id} to clipboard!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ClinicalColors.tertiary,
        duration: const Duration(seconds: 2),
      ),
    );
    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  void _navigateToAppointments() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScaffold(initialTab: 2),
      ),
      (route) => false,
    );
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScaffold(initialTab: 0),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.appointment;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _navigateToHome();
      },
      child: Scaffold(
        backgroundColor: ClinicalColors.surface,
        appBar: AppBar(
          backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: ClinicalColors.onSurface),
            onPressed: _navigateToHome,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Confirmation',
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
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: ClinicalColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            children: [
              // Success Hero Moment
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ClinicalColors.secondaryFixed.withValues(alpha: 0.4),
                          ),
                        ),
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ClinicalColors.tertiary,
                            boxShadow: [
                              BoxShadow(
                                color: ClinicalColors.tertiary.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'BOOKING CONFIRMED',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: ClinicalColors.tertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "You're All Set!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Your appointment has been secured. We have sent the itinerary & receipt to your email and phone.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: ClinicalColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Digital Appointment Pass / Ticket Card
              _buildDigitalPassCard(app),
              const SizedBox(height: 20),

              // Preparation Instructions
              _buildInstructionsCard(),
              const SizedBox(height: 20),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _navigateToAppointments,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text(
                    'View in My Appointments',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Appointment saved to your device calendar!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: ClinicalColors.primary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.event_available, size: 16),
                      label: const Text('Add to Calendar', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ClinicalColors.primary,
                        side: const BorderSide(color: ClinicalColors.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Receipt downloaded as PDF'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: ClinicalColors.tertiary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Download Receipt', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ClinicalColors.secondary,
                        side: const BorderSide(color: ClinicalColors.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _navigateToHome,
                child: const Text(
                  'Return to Home Dashboard',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ClinicalColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDigitalPassCard(Appointment app) {
    return Container(
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Ticket Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: ClinicalColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified, size: 16, color: ClinicalColors.primaryFixed),
                    const SizedBox(width: 6),
                    const Text(
                      'APPOINTMENT PASS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: ClinicalColors.primaryFixed,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ClinicalColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Confirmed',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Reference ID & Copy Row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reference ID',
                            style: TextStyle(
                              fontSize: 11,
                              color: ClinicalColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            app.id,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.primary,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: _copyReferenceId,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: ClinicalColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _copied ? Icons.check : Icons.content_copy,
                                size: 14,
                                color: ClinicalColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _copied ? 'Copied' : 'Copy',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Doctor Snapshot
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(app.doctor.imageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.doctor.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSurface,
                            ),
                          ),
                          Text(
                            app.doctor.specialty,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ClinicalColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: ClinicalColors.tertiary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  app.locationOrRoom,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: ClinicalColors.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Ticket Perforation Dashed Line
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: ClinicalColors.outlineVariant,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'SCAN AT ARRIVAL',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.outline.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: ClinicalColors.outlineVariant,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2x2 Bento Details Grid
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
                                ),
                                Text(
                                  app.dateDisplay,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  app.dayDisplay,
                                  style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Time Slot',
                                  style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
                                ),
                                Text(
                                  app.timeSlot,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  '30 Min Consultation',
                                  style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1, color: ClinicalColors.outlineVariant),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Patient Name',
                                  style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
                                ),
                                Text(
                                  app.patientName,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  app.consultationType.label,
                                  style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Payment Status',
                                  style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: ClinicalColors.tertiary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Paid ₹${app.totalAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: ClinicalColors.tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  app.paymentMethod,
                                  style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Touchless QR Check-in Box
                Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ClinicalColors.outlineVariant),
                      ),
                      child: CustomPaint(
                        painter: MockQrPainter(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Self Check-In QR Code',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Scan this pass at the hospital kiosk or present to reception desk upon arrival.',
                            style: TextStyle(
                              fontSize: 11,
                              color: ClinicalColors.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ],
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

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist, size: 18, color: ClinicalColors.primary),
              SizedBox(width: 8),
              Text(
                'Pre-Visit Instructions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInstructionBullet('Please arrive 15 minutes before scheduled slot.'),
          _buildInstructionBullet('Carry a valid Government-issued Photo ID card.'),
          _buildInstructionBullet('Bring all previous medical reports, prescriptions, and ECG logs.'),
        ],
      ),
    );
  }

  Widget _buildInstructionBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: ClinicalColors.primary, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class MockQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF131B2E);
    final unit = size.width / 7;

    // Corner Finder Patterns
    canvas.drawRect(Rect.fromLTWH(0, 0, unit * 2.2, unit * 2.2), paint);
    canvas.drawRect(
      Rect.fromLTWH(size.width - unit * 2.2, 0, unit * 2.2, unit * 2.2),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - unit * 2.2, unit * 2.2, unit * 2.2),
      paint,
    );

    // Inner Dots
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(unit * 0.5, unit * 0.5, unit * 1.2, unit * 1.2), paint);
    canvas.drawRect(
      Rect.fromLTWH(size.width - unit * 1.7, unit * 0.5, unit * 1.2, unit * 1.2),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(unit * 0.5, size.height - unit * 1.7, unit * 1.2, unit * 1.2),
      paint,
    );

    paint.color = const Color(0xFF131B2E);
    canvas.drawRect(Rect.fromLTWH(unit * 0.8, unit * 0.8, unit * 0.6, unit * 0.6), paint);
    canvas.drawRect(
      Rect.fromLTWH(size.width - unit * 1.4, unit * 0.8, unit * 0.6, unit * 0.6),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(unit * 0.8, size.height - unit * 1.4, unit * 0.6, unit * 0.6),
      paint,
    );

    // Data blocks
    canvas.drawRect(Rect.fromLTWH(unit * 3, unit * 1, unit, unit), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 2.5, unit * 3, unit * 2, unit), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 5, unit * 3.5, unit, unit * 2), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 3, unit * 5, unit * 1.5, unit), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
