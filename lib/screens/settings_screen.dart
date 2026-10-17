import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = true;
  final String _selectedLanguage = 'English (US)';

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: ClinicalColors.surfaceContainerLowest,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logout Icon with shield badge
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: ClinicalColors.errorContainer.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.logout, size: 32, color: ClinicalColors.error),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.health_and_safety, size: 14, color: ClinicalColors.error),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Log out of CareFlow?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to log out? You will need to sign in again to view your upcoming appointments and medical records.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: ClinicalColors.onSurfaceVariant, height: 1.4),
              ),
              const SizedBox(height: 14),

              // Encryption guarantee note
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock, size: 16, color: ClinicalColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your local session and offline consultation passes will remain securely encrypted.',
                        style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Log Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
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
        title: const Text(
          'App Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          // User Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBs1x2VtnTYL6TksFOr2PLth1AP2pdjParIQ10FtsrOzobI-TpGyRKynz-jzKnHAv-2x5tJkxlH7AiFFV4XRh6hGf_4xQNEeIwMTgj_6E1ap88gaoCJ5HNuRYCNVPSSA6cKTGpKfNFhK97tW0I1tMGVoBqxqj0x1dqCgEz7oQHbRFiBb-yJchP0KB21j7sJpP-PaCI-0kPnbZNN5bRikmKZzuQFtZcKZIR8vpRHO_bQ',
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Alex Morgan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.verified, size: 14, color: ClinicalColors.primary),
                        ],
                      ),
                      Text('Patient ID: #CF-892401',
                          style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ClinicalColors.tertiaryFixed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Active',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onTertiaryFixed)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Preferences & Display
          const Text('PREFERENCES & DISPLAY',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Material(
            color: ClinicalColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined, color: ClinicalColors.primary),
                  title: const Text('Push Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Reminders, test results & prescriptions', style: TextStyle(fontSize: 11)),
                  value: _notificationsEnabled,
                  activeThumbColor: ClinicalColors.primary,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: ClinicalColors.onSurfaceVariant),
                  title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Use system default theme', style: TextStyle(fontSize: 11)),
                  value: _darkModeEnabled,
                  activeThumbColor: ClinicalColors.primary,
                  onChanged: (val) => setState(() => _darkModeEnabled = val),
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint, color: ClinicalColors.tertiary),
                  title: const Text('Biometric App Lock', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('FaceID or fingerprint before open', style: TextStyle(fontSize: 11)),
                  value: _biometricEnabled,
                  activeThumbColor: ClinicalColors.primary,
                  onChanged: (val) => setState(() => _biometricEnabled = val),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.language, color: ClinicalColors.secondary),
                  title: const Text('Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: Text(_selectedLanguage, style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language selector opened')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Security & Compliance
          const Text('SECURITY & COMPLIANCE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Material(
            color: ClinicalColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.security, color: ClinicalColors.primary),
                  title: const Text('HIPAA & Data Privacy Notice', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: ClinicalColors.onSurfaceVariant),
                  title: const Text('Terms of Telehealth Service', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Account Actions
          const Text('ACCOUNT ACTIONS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: ClinicalColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Material(
            color: ClinicalColors.errorContainer.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ClinicalColors.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: ClinicalColors.error, size: 20),
              ),
              title: const Text(
                'Log Out of Account',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ClinicalColors.error),
              ),
              subtitle: const Text('Terminate active session on this device', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: ClinicalColors.error),
              onTap: _showLogoutDialog,
            ),
          ),
          const SizedBox(height: 24),

          // App Version & HIPAA Footer
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.health_and_safety, size: 14, color: ClinicalColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'CareFlow Clinical v2.14.0',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'HIPAA Compliant & End-to-End Encrypted',
                  style: TextStyle(fontSize: 10, color: ClinicalColors.outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
