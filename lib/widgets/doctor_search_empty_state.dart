import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DoctorSearchEmptyState extends StatefulWidget {
  final VoidCallback onResetFilters;
  final VoidCallback onBrowseSpecialties;

  const DoctorSearchEmptyState({
    super.key,
    required this.onResetFilters,
    required this.onBrowseSpecialties,
  });

  @override
  State<DoctorSearchEmptyState> createState() => _DoctorSearchEmptyStateState();
}

class _DoctorSearchEmptyStateState extends State<DoctorSearchEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: ClinicalColors.primary.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Animated Radar Sonar Pulse
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClinicalColors.secondaryFixed.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ClinicalColors.secondaryFixed.withValues(alpha: 0.4),
                  ),
                ),
                Container(
                  width: 65,
                  height: 65,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ClinicalColors.surfaceContainerHigh,
                  ),
                  child: const Icon(
                    Icons.person_search,
                    color: ClinicalColors.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Message
          const Text(
            'No matching doctors found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ClinicalColors.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We couldn't find any healthcare providers matching your exact search filters. Try widening your criteria.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ClinicalColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Quick Action Buttons
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: widget.onResetFilters,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset All Filters'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(160, 46),
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.onBrowseSpecialties,
                icon: const Icon(Icons.category_outlined, size: 18),
                label: const Text('Browse Specialties'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(160, 46),
                  side: const BorderSide(color: ClinicalColors.primary),
                  foregroundColor: ClinicalColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Care Coordination Desk Callout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: ClinicalColors.tertiary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need urgent triage?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.onSurface,
                        ),
                      ),
                      Text(
                        'Our on-call medical desk is online 24/7',
                        style: TextStyle(
                          fontSize: 11,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Connecting to Care Coordinator desk...')),
                    );
                  },
                  child: const Text('Connect'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
