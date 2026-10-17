import 'dart:async';
import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import '../widgets/main_scaffold.dart';
import 'processing_payment_screen.dart';

class PaymentFailedScreen extends StatefulWidget {
  final Doctor doctor;
  final String selectedDate;
  final String selectedDayName;
  final String selectedTimeSlot;
  final ConsultationType consultationType;
  final double totalAmount;
  final String paymentMethod;
  final String errorCode;
  final String errorMessage;

  const PaymentFailedScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedDayName,
    required this.selectedTimeSlot,
    required this.consultationType,
    required this.totalAmount,
    required this.paymentMethod,
    this.errorCode = 'ERR_BANK_TIMEOUT',
    this.errorMessage = 'Bank server did not respond in time',
  });

  @override
  State<PaymentFailedScreen> createState() => _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends State<PaymentFailedScreen> {
  Timer? _countdownTimer;
  int _secondsRemaining = 9 * 60 + 45; // 09:45

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String get _formattedCountdown {
    final mins = _secondsRemaining ~/ 60;
    final secs = _secondsRemaining % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _retryPayment() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessingPaymentScreen(
          doctor: widget.doctor,
          selectedDate: widget.selectedDate,
          selectedDayName: widget.selectedDayName,
          selectedTimeSlot: widget.selectedTimeSlot,
          consultationType: widget.consultationType,
          totalAmount: widget.totalAmount,
          paymentMethod: widget.paymentMethod,
          paymentOptionType: PaymentOptionType.upi,
        ),
      ),
    );
  }

  void _changePaymentMethod() {
    Navigator.pop(context);
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
            icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
            onPressed: _navigateToHome,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Failed',
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          child: Column(
            children: [
              // Error Hero Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: ClinicalColors.errorContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error,
                        color: ClinicalColors.error,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ClinicalColors.error,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sync_problem, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'TRANSACTION INCOMPLETE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Payment Unsuccessful',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'We couldn\'t process your payment of ₹${widget.totalAmount.toStringAsFixed(0)} for ${widget.doctor.name}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: ClinicalColors.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // No Money Deducted Pill
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLowest.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.verified_user,
                            size: 18,
                            color: ClinicalColors.tertiary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'No money was deducted',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ClinicalColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'If your account was debited, the amount will be automatically refunded within 2–3 business days.',
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Slot Hold Countdown Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: ClinicalColors.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.timer,
                                  color: ClinicalColors.onPrimaryContainer,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Slot Reserved For',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: ClinicalColors.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    _formattedCountdown,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ClinicalColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: ClinicalColors.tertiaryFixed,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Slot Held',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: ClinicalColors.onTertiaryFixed,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${widget.selectedDate}, ${widget.selectedTimeSlot}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: ClinicalColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Error Reason details
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.report, size: 20, color: ClinicalColors.error),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Error Reason',
                                  style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
                                ),
                                Text(
                                  widget.errorCode,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ClinicalColors.error,
                                  ),
                                ),
                                Text(
                                  widget.errorMessage,
                                  style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Attempted Method
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_balance_wallet, size: 20, color: ClinicalColors.secondary),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Attempted Method',
                                    style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
                                  ),
                                  Text(
                                    widget.paymentMethod,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ClinicalColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.smartphone, size: 18, color: ClinicalColors.outline),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _retryPayment,
                  icon: const Icon(Icons.replay, size: 18),
                  label: Text(
                    'Retry Payment (₹${widget.totalAmount.toStringAsFixed(0)})',
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
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _changePaymentMethod,
                  icon: const Icon(Icons.credit_card, size: 18),
                  label: const Text(
                    'Choose Another Payment Method',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalColors.secondaryFixed,
                    foregroundColor: ClinicalColors.onSecondaryFixedVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Need Immediate Assistance
              Container(
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
                        Icon(Icons.support_agent, size: 18, color: ClinicalColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Need immediate assistance?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Calling Bank Support (1800-555-0199)...')),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: ClinicalColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.call, size: 16, color: ClinicalColors.primary),
                                  SizedBox(width: 6),
                                  Text(
                                    'Bank Support',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ClinicalColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Calling Clinic Desk (1800-555-0123)...')),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: ClinicalColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_hospital, size: 16, color: ClinicalColors.primary),
                                  SizedBox(width: 6),
                                  Text(
                                    'Clinic Desk',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ClinicalColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _navigateToHome,
                child: const Text(
                  'Cancel & Return Home',
                  style: TextStyle(
                    fontSize: 13,
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
}
