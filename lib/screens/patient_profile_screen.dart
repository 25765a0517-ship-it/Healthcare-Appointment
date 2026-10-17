import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'personal_information_screen.dart';
import 'settings_screen.dart';
import 'my_appointments_screen.dart';
import 'notifications_screen.dart';
import 'doctor_dashboard_screen.dart';
import 'medical_records_screen.dart';
import 'admin_dashboard_screen.dart';
import 'login_screen.dart';

class PatientProfileScreen extends StatelessWidget {
  final bool showBackButton;

  const PatientProfileScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalColors.surface,
      appBar: AppBar(
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
                onPressed: () => Navigator.of(context).pop(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ClinicalColors.secondaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: ClinicalColors.onSecondaryFixedVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),
        title: const Text(
          'Patient Profile',
          style: TextStyle(
            color: ClinicalColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search patient records and history...')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ClinicalColors.primary,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Hero Section
            _buildProfileHeroCard(context),
            const SizedBox(height: 16),

            // Care Card Banner
            _buildCareCardBanner(context),
            const SizedBox(height: 20),

            // Section: Account & Clinical Records
            _buildSectionHeader('Account & Clinical Records'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.person,
                title: 'Personal Information',
                subtitle: 'Full name, contact, emergency contacts',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalInformationScreen(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.favorite_border,
                title: 'Medical Information',
                subtitle: 'Allergies, chronic conditions, blood group',
                onTap: () => _showMedicalInfoSheet(context),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.calendar_month,
                title: 'My Appointments',
                subtitle: 'Upcoming visits, past consultation history',
                badgeText: '2 Active',
                badgeColor: ClinicalColors.secondaryFixed,
                badgeTextColor: ClinicalColors.onSecondaryFixedVariant,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAppointmentsScreen(showBackButton: true),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.folder_special,
                title: 'Medical Records',
                subtitle: 'Lab test reports, prescriptions, clinical notes',
                badgeText: 'New',
                badgeColor: ClinicalColors.tertiaryFixed,
                badgeTextColor: ClinicalColors.onTertiaryFixed,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MedicalRecordsScreen(),
                    ),
                  );
                },
              ),
            ]),
            const SizedBox(height: 20),

            // Section: Preferences & Finance
            _buildSectionHeader('Preferences & Finance'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.credit_card,
                title: 'Payments',
                subtitle: 'Saved cards, UPI handles, billing invoices',
                onTap: () => _showPaymentsSheet(context),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Reminders, doctor alerts, updates',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(showBackButton: true),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.settings,
                title: 'App Settings',
                subtitle: 'Appearance, language, biometrics & security',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ]),
            const SizedBox(height: 20),

            // Section: Clinical & System Roles
            _buildSectionHeader('Support & System'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.medical_services,
                title: 'Switch to Doctor Portal',
                subtitle: 'Access clinical queue, charts, schedule & on-duty controls',
                badgeText: 'Provider',
                badgeColor: ClinicalColors.primaryFixed,
                badgeTextColor: ClinicalColors.onPrimaryFixed,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorDashboardScreen(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.admin_panel_settings,
                title: 'Hospital Admin Console',
                subtitle: 'Executive KPIs, staff credentialing & hospital telemetry',
                badgeText: 'Admin',
                badgeColor: ClinicalColors.secondaryFixed,
                badgeTextColor: ClinicalColors.onSecondaryFixedVariant,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminDashboardScreen(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.verified_user,
                title: 'Privacy & Security',
                subtitle: 'Data sharing, HIPAA consent, 2FA',
                onTap: () => _showPrivacySheet(context),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.contact_support,
                title: 'Help & Support',
                subtitle: '24/7 Care assistant, FAQs, clinic helpline',
                onTap: () => _showHelpSupportSheet(context),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About CareFlow',
                subtitle: 'Version 3.4.1 (Build 412) • Terms & Policies',
                onTap: () => _showAboutDialog(context),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Log Out',
                subtitle: 'Securely sign out of this device',
                iconColor: ClinicalColors.error,
                titleColor: ClinicalColors.error,
                onTap: () => _showLogoutDialog(context),
              ),
            ]),
            const SizedBox(height: 28),

            // HIPAA Assurance Seal Footer
            _buildHipaaFooter(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeroCard(BuildContext context) {
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
        children: [
          // Top Row: Avatar & Identity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with verified badge
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClinicalColors.surfaceContainerHigh,
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Alex Kumar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PersonalInformationScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ClinicalColors.secondaryFixed,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, size: 13, color: ClinicalColors.onSecondaryFixedVariant),
                                SizedBox(width: 4),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ClinicalColors.onSecondaryFixedVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Medical ID Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '30 Yrs • O+ Positive • #PT-9420',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Contact info
                    const Row(
                      children: [
                        Icon(Icons.mail_outline, size: 14, color: ClinicalColors.primary),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'alex@example.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: ClinicalColors.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Row(
                      children: [
                        Icon(Icons.call, size: 14, color: ClinicalColors.primary),
                        SizedBox(width: 6),
                        Text(
                          '+1 (555) 234-5678',
                          style: TextStyle(
                            fontSize: 12,
                            color: ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Quick Metrics Strip
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    count: '2',
                    label: 'Upcoming',
                    color: ClinicalColors.primary,
                    hasDot: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAppointmentsScreen(showBackButton: true),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    count: '14',
                    label: 'Completed',
                    color: ClinicalColors.onSurface,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAppointmentsScreen(showBackButton: true),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricItem(
                    count: '3',
                    label: 'Prescriptions',
                    color: ClinicalColors.tertiary,
                    onTap: () => _showPrescriptionsSheet(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String count,
    required String label,
    required Color color,
    bool hasDot = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (hasDot) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: ClinicalColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: ClinicalColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareCardBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ClinicalColors.primaryFixed,
            ClinicalColors.secondaryFixed,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: ClinicalColors.surfaceContainerLowest,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.health_and_safety,
              color: ClinicalColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comprehensive Health Plan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onPrimaryFixed,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Next preventative scan in 18 days',
                  style: TextStyle(
                    fontSize: 11,
                    color: ClinicalColors.onPrimaryFixedVariant,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showDigitalInsuranceCard(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 34),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: const Text('View Card', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: ClinicalColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: (iconColor == ClinicalColors.error)
                    ? ClinicalColors.errorContainer
                    : ClinicalColors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? ClinicalColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: titleColor ?? ClinicalColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor ?? ClinicalColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeTextColor ?? ClinicalColors.onSecondaryFixedVariant,
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
                      fontSize: 11,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: (iconColor == ClinicalColors.error)
                  ? ClinicalColors.error
                  : ClinicalColors.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: ClinicalColors.surfaceContainerHigh.withValues(alpha: 0.5),
      margin: const EdgeInsets.symmetric(horizontal: 14),
    );
  }

  Widget _buildHipaaFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock, size: 15, color: ClinicalColors.tertiary),
            SizedBox(width: 6),
            Text(
              '256-Bit Encrypted & HIPAA Compliant',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ClinicalColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'CareFlow Health Systems © 2024',
          style: TextStyle(
            fontSize: 11,
            color: ClinicalColors.outline,
          ),
        ),
      ],
    );
  }

  // Interactive Bottom Sheets & Dialogs
  void _showDigitalInsuranceCard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ClinicalColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Digital Health Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ClinicalColors.primary, ClinicalColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: ClinicalColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CareFlow Global Health',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('PLATINUM', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('MEMBER NAME', style: TextStyle(color: Colors.white70, fontSize: 10)),
                  const Text('Alex Kumar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('POLICY NUMBER', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text('CF-908234-88A', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('CO-PAY', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text('\$15 / Visit', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Health insurance pass saved to Apple Wallet')),
                );
              },
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Add to Apple Wallet / Download PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicalInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ClinicalColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Medical Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Known Allergies', 'Penicillin, Tree Nuts'),
            _buildDetailRow('Chronic Conditions', 'Mild Hypertension (Managed)'),
            _buildDetailRow('Blood Group', 'O+ Positive'),
            _buildDetailRow('Height & Weight', '178 cm · 74 kg (BMI: 23.4 Normal)'),
            _buildDetailRow('Vaccinations', 'COVID-19 Booster (2024), Influenza (2024)'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrescriptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ClinicalColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Active Prescriptions (3)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            _buildRxItem('Lisinopril 10mg', '1 tablet daily after breakfast', 'Dr. Sarah Johnson • 2 refills left'),
            _buildRxItem('Atorvastatin 20mg', '1 tablet at bedtime', 'Dr. Michael Chen • 1 refill left'),
            _buildRxItem('Vitamin D3 2000IU', '1 capsule daily with food', 'Dr. Marcus Vance • 3 refills left'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Prescription refill request sent to St. Jude Pharmacy')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Request Refills'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRxItem(String medicine, String dosage, String doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: ClinicalColors.tertiaryFixed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medication, color: ClinicalColors.tertiary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(dosage, style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(doctor, style: const TextStyle(fontSize: 11, color: ClinicalColors.outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _showPaymentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ClinicalColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saved Payment Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Primary Card', 'Visa ending in •••• 4242 (Exp 08/27)'),
            _buildDetailRow('UPI ID', 'alexkumar@okhdfcbank'),
            _buildDetailRow('Billing Address', '742 Evergreen Terrace, San Francisco, CA'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add payment method sheet opened')),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Payment Method'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Privacy & HIPAA Compliance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Your health data is protected under the Health Insurance Portability and Accountability Act (HIPAA). All medical communications and clinical charts are end-to-end encrypted.',
              style: TextStyle(fontSize: 13, color: ClinicalColors.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Two-Factor Authentication', 'Enabled (SMS + Authenticator)'),
            _buildDetailRow('Clinical Data Sharing', 'Only with Treating Physicians'),
            _buildDetailRow('Audit Logs', 'Last access: Today at 09:15 AM'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('CareFlow 24/7 Helpline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDetailRow('Emergency Care Helpline', '+1 (800) 273-8255 (Toll Free)'),
            _buildDetailRow('Clinic Concierge Desk', '+1 (555) 432-8765'),
            _buildDetailRow('Email Support', 'support@careflow.health'),
            _buildDetailRow('Average Response Time', '< 2 minutes'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling clinic concierge desk...')),
                );
              },
              icon: const Icon(Icons.phone),
              label: const Text('Call Helpline Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.local_hospital, color: ClinicalColors.primary),
            SizedBox(width: 8),
            Text('CareFlow Health', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 3.4.1 (Build 412)'),
            SizedBox(height: 6),
            Text('Engineered with high clinical precision for patient-provider workflows, HIPAA-compliant telehealth, and automated smart scheduling.'),
            SizedBox(height: 10),
            Text('© 2024 CareFlow Health Systems Inc. All rights reserved.', style: TextStyle(fontSize: 11, color: ClinicalColors.outline)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: ClinicalColors.surfaceContainerLowest,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ClinicalColors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: ClinicalColors.error,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Log Out?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to sign out of your CareFlow patient profile? You will need to verify your credentials to log back in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: ClinicalColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: ClinicalColors.outlineVariant),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: ClinicalColors.onSurfaceVariant)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ClinicalColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: ClinicalColors.outline, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ClinicalColors.onSurface)),
        ],
      ),
    );
  }
}
