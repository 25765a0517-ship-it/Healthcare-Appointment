import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HipaaBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const HipaaBadge({
    super.key,
    this.label = 'HIPAA Compliant & End-to-End Encrypted',
    this.icon = Icons.verified_user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: ClinicalColors.tertiary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ClinicalColors.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
