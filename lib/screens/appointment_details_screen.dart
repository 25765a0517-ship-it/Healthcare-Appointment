import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'appointment_confirmed_screen.dart';
import 'doctor_details_screen.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  bool _copied = false;
  Timer? _copyTimer;

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _copyId() {
    Clipboard.setData(ClipboardData(text: widget.appointment.id));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied ${widget.appointment.id} to clipboard!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ClinicalColors.tertiary,
      ),
    );
    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _joinVideoRoom() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.videocam, color: ClinicalColors.primary),
            SizedBox(width: 8),
            Text('Telehealth Room'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connecting to encrypted video room for appointment ${widget.appointment.id}...'),
            const SizedBox(height: 12),
            const Text(
              'Dr. Sarah Johnson is currently consulting. Room will auto-connect 5 minutes before scheduled slot.',
              style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video room joined! Camera and microphone active.'),
                  backgroundColor: ClinicalColors.tertiary,
                ),
              );
            },
            child: const Text('Join Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.appointment;

    return Scaffold(
      backgroundColor: ClinicalColors.surface,
      appBar: AppBar(
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appointment Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment itinerary shared!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner Card
            _buildStatusCard(app),
            const SizedBox(height: 14),

            // Video / Telehealth Callout (if video or upcoming)
            if (app.consultationType == ConsultationType.video) ...[
              _buildTelehealthCard(),
              const SizedBox(height: 14),
            ],

            // Doctor Profile Card
            _buildDoctorCard(app),
            const SizedBox(height: 14),

            // Key Details Bento Grid
            _buildBentoGrid(app),
            const SizedBox(height: 14),

            // Clinic Location & Directions
            _buildLocationCard(app),
            const SizedBox(height: 14),

            // Clinical Preparation Checklist
            _buildInstructionsCard(),
            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(app),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(Appointment app) {
    final isUpcoming = app.status == AppointmentStatus.upcoming;
    final isCancelled = app.status == AppointmentStatus.cancelled;

    Color badgeBg = ClinicalColors.tertiaryFixed;
    Color badgeText = ClinicalColors.onTertiaryFixed;
    if (isCancelled) {
      badgeBg = ClinicalColors.errorContainer;
      badgeText = ClinicalColors.onErrorContainer;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCancelled ? ClinicalColors.errorContainer : ClinicalColors.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCancelled ? Icons.cancel : Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCancelled ? 'Appointment Cancelled' : 'Appointment Confirmed',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'ID: ${app.id}',
                        style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: _copyId,
                        child: Icon(
                          _copied ? Icons.check : Icons.content_copy,
                          size: 14,
                          color: ClinicalColors.primary,
                        ),
                      ),
                      if (_copied)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            'Copied!',
                            style: TextStyle(fontSize: 11, color: ClinicalColors.tertiary, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (isUpcoming)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: ClinicalColors.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: ClinicalColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    app.countdownLabel,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.secondary),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                app.status.label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeText),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTelehealthCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ClinicalColors.primary, ClinicalColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ClinicalColors.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.videocam, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Telehealth Ready',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'HD Video consultation',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _joinVideoRoom,
            icon: const Icon(Icons.open_in_new, size: 14),
            label: const Text('Join Room', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: ClinicalColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Appointment app) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(app.doctor.imageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.doctor.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${app.doctor.specialty} · FACC',
                      style: const TextStyle(fontSize: 12, color: ClinicalColors.primary, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      app.doctor.hospital,
                      style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16, color: ClinicalColors.outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsScreen(doctor: app.doctor),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: ClinicalColors.outlineVariant),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling clinic desk: +1 (555) 234-8900')),
                    );
                  },
                  icon: const Icon(Icons.call, size: 14),
                  label: const Text('Call Clinic', style: TextStyle(fontSize: 11)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chat with Dr. Sarah open.')),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 14),
                  label: const Text('Send Message', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid(Appointment app) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date', style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
                    Text(app.dateDisplay, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text(app.dayDisplay, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Time Slot', style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
                    Text(app.timeSlot, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const Text('30 Min Duration', style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
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
                    const Text('Patient Name', style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
                    Text(app.patientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text(app.patientPhone, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Payment Status', style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
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
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ClinicalColors.tertiary),
                        ),
                      ],
                    ),
                    Text(app.paymentMethod, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Appointment app) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
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
                  app.locationOrRoom,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '450 Medical Boulevard, Suite 302, Downtown District · 1.2 km away',
            style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Google Maps navigation...')),
                );
              },
              icon: const Icon(Icons.directions, size: 16),
              label: const Text('Get Driving Directions', style: TextStyle(fontSize: 12)),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist, size: 16, color: ClinicalColors.primary),
              SizedBox(width: 6),
              Text(
                'Pre-Visit Clinical Preparation',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('• Bring valid government photo ID and previous blood work reports.',
              style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
          SizedBox(height: 4),
          Text('• For video visits, test your camera & microphone 10 mins prior.',
              style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Appointment app) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentConfirmedScreen(appointment: app),
                ),
              );
            },
            icon: const Icon(Icons.qr_code, size: 16),
            label: const Text('View Check-In Pass & QR', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
