import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ClinicalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  const ClinicalAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = showBack && (Navigator.canPop(context) || onBack != null);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
      elevation: 0.5,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      titleSpacing: 16,
      title: Row(
        children: [
          if (canGoBack)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                tooltip: 'Back',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/logo/logo.webp',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ClinicalColors.primaryFixed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: ClinicalColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: ClinicalColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
              overflow: TextOverflow.ellipsis,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
