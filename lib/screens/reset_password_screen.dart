import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _reqLength = false;
  bool _reqCases = false;
  bool _reqNumber = false;
  bool _reqSymbol = false;
  int _strengthScore = 0;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_evaluatePassword);
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  void _evaluatePassword() {
    final val = _passwordController.text;
    final lengthValid = val.length >= 8;
    final casesValid = RegExp(r'[A-Z]').hasMatch(val) && RegExp(r'[a-z]').hasMatch(val);
    final numberValid = RegExp(r'[0-9]').hasMatch(val);
    final symbolValid = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(val);

    int score = 0;
    if (lengthValid) score++;
    if (casesValid) score++;
    if (numberValid) score++;
    if (symbolValid) score++;

    setState(() {
      _reqLength = lengthValid;
      _reqCases = casesValid;
      _reqNumber = numberValid;
      _reqSymbol = symbolValid;
      _strengthScore = score;
    });
  }

  String get _strengthLabel {
    if (_passwordController.text.isEmpty) return 'Start typing';
    switch (_strengthScore) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  Color get _strengthColor {
    if (_passwordController.text.isEmpty) return ClinicalColors.outline;
    switch (_strengthScore) {
      case 1:
        return ClinicalColors.error;
      case 2:
        return ClinicalColors.primary;
      case 3:
        return ClinicalColors.secondaryContainer;
      case 4:
        return ClinicalColors.tertiary;
      default:
        return ClinicalColors.error;
    }
  }

  void _handleResetPassword() {
    if (_strengthScore < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please satisfy the security requirements for a stronger password'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: ClinicalColors.surfaceContainerLowest,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Celebration Badge
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: ClinicalColors.tertiaryContainer.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Password Reset Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your password has been securely updated. You can now log in with your new credentials.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ClinicalColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                // Session Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: ClinicalColors.tertiary),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Session refreshed · Ready to login',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ClinicalColors.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Back to Login'),
                      SizedBox(width: 8),
                      Icon(Icons.login, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pwd = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final isMatching = confirm.isNotEmpty && pwd == confirm;
    final isMismatch = confirm.isNotEmpty && pwd != confirm;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ClinicalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/logo/logo.webp',
                      height: 18,
                      width: 18,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.local_hospital,
                        color: ClinicalColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'SECURE PORTAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: ClinicalColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: ClinicalColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: ClinicalColors.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
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
                    // Screen Narrative
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ClinicalColors.secondaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock_reset,
                        size: 28,
                        color: ClinicalColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Create a new strong password for your healthcare account.',
                      style: TextStyle(
                        fontSize: 14,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // New Password Label & Strength Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                        Text(
                          _strengthLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _strengthColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 4 Segmented Strength Bars
                    Row(
                      children: List.generate(4, (index) {
                        Color barColor = ClinicalColors.surfaceContainerHighest;
                        if (index < _strengthScore) {
                          if (_strengthScore == 1) {
                            barColor = ClinicalColors.error;
                          } else if (_strengthScore == 2) {
                            barColor = ClinicalColors.primary;
                          } else if (_strengthScore == 3) {
                            barColor = ClinicalColors.secondaryContainer;
                          } else if (_strengthScore == 4) {
                            barColor = ClinicalColors.tertiary;
                          }
                        }
                        return Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 5,
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ClinicalColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Re-enter your password',
                        prefixIcon: const Icon(Icons.lock_clock_outlined, size: 20),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isMatching)
                              const Icon(Icons.check_circle, color: ClinicalColors.tertiary, size: 20)
                            else if (isMismatch)
                              const Icon(Icons.cancel, color: ClinicalColors.error, size: 20),
                            IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        confirm.isEmpty
                            ? 'Must match your new password'
                            : isMatching
                                ? 'Passwords match'
                                : 'Passwords do not match',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: confirm.isEmpty
                              ? ClinicalColors.outline
                              : isMatching
                                  ? ClinicalColors.tertiary
                                  : ClinicalColors.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Requirements Checklist Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.verified_user_outlined, size: 16, color: ClinicalColors.primary),
                              SizedBox(width: 6),
                              Text(
                                'PASSWORD REQUIREMENTS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: ClinicalColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildRequirementItem('At least 8 characters', _reqLength),
                          const SizedBox(height: 8),
                          _buildRequirementItem('Contains uppercase and lowercase letters', _reqCases),
                          const SizedBox(height: 8),
                          _buildRequirementItem('Contains at least one number', _reqNumber),
                          const SizedBox(height: 8),
                          _buildRequirementItem('Contains a special symbol (!@#\$)', _reqSymbol),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // CTA Button: Reset Password
                    ElevatedButton(
                      onPressed: _handleResetPassword,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Reset Password'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your security is protected by HIPAA standard encryption.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
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

  Widget _buildRequirementItem(String text, bool isValid) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: 13,
        fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
        color: isValid ? ClinicalColors.tertiary : ClinicalColors.onSurfaceVariant,
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? ClinicalColors.tertiary : ClinicalColors.outlineVariant,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
