import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/clinical_app_bar.dart';
import 'reset_password_screen.dart';
import '../widgets/main_scaffold.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String destination;
  final bool isFromForgotPassword;
  final bool isFromRegistration;

  const OtpVerificationScreen({
    super.key,
    this.destination = '•••• 8291',
    this.isFromForgotPassword = false,
    this.isFromRegistration = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<String> _digits = ['', '', '', '', '', ''];
  int _secondsRemaining = 45;
  Timer? _countdownTimer;
  bool _isAutoFilled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _secondsRemaining = 45;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onKeyPress(String val) {
    if (val == 'backspace') {
      for (int i = _digits.length - 1; i >= 0; i--) {
        if (_digits[i].isNotEmpty) {
          setState(() {
            _digits[i] = '';
          });
          break;
        }
      }
    } else if (val == 'biometric') {
      _autoFillOtp();
    } else {
      final emptyIndex = _digits.indexWhere((element) => element.isEmpty);
      if (emptyIndex != -1) {
        setState(() {
          _digits[emptyIndex] = val;
        });
        if (emptyIndex == 5) {
          // Auto verify when 6th digit entered
          _verifyOtp();
        }
      }
    }
  }

  void _autoFillOtp() {
    setState(() {
      final demoCode = ['4', '8', '2', '9', '1', '0'];
      for (int i = 0; i < 6; i++) {
        _digits[i] = demoCode[i];
      }
      _isAutoFilled = true;
    });
  }

  void _verifyOtp() {
    final code = _digits.join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits of the OTP code'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.isFromForgotPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
        ),
      );
    } else {
      // Completed registration or general 2FA login
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: ClinicalColors.surfaceContainerLowest,
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: ClinicalColors.tertiary, size: 28),
              SizedBox(width: 10),
              Text('Account Verified!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Your healthcare identity has been successfully authenticated. Welcome to your care dashboard.',
            style: TextStyle(color: ClinicalColors.onSurfaceVariant),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainScaffold()),
                  (route) => false,
                );
              },
              child: const Text('Go to Home Dashboard'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstEmptyIdx = _digits.indexWhere((d) => d.isEmpty);
    final activeIdx = firstEmptyIdx == -1 ? 5 : firstEmptyIdx;

    String destinationDisplay = widget.destination;
    if (destinationDisplay.length > 4 && !destinationDisplay.contains('••••')) {
      final last4 = destinationDisplay.substring(destinationDisplay.length - 4);
      destinationDisplay = '•••• $last4';
    }

    return Scaffold(
      appBar: const ClinicalAppBar(
        title: 'Two Factor Verification',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Brand & Glow
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ClinicalColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/logo/logo.webp',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.local_hospital,
                              color: ClinicalColors.primary,
                              size: 36,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -3,
                          right: -3,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: ClinicalColors.tertiaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: ClinicalColors.onTertiaryContainer,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Verify your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      text: "We've sent a 6-digit verification code to your phone number ending in ",
                      style: const TextStyle(
                        fontSize: 14,
                        color: ClinicalColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: destinationDisplay,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Encrypted Medical Access Pill
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_user, size: 15, color: ClinicalColors.primary),
                          SizedBox(width: 6),
                          Text(
                            'Encrypted Medical Access',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ClinicalColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Smart SMS Auto-fill suggestion chip
                  Center(
                    child: InkWell(
                      onTap: _isAutoFilled ? null : _autoFillOtp,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: ClinicalColors.secondaryFixed,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.sms_outlined, size: 18, color: ClinicalColors.primary),
                            const SizedBox(width: 8),
                            const Flexible(
                              child: Text.rich(
                                TextSpan(
                                  text: 'Auto-fill from SMS: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ClinicalColors.onSecondaryFixed,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '482910',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ClinicalColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward, size: 14, color: ClinicalColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6 OTP Digit Cells
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final val = _digits[index];
                      final isFocused = index == activeIdx && firstEmptyIdx != -1;

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 54,
                          decoration: BoxDecoration(
                            color: val.isNotEmpty || isFocused
                                ? ClinicalColors.surfaceContainerLowest
                                : ClinicalColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: isFocused
                                ? Border.all(color: ClinicalColors.primary, width: 2)
                                : Border.all(color: Colors.transparent),
                            boxShadow: [
                              BoxShadow(
                                color: isFocused
                                    ? ClinicalColors.primary.withValues(alpha: 0.12)
                                    : Colors.black.withValues(alpha: 0.03),
                                blurRadius: isFocused ? 6 : 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: val.isNotEmpty
                              ? Text(
                                  val,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: ClinicalColors.onSurface,
                                  ),
                                )
                              : isFocused
                                  ? Container(
                                      width: 2,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: ClinicalColors.primary,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    )
                                  : Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: ClinicalColors.outlineVariant,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),

                  // Never share code hint
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 14, color: ClinicalColors.onSurfaceVariant),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Never share this code with anyone, including hospital staff',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Primary Verify CTA
                  ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Verify Account'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Resend countdown
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive code? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: _secondsRemaining == 0
                            ? () {
                                _startCountdown();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('New OTP sent to your device.')),
                                );
                              }
                            : null,
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _secondsRemaining == 0
                                ? ClinicalColors.primary
                                : ClinicalColors.outline,
                          ),
                        ),
                      ),
                      if (_secondsRemaining > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            ' (00:${_secondsRemaining.toString().padLeft(2, '0')})',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.secondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Verify via Email pill
                  Center(
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP sent to your verified email.')),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: ClinicalColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.alternate_email, size: 14, color: ClinicalColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'Verify via Email instead',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ClinicalColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Custom Ergonomic Dialpad
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildDialRow(['1', '2', '3'], ['', 'ABC', 'DEF']),
                        const SizedBox(height: 8),
                        _buildDialRow(['4', '5', '6'], ['GHI', 'JKL', 'MNO']),
                        const SizedBox(height: 8),
                        _buildDialRow(['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ']),
                        const SizedBox(height: 8),
                        _buildDialBottomRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialRow(List<String> digits, List<String> subLabels) {
    return Row(
      children: List.generate(3, (idx) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: ClinicalColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              elevation: 0.5,
              child: InkWell(
                onTap: () => _onKeyPress(digits[idx]),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        digits[idx],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ClinicalColors.onSurface,
                        ),
                      ),
                      if (subLabels[idx].isNotEmpty)
                        Text(
                          subLabels[idx],
                          style: const TextStyle(
                            fontSize: 9,
                            color: ClinicalColors.outline,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDialBottomRow() {
    return Row(
      children: [
        // Biometric / Auto-fill button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _onKeyPress('biometric'),
                borderRadius: BorderRadius.circular(12),
                child: const SizedBox(
                  height: 48,
                  child: Icon(
                    Icons.fingerprint,
                    color: ClinicalColors.primary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
        // 0 Digit
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: ClinicalColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              elevation: 0.5,
              child: InkWell(
                onTap: () => _onKeyPress('0'),
                borderRadius: BorderRadius.circular(12),
                child: const SizedBox(
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ClinicalColors.onSurface,
                        ),
                      ),
                      Text(
                        '+',
                        style: TextStyle(
                          fontSize: 9,
                          color: ClinicalColors.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Backspace
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _onKeyPress('backspace'),
                borderRadius: BorderRadius.circular(12),
                child: const SizedBox(
                  height: 48,
                  child: Icon(
                    Icons.backspace_outlined,
                    color: ClinicalColors.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
