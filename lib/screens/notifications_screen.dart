import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_healthcare_data.dart';
import 'appointment_confirmed_screen.dart';

class NotificationItem {
  final String id;
  final String category; // 'appointment', 'messages', 'payment', 'system'
  final String title;
  final String message;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  bool isUnread;
  final String? actionLabel;
  final VoidCallback? onAction;

  NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.isUnread = true,
    this.actionLabel,
    this.onAction,
  });
}

class NotificationsScreen extends StatefulWidget {
  final bool showBackButton;

  const NotificationsScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'all';

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    _notifications = [
      NotificationItem(
        id: '1',
        category: 'appointment',
        title: 'Appointment Reminder',
        message: 'Your cardiology consultation with Dr. Sarah Johnson starts in 45 minutes.',
        timeAgo: '10m ago',
        icon: Icons.alarm,
        iconColor: ClinicalColors.primary,
        iconBg: ClinicalColors.primaryFixed,
        isUnread: true,
        actionLabel: 'View Pass',
        onAction: () {
          final app = AppointmentRepository.appointments.first;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentConfirmedScreen(appointment: app),
            ),
          );
        },
      ),
      NotificationItem(
        id: '2',
        category: 'messages',
        title: 'Prescription Refill Approved',
        message: 'Cardiology prescription ready for pickup at St. Jude Clinic pharmacy.',
        timeAgo: '1h ago',
        icon: Icons.medication,
        iconColor: ClinicalColors.tertiary,
        iconBg: ClinicalColors.tertiaryFixed,
        isUnread: true,
        actionLabel: 'View Rx',
        onAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription refill #RX-8941 opened.')),
          );
        },
      ),
      NotificationItem(
        id: '3',
        category: 'payment',
        title: 'Payment Receipt Ready',
        message: 'Invoice #CF-849204 for ₹500.00 has been verified and settled via UPI.',
        timeAgo: '2h ago',
        icon: Icons.receipt_long,
        iconColor: ClinicalColors.secondary,
        iconBg: ClinicalColors.secondaryFixed,
        isUnread: true,
        actionLabel: 'Download',
        onAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receipt downloaded successfully.')),
          );
        },
      ),
      NotificationItem(
        id: '4',
        category: 'appointment',
        title: 'Diagnostic Lab Results Ready',
        message: 'Lipid panel and Resting ECG report uploaded by St. Jude Pathology Dept.',
        timeAgo: 'Yesterday',
        icon: Icons.biotech,
        iconColor: ClinicalColors.primary,
        iconBg: ClinicalColors.surfaceContainerLow,
        isUnread: false,
        actionLabel: 'View Lab',
        onAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Viewing Lab Test Report PDF...')),
          );
        },
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<NotificationItem> get _filteredList {
    if (_selectedCategory == 'all') return _notifications;
    return _notifications.where((n) => n.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;

    return Scaffold(
      backgroundColor: ClinicalColors.surface,
      appBar: AppBar(
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        titleSpacing: widget.showBackButton ? 0 : 16,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: ClinicalColors.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_active, color: ClinicalColors.primary, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: _markAllRead,
                icon: const Icon(Icons.done_all, size: 16, color: ClinicalColors.primary),
                label: const Text(
                  'Mark all read',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalColors.primary),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle and badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stay updated on consultations & health alerts',
                  style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
                ),
                if (_unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: ClinicalColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$_unreadCount new',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          // Categories Filter Strip
          _buildCategoryFilters(),
          const SizedBox(height: 8),

          // Notifications List
          Expanded(
            child: list.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 30),
                    itemCount: list.length,
                    itemBuilder: (context, idx) {
                      final item = list[idx];
                      return _buildNotificationCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      {'id': 'all', 'label': 'All'},
      {'id': 'appointment', 'label': 'Appointments'},
      {'id': 'messages', 'label': 'Messages'},
      {'id': 'payment', 'label': 'Payments'},
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final cat = categories[idx];
          final isSelected = _selectedCategory == cat['id'];

          return ChoiceChip(
            label: Text(cat['label']!),
            selected: isSelected,
            selectedColor: ClinicalColors.primary,
            backgroundColor: ClinicalColors.surfaceContainerLow,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : ClinicalColors.onSurface,
            ),
            onSelected: (val) {
              if (val) {
                setState(() => _selectedCategory = cat['id']!);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isUnread
            ? ClinicalColors.surfaceContainerLow
            : ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: item.isUnread
            ? Border.all(color: ClinicalColors.primary.withValues(alpha: 0.15))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (item.isUnread) ...[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: ClinicalColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: item.isUnread ? FontWeight.bold : FontWeight.w600,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      item.timeAgo,
                      style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant, height: 1.3),
                ),
                if (item.actionLabel != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => item.isUnread = false);
                        item.onAction?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ClinicalColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: const Size(60, 28),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(item.actionLabel!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: ClinicalColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none, size: 30, color: ClinicalColors.outline),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'You are all caught up with your clinical updates and visits.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
