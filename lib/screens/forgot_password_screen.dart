import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/clinical_app_bar.dart';
import 'otp_verification_screen.dart';

enum RecoveryMethod { email, phone }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  RecoveryMethod _currentMethod = RecoveryMethod.email;
  bool _isLoading = false;
  bool _otpSent = false;

  void _switchMethod(RecoveryMethod method) {
    setState(() {
      _currentMethod = method;
      _controller.clear();
      _otpSent = false;
    });
  }

  void _handleSendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _otpSent = true;
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          final destination = _controller.text.trim();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                destination: destination.isNotEmpty
                    ? destination
                    : (_currentMethod == RecoveryMethod.email
                        ? 'sarah.jenkins@example.com'
                        : '+1 (555) 234-8291'),
                isFromForgotPassword: true,
              ),
            ),
          );
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = _currentMethod == RecoveryMethod.email;

    return Scaffold(
      appBar: const ClinicalAppBar(
        title: 'Forgot Password',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Icon & lock_reset badge
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ClinicalColors.surfaceContainer,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/logo/logo.webp',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.local_hospital,
                                color: ClinicalColors.primary,
                                size: 32,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ClinicalColors.secondaryContainer,
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 15,
                                color: ClinicalColors.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Forgot password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Enter your email or phone number and we'll send you a verification code.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Recovery Form Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Tab selector (Email vs Phone)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: ClinicalColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _switchMethod(RecoveryMethod.email),
                                    borderRadius: BorderRadius.circular(25),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isEmail
                                            ? ClinicalColors.surfaceContainerLowest
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: isEmail
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.05),
                                                  blurRadius: 4,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.mail_outline,
                                            size: 16,
                                            color: isEmail
                                                ? ClinicalColors.primary
                                                : ClinicalColors.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Email',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: isEmail
                                                ? ClinicalColors.primary
                                                : ClinicalColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _switchMethod(RecoveryMethod.phone),
                                    borderRadius: BorderRadius.circular(25),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: !isEmail
                                            ? ClinicalColors.surfaceContainerLowest
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: !isEmail
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.05),
                                                  blurRadius: 4,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.phone_iphone,
                                            size: 16,
                                            color: !isEmail
                                                ? ClinicalColors.primary
                                                : ClinicalColors.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Phone',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: !isEmail
                                                ? ClinicalColors.primary
                                                : ClinicalColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Dynamic Input Field
                          Text(
                            isEmail ? 'Email Address' : 'Mobile Phone Number',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ClinicalColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _controller,
                            keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: isEmail ? 'e.g. sarah.jenkins@example.com' : 'e.g. (555) 234-5678',
                              prefixIcon: Icon(
                                isEmail ? Icons.mail_outline : Icons.phone_outlined,
                                size: 20,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return isEmail ? 'Please enter your email' : 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.info,
                                size: 14,
                                color: ClinicalColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "We'll send a 6-digit OTP code to verify",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ClinicalColors.onSurfaceVariant.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Submit Action
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleSendOtp,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Send OTP'),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Feedback Banner if OTP sent
                    if (_otpSent)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: ClinicalColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ClinicalColors.tertiaryContainer,
                              ),
                              child: const Icon(
                                Icons.mark_email_read,
                                color: ClinicalColors.onTertiaryContainer,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Code Dispatched!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: ClinicalColors.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Please check your inbox. The OTP is valid for 10 minutes.',
                                    style: TextStyle(
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
                    const SizedBox(height: 16),

                    // Support Clinic Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ClinicalColors.secondaryFixed,
                            ),
                            child: const Icon(
                              Icons.verified_user,
                              color: ClinicalColors.onSecondaryFixed,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Need help recovering your account?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ClinicalColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Calling Clinic Support (1-800-555-0199)...')),
                                    );
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Contact Clinic Support',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: ClinicalColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.call, size: 12, color: ClinicalColors.primary),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Return to Login
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Remember password?',
                            style: TextStyle(
                              fontSize: 14,
                              color: ClinicalColors.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ClinicalColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
