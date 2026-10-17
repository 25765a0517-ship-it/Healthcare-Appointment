import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'processing_payment_screen.dart';

class CompletePaymentScreen extends StatefulWidget {
  final Doctor doctor;
  final String selectedDate;
  final String selectedDayName;
  final String selectedTimeSlot;
  final ConsultationType consultationType;
  final double consultationFee;

  const CompletePaymentScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedDayName,
    required this.selectedTimeSlot,
    required this.consultationType,
    required this.consultationFee,
  });

  @override
  State<CompletePaymentScreen> createState() => _CompletePaymentScreenState();
}

class _CompletePaymentScreenState extends State<CompletePaymentScreen> {
  PaymentOptionType _selectedMethod = PaymentOptionType.upi;
  String _selectedUpiApp = 'Google Pay';
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _voucherController = TextEditingController();

  bool _saveCard = true;
  String? _appliedVoucher;
  double _voucherDiscount = 0.0;
  String? _voucherError;
  String _selectedBank = 'HDFC Bank';

  final List<Map<String, String>> _upiApps = [
    {'name': 'Google Pay', 'icon': 'GPay'},
    {'name': 'PhonePe', 'icon': 'PhonePe'},
    {'name': 'Paytm', 'icon': 'Paytm'},
    {'name': 'BHIM UPI', 'icon': 'BHIM'},
  ];

  final List<String> _popularBanks = [
    'HDFC Bank',
    'State Bank of India',
    'ICICI Bank',
    'Axis Bank',
  ];

  @override
  void dispose() {
    _upiIdController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  double get _totalPayable =>
      (widget.consultationFee - _voucherDiscount).clamp(0.0, 99999.0);

  void _applyVoucher() {
    final code = _voucherController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'CARE10' || code == 'FIRSTCARE') {
      setState(() {
        _appliedVoucher = code;
        _voucherDiscount = 50.0;
        _voucherError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voucher $code applied! ₹50.00 saved.'),
          backgroundColor: ClinicalColors.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _voucherError = 'Invalid code. Try "CARE10" or "FIRSTCARE"';
      });
    }
  }

  void _proceedToPay() {
    String paymentMethodName = 'UPI · $_selectedUpiApp';
    if (_selectedMethod == PaymentOptionType.card) {
      paymentMethodName = 'Credit / Debit Card (Ending in 4242)';
    } else if (_selectedMethod == PaymentOptionType.netbanking) {
      paymentMethodName = 'Net Banking ($_selectedBank)';
    } else if (_selectedMethod == PaymentOptionType.clinic) {
      paymentMethodName = 'Pay at Clinic (Reception)';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessingPaymentScreen(
          doctor: widget.doctor,
          selectedDate: widget.selectedDate,
          selectedDayName: widget.selectedDayName,
          selectedTimeSlot: widget.selectedTimeSlot,
          consultationType: widget.consultationType,
          totalAmount: _totalPayable,
          paymentMethod: paymentMethodName,
          paymentOptionType: _selectedMethod,
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
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Checkout',
              style: TextStyle(
                color: ClinicalColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stepper Indicator
            _buildStepper(),
            const SizedBox(height: 16),

            // Appointment Summary Card
            _buildSummaryCard(),
            const SizedBox(height: 20),

            // Promo Code Card
            _buildPromoCodeSection(),
            const SizedBox(height: 20),

            // Payment Options Section
            _buildPaymentOptionsSection(),
            const SizedBox(height: 20),

            // Cancellation Policy Pill
            _buildCancellationPolicy(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomSheet: _buildBottomPayBar(),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: ClinicalColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Final Step • Secure Checkout',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ClinicalColors.onSurface,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 24,
                height: 6,
                decoration: BoxDecoration(
                  color: ClinicalColors.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 24,
                height: 6,
                decoration: BoxDecoration(
                  color: ClinicalColors.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 24,
                height: 6,
                decoration: BoxDecoration(
                  color: ClinicalColors.primaryContainer,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor snapshot
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(widget.doctor.imageUrl),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.doctor.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ClinicalColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'MD, FACC',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSecondaryFixed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.doctor.specialty} · ${widget.doctor.hospital}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date / Time / Type Bento Row
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
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: ClinicalColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ClinicalColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                widget.selectedDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 16,
                            color: ClinicalColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Time Slot',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ClinicalColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                widget.selectedTimeSlot,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.onSurface,
                                ),
                              ),
                            ],
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
                    Icon(
                      widget.consultationType == ConsultationType.inPerson
                          ? Icons.meeting_room
                          : Icons.videocam,
                      size: 16,
                      color: ClinicalColors.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.consultationType == ConsultationType.inPerson
                            ? 'In-Person Consultation (Room 304B)'
                            : 'Telehealth Video Consultation (HD Call)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ClinicalColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Fee breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Doctor Consultation Fee',
                style: TextStyle(
                  fontSize: 13,
                  color: ClinicalColors.onSurfaceVariant,
                ),
              ),
              Text(
                '₹${widget.consultationFee.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ClinicalColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Clinic Booking Fee',
                    style: TextStyle(
                      fontSize: 13,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: ClinicalColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'WAIVED',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onTertiaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                '₹0.00',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ClinicalColors.tertiary,
                ),
              ),
            ],
          ),
          if (_appliedVoucher != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Promo Discount ($_appliedVoucher)',
                  style: const TextStyle(
                    fontSize: 13,
                    color: ClinicalColors.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '-₹${_voucherDiscount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.tertiary,
                  ),
                ),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: ClinicalColors.outlineVariant),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
              Text(
                '₹${_totalPayable.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: const EdgeInsets.all(14),
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
              const Row(
                children: [
                  Icon(Icons.local_offer_outlined, size: 16, color: ClinicalColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Apply Coupon / Voucher',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurface,
                    ),
                  ),
                ],
              ),
              if (_appliedVoucher != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _appliedVoucher = null;
                      _voucherDiscount = 0.0;
                      _voucherController.clear();
                    });
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.error,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _voucherController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Try CARE10 or FIRSTCARE',
                    hintStyle: const TextStyle(fontSize: 13, color: ClinicalColors.outline),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    filled: true,
                    fillColor: ClinicalColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ClinicalColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          if (_voucherError != null) ...[
            const SizedBox(height: 6),
            Text(
              _voucherError!,
              style: const TextStyle(fontSize: 11, color: ClinicalColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Payment Option',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            Row(
              children: [
                Icon(Icons.bolt, size: 14, color: ClinicalColors.tertiary),
                const SizedBox(width: 2),
                Text(
                  'Zero Extra Charges',
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
        const SizedBox(height: 12),

        // 1. UPI Option
        _buildPaymentOptionTile(
          type: PaymentOptionType.upi,
          title: 'UPI / Instant Pay',
          subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
          badgeText: 'Fastest',
          badgeColor: ClinicalColors.primary,
          child: _buildUpiExpandedContent(),
        ),
        const SizedBox(height: 10),

        // 2. Card Option
        _buildPaymentOptionTile(
          type: PaymentOptionType.card,
          title: 'Credit / Debit Card',
          subtitle: 'Visa, MasterCard, RuPay, Amex',
          badgeText: 'Secure',
          badgeColor: ClinicalColors.secondary,
          child: _buildCardExpandedContent(),
        ),
        const SizedBox(height: 10),

        // 3. Net Banking
        _buildPaymentOptionTile(
          type: PaymentOptionType.netbanking,
          title: 'Net Banking',
          subtitle: 'All major Indian & international banks',
          child: _buildNetBankingExpandedContent(),
        ),
        const SizedBox(height: 10),

        // 4. Pay at Clinic
        _buildPaymentOptionTile(
          type: PaymentOptionType.clinic,
          title: 'Pay at Clinic Desk',
          subtitle: 'Cash, Card, or UPI on arrival before visit',
          badgeText: 'Zero Advance',
          badgeColor: ClinicalColors.tertiary,
        ),
      ],
    );
  }

  Widget _buildPaymentOptionTile({
    required PaymentOptionType type,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    Widget? child,
  }) {
    final isSelected = _selectedMethod == type;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? ClinicalColors.surfaceContainerLowest
            : ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? ClinicalColors.primary : Colors.transparent,
          width: 1.5,
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
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _selectedMethod = type;
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? ClinicalColors.primary
                            : ClinicalColors.outline,
                        width: 2,
                      ),
                      color: isSelected
                          ? ClinicalColors.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Center(
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.onSurface,
                              ),
                            ),
                            if (badgeText != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeColor ?? ClinicalColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  badgeText,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected && child != null) ...[
            const Divider(height: 1, color: ClinicalColors.outlineVariant),
            Padding(
              padding: const EdgeInsets.all(14),
              child: child,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpiExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Instant UPI App',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ClinicalColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _upiApps.map((app) {
            final isAppSelected = _selectedUpiApp == app['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedUpiApp = app['name']!;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isAppSelected
                      ? ClinicalColors.primaryFixed
                      : ClinicalColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isAppSelected
                        ? ClinicalColors.primary
                        : ClinicalColors.outlineVariant,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 20,
                      color: isAppSelected
                          ? ClinicalColors.primary
                          : ClinicalColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app['name']!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isAppSelected
                            ? ClinicalColors.primary
                            : ClinicalColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        const Text(
          'Or enter VPA / UPI ID',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ClinicalColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _upiIdController,
          decoration: InputDecoration(
            hintText: 'alexmorgan@okhdfcbank',
            hintStyle: const TextStyle(fontSize: 12, color: ClinicalColors.outline),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: ClinicalColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.verified_user, size: 18, color: ClinicalColors.tertiary),
          ),
        ),
      ],
    );
  }

  Widget _buildCardExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '4532 •••• •••• 8912',
            labelText: 'Card Number',
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: ClinicalColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.credit_card, size: 20, color: ClinicalColors.primary),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cardExpiryController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'MM/YY',
                  labelText: 'Expiry Date',
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: ClinicalColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _cardCvvController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'CVV',
                  labelText: 'Security Code',
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: ClinicalColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _saveCard,
                activeColor: ClinicalColors.primary,
                onChanged: (val) {
                  setState(() {
                    _saveCard = val ?? true;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Save this card securely for faster checkout',
              style: TextStyle(
                fontSize: 12,
                color: ClinicalColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetBankingExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularBanks.map((bank) {
            final isBankSelected = _selectedBank == bank;
            return ChoiceChip(
              label: Text(bank),
              selected: isBankSelected,
              selectedColor: ClinicalColors.primaryFixed,
              backgroundColor: ClinicalColors.surfaceContainerLow,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isBankSelected ? FontWeight.bold : FontWeight.normal,
                color: isBankSelected ? ClinicalColors.primary : ClinicalColors.onSurface,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedBank = bank;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCancellationPolicy() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ClinicalColors.secondaryFixed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: ClinicalColors.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 11,
                  color: ClinicalColors.onSurfaceVariant,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Free cancellation & instant refund ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
                  ),
                  TextSpan(
                    text:
                        'up to 2 hours prior to scheduled consultation. 100% money-back guarantee under clinical care protection.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPayBar() {
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
                  'Total Payable',
                  style: TextStyle(
                    fontSize: 11,
                    color: ClinicalColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  '₹${_totalPayable.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
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
                  onPressed: _proceedToPay,
                  icon: const Icon(Icons.lock, size: 16),
                  label: Text(
                    _selectedMethod == PaymentOptionType.clinic
                        ? 'Confirm Booking'
                        : 'Proceed to Pay ₹${_totalPayable.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
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
