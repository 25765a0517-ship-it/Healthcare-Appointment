import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../data/mock_healthcare_data.dart';
import '../theme/app_theme.dart';
import 'appointment_confirmed_screen.dart';
import 'doctor_details_screen.dart';

class MyAppointmentsScreen extends StatefulWidget {
  final bool showBackButton;

  const MyAppointmentsScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchFilter = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCancelDialog(Appointment app) {
    String selectedReason = 'Schedule conflict';
    final reasons = [
      'Schedule conflict',
      'Feeling better / no longer needed',
      'Doctor unavailable at alternate time',
      'Booked by mistake',
      'Other personal reasons',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: ClinicalColors.surfaceContainerLowest,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cancel Appointment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Are you sure you want to cancel your appointment with ${app.doctor.name} on ${app.dateDisplay} (${app.timeSlot})?',
                      style: const TextStyle(
                        fontSize: 13,
                        color: ClinicalColors.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please select a reason for cancellation:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...reasons.map((r) {
                      final isSelected = selectedReason == r;
                      return InkWell(
                        onTap: () {
                          setModalState(() {
                            selectedReason = r;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? ClinicalColors.error
                                        : ClinicalColors.outline,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? ClinicalColors.error
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Center(
                                        child: CircleAvatar(
                                          radius: 3.5,
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  r,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isSelected
                                        ? ClinicalColors.onSurface
                                        : ClinicalColors.onSurfaceVariant,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: ClinicalColors.outlineVariant),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Keep Appointment'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              AppointmentRepository.cancelAppointment(app.id, selectedReason);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Appointment ${app.id} was cancelled.'),
                                  backgroundColor: ClinicalColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ClinicalColors.error,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Confirm Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRescheduleDialog(Appointment app) {
    int selectedDayIdx = 2; // Wed 14
    String selectedSlot = '11:00 AM';

    final days = [
      {'day': 'Wed', 'date': 'Oct 14'},
      {'day': 'Thu', 'date': 'Oct 15'},
      {'day': 'Fri', 'date': 'Oct 16'},
      {'day': 'Sat', 'date': 'Oct 17'},
    ];

    final slots = ['09:30 AM', '11:00 AM', '02:30 PM', '04:00 PM'];

    showModalBottomSheet(
      context: context,
      backgroundColor: ClinicalColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reschedule Appointment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a new date and time for ${app.doctor.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select New Date',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(days.length, (idx) {
                        final isSel = selectedDayIdx == idx;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedDayIdx = idx;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? ClinicalColors.primary
                                  : ClinicalColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  days[idx]['day']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSel ? Colors.white70 : ClinicalColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  days[idx]['date']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSel ? Colors.white : ClinicalColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Available Time Slot',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: slots.map((s) {
                        final isSel = selectedSlot == s;
                        return ChoiceChip(
                          label: Text(s),
                          selected: isSel,
                          selectedColor: ClinicalColors.primaryFixed,
                          backgroundColor: ClinicalColors.surfaceContainerLow,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            color: isSel ? ClinicalColors.primary : ClinicalColors.onSurface,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() {
                                selectedSlot = s;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final newDate = days[selectedDayIdx]['date']!;
                          AppointmentRepository.rescheduleAppointment(
                            app.id,
                            newDate,
                            selectedSlot,
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Rescheduled to $newDate at $selectedSlot!'),
                              backgroundColor: ClinicalColors.tertiary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClinicalColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Confirm Reschedule',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ClinicalColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Appointments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('All Consultations'),
                leading: const Icon(Icons.all_inclusive, color: ClinicalColors.primary),
                onTap: () {
                  setState(() => _searchFilter = '');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('In-Person Only'),
                leading: const Icon(Icons.meeting_room, color: ClinicalColors.primary),
                onTap: () {
                  setState(() => _searchFilter = 'In-Person');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Video / Telehealth Only'),
                leading: const Icon(Icons.videocam, color: ClinicalColors.tertiary),
                onTap: () {
                  setState(() => _searchFilter = 'Video');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Appointment>>(
      valueListenable: AppointmentRepository.appointmentsNotifier,
      builder: (context, allAppointments, _) {
        final upcoming = allAppointments
            .where((a) =>
                a.status == AppointmentStatus.upcoming &&
                (_searchFilter.isEmpty || a.locationOrRoom.contains(_searchFilter)))
            .toList();

        final completed = allAppointments
            .where((a) =>
                a.status == AppointmentStatus.completed &&
                (_searchFilter.isEmpty || a.locationOrRoom.contains(_searchFilter)))
            .toList();

        final cancelled = allAppointments
            .where((a) =>
                a.status == AppointmentStatus.cancelled &&
                (_searchFilter.isEmpty || a.locationOrRoom.contains(_searchFilter)))
            .toList();

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
                    color: ClinicalColors.secondaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    color: ClinicalColors.onSecondaryFixedVariant,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'My Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune, color: ClinicalColors.primary),
                tooltip: 'Filter',
                onPressed: _showFilterModal,
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: ClinicalColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ],
          ),
          body: Column(
            children: [
              // Header Subtitle
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Manage your consultations and history',
                      style: TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                    if (_searchFilter.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: ClinicalColors.primaryFixed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _searchFilter,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: ClinicalColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Segmented Tab Bar with Badges
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  labelColor: ClinicalColors.primary,
                  unselectedLabelColor: ClinicalColors.onSurfaceVariant,
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Upcoming'),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: ClinicalColors.primaryFixed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${upcoming.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.onPrimaryFixed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Completed'),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: ClinicalColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${completed.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Cancelled'),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: ClinicalColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${cancelled.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUpcomingList(upcoming),
                    _buildCompletedList(completed),
                    _buildCancelledList(cancelled),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpcomingList(List<Appointment> list) {
    if (list.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today,
        title: 'No Upcoming Appointments',
        subtitle: 'You have no active doctor consultations scheduled at this moment.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final app = list[index];
        return _buildUpcomingAppointmentCard(app);
      },
    );
  }

  Widget _buildUpcomingAppointmentCard(Appointment app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Doctor Snapshot & Confirmed Pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(app.doctor.imageUrl),
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
                                  app.doctor.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ClinicalColors.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                size: 16,
                                color: ClinicalColors.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${app.doctor.specialty} · ${app.doctor.hospital}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ClinicalColors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ClinicalColors.secondaryFixed.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 12,
                            color: ClinicalColors.onSecondaryFixedVariant,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Confirmed',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSecondaryFixedVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Date, Time Slot & Countdown Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: ClinicalColors.primaryFixed,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.calendar_month,
                                  color: ClinicalColors.primary,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${app.dateDisplay} · ${app.timeSlot}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: ClinicalColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              app.countdownLabel,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: ClinicalColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            app.consultationType == ConsultationType.inPerson
                                ? Icons.location_on
                                : Icons.videocam,
                            size: 15,
                            color: ClinicalColors.tertiary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              app.locationOrRoom,
                              style: const TextStyle(
                                fontSize: 11,
                                color: ClinicalColors.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Actions: View Pass + Reschedule
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentConfirmedScreen(
                                appointment: app,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.receipt_long, size: 16),
                        label: const Text(
                          'View Pass',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClinicalColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showRescheduleDialog(app),
                        icon: const Icon(Icons.edit_calendar, size: 16),
                        label: const Text(
                          'Reschedule',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClinicalColors.surfaceContainerHigh,
                          foregroundColor: ClinicalColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Cancel Button
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showCancelDialog(app),
                    icon: const Icon(Icons.cancel, size: 15, color: ClinicalColors.error),
                    label: const Text(
                      'Cancel Appointment',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedList(List<Appointment> list) {
    if (list.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No Completed Visits',
        subtitle: 'Past visits and treatment history will appear here once concluded.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final app = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ClinicalColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(app.doctor.imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.doctor.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${app.doctor.specialty} · ${app.dateDisplay}',
                          style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: ClinicalColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onTertiaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDetailsScreen(doctor: app.doctor),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay, size: 14),
                      label: const Text('Book Follow-up', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ClinicalColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Prescription PDF downloaded to device.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, size: 14),
                      label: const Text('Prescription', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ClinicalColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCancelledList(List<Appointment> list) {
    if (list.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_busy,
        title: 'No Cancelled Consultations',
        subtitle: 'You do not have any cancelled consultations in your record.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final app = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ClinicalColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ClinicalColors.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(app.doctor.imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.doctor.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${app.doctor.specialty} · ${app.dateDisplay}',
                          style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: ClinicalColors.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Cancelled',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
              if (app.cancellationReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: ClinicalColors.outline),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          app.cancellationReason!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailsScreen(doctor: app.doctor),
                      ),
                    );
                  },
                  icon: const Icon(Icons.event_repeat, size: 14),
                  label: const Text('Book Another Slot', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ClinicalColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
              child: Icon(icon, size: 30, color: ClinicalColors.outline),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: ClinicalColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
