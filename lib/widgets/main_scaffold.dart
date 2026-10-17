import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/home_dashboard_screen.dart';
import '../screens/medical_specialties_screen.dart';
import '../screens/my_appointments_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/patient_profile_screen.dart';

class MainScaffold extends StatefulWidget {
  final int initialTab;

  const MainScaffold({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeDashboardScreen(
        onNavigateTab: (tabIndex) => _onTabTapped(tabIndex),
      ),
      const MedicalSpecialtiesScreen(),
      const MyAppointmentsScreen(showBackButton: false),
      const NotificationsScreen(showBackButton: false),
      const PatientProfileScreen(showBackButton: false),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ClinicalColors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.search, 'Explore'),
                _buildNavItem(2, Icons.calendar_today, 'Appointments'),
                _buildNavItem(3, Icons.notifications_none, 'Alerts'),
                _buildNavItem(4, Icons.person_outline, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTab == index;
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected
                    ? ClinicalColors.secondaryContainer.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
