import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'select_date_time_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late bool _isFavorite;
  int _selectedDateIndex = 1; // Tue 13 by default
  ConsultationType _selectedConsultationType = ConsultationType.inPerson;
  String _selectedTimeSlot = '10:30 AM';

  final List<Map<String, dynamic>> _dateDays = [
    {'day': 'Mon', 'date': '12', 'fullDate': 'Oct 12, 2026', 'isAvailable': true},
    {'day': 'Tue', 'date': '13', 'fullDate': 'Oct 13, 2026', 'isAvailable': true},
    {'day': 'Wed', 'date': '14', 'fullDate': 'Oct 14, 2026', 'isAvailable': true},
    {'day': 'Thu', 'date': '15', 'fullDate': 'Oct 15, 2026', 'isAvailable': true},
    {'day': 'Fri', 'date': '16', 'fullDate': 'Oct 16, 2026', 'isAvailable': true},
    {'day': 'Sat', 'date': '17', 'fullDate': 'Oct 17, 2026', 'isAvailable': true},
    {'day': 'Sun', 'date': '18', 'fullDate': 'Oct 18, 2026', 'isAvailable': false},
  ];

  final List<Map<String, dynamic>> _timeSlots = [
    {'time': '09:00 AM', 'disabled': false},
    {'time': '09:30 AM', 'disabled': false},
    {'time': '10:00 AM', 'disabled': true},
    {'time': '10:30 AM', 'disabled': false},
    {'time': '11:00 AM', 'disabled': false},
    {'time': '11:30 AM', 'disabled': true},
    {'time': '02:00 PM', 'disabled': false},
    {'time': '02:30 PM', 'disabled': false},
    {'time': '03:00 PM', 'disabled': true},
  ];

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.doctor.isBookmarked;
  }

  double get _currentFee =>
      _selectedConsultationType == ConsultationType.inPerson ? 500.0 : 450.0;

  void _onBookPressed() {
    final selectedDay = _dateDays[_selectedDateIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDateTimeScreen(
          doctor: widget.doctor,
          initialDate: selectedDay['fullDate'] as String?,
          initialTimeSlot: _selectedTimeSlot,
          initialType: _selectedConsultationType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    return Scaffold(
      backgroundColor: ClinicalColors.surface,
      appBar: AppBar(
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: const Text(
          'Doctor Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ClinicalColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? ClinicalColors.error : ClinicalColors.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
                doctor.isBookmarked = _isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite ? 'Saved to favorites' : 'Removed from favorites',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Favorite',
          ),
          IconButton(
            icon: const Icon(Icons.share, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Doctor profile link copied: ${doctor.name}')),
              );
            },
            tooltip: 'Share',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ClinicalColors.primary,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Doctor Overview Card
                _buildDoctorOverviewCard(doctor),
                const SizedBox(height: 16),

                // 3-Column Stats Grid
                _buildMetricStatsGrid(),
                const SizedBox(height: 16),

                // Date & Time Slot Booking Section
                _buildBookingPickerSection(),
                const SizedBox(height: 16),

                // About Doctor
                _buildAboutDoctorCard(doctor),
                const SizedBox(height: 16),

                // Services Offered
                _buildServicesCard(doctor),
                const SizedBox(height: 16),

                // Experience & Education Timeline
                _buildExperienceCard(doctor),
                const SizedBox(height: 16),

                // Clinic Location & Map
                _buildClinicLocationCard(doctor),
                const SizedBox(height: 16),

                // Patient Reviews Section
                _buildReviewsSection(doctor),
              ],
            ),
          ),

          // Sticky Bottom Booking Dock
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBookingDock(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorOverviewCard(Doctor doctor) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portrait Container with Verified Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: ClinicalColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      doctor.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: ClinicalColors.surfaceContainerHigh,
                        child: const Icon(Icons.person, size: 40, color: ClinicalColors.primary),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Identity & Affiliation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: ClinicalColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Available Today',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ClinicalColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.credentials,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.local_hospital, size: 15, color: ClinicalColors.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.hospital,
                            style: const TextStyle(
                              fontSize: 12,
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
            ],
          ),
          const SizedBox(height: 12),

          // Rating and Status Pill Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${doctor.reviewsCount} reviews)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.videocam, size: 16, color: ClinicalColors.tertiary),
                    const SizedBox(width: 4),
                    const Text(
                      '& In-Person',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildMetricStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatTile(
            icon: Icons.workspace_premium,
            value: '${widget.doctor.experienceYears}+ Yrs',
            label: 'Experience',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatTile(
            icon: Icons.groups,
            value: widget.doctor.patientCount,
            label: 'Patients',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatTile(
            icon: Icons.payments,
            value: '₹500',
            label: 'Consultation',
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: ClinicalColors.primaryFixed,
            child: Icon(icon, size: 18, color: ClinicalColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ClinicalColors.onSurface,
            ),
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
    );
  }

  Widget _buildBookingPickerSection() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurface,
                    ),
                  ),
                  Text(
                    'October 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.calendar_month, size: 16, color: ClinicalColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Next Slot: Today',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ClinicalColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Date Picker Strip
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _dateDays.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = _dateDays[index];
                final isSelected = _selectedDateIndex == index;
                final isAvailable = item['isAvailable'] as bool;

                return InkWell(
                  onTap: isAvailable
                      ? () {
                          setState(() {
                            _selectedDateIndex = index;
                          });
                        }
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 54,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ClinicalColors.primary
                          : isAvailable
                              ? ClinicalColors.surfaceContainerLow
                              : ClinicalColors.surfaceContainerLow.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: ClinicalColors.primary.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (item['day'] as String).toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? ClinicalColors.primaryFixed
                                : ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['date'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : isAvailable
                                    ? ClinicalColors.onSurface
                                    : ClinicalColors.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Visit Type Segmented Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedConsultationType = ConsultationType.inPerson;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedConsultationType == ConsultationType.inPerson
                            ? ClinicalColors.surfaceContainerLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedConsultationType == ConsultationType.inPerson
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.domain,
                            size: 16,
                            color: _selectedConsultationType == ConsultationType.inPerson
                                ? ClinicalColors.primary
                                : ClinicalColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'In-Person (₹500)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedConsultationType == ConsultationType.inPerson
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _selectedConsultationType == ConsultationType.inPerson
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
                    onTap: () {
                      setState(() {
                        _selectedConsultationType = ConsultationType.video;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedConsultationType == ConsultationType.video
                            ? ClinicalColors.surfaceContainerLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedConsultationType == ConsultationType.video
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam,
                            size: 16,
                            color: _selectedConsultationType == ConsultationType.video
                                ? ClinicalColors.primary
                                : ClinicalColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Video (₹450)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedConsultationType == ConsultationType.video
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _selectedConsultationType == ConsultationType.video
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
          const SizedBox(height: 16),

          // Time Slots Grid & Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ClinicalColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Available',
                        style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ClinicalColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Selected',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3-Column Slot Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeSlots.map((slot) {
              final time = slot['time'] as String;
              final disabled = slot['disabled'] as bool;
              final isSelected = _selectedTimeSlot == time && !disabled;

              return SizedBox(
                width: (MediaQuery.of(context).size.width - 32 - 32 - 16) / 3,
                height: 42,
                child: InkWell(
                  onTap: disabled
                      ? null
                      : () {
                          setState(() {
                            _selectedTimeSlot = time;
                          });
                        },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ClinicalColors.primary
                          : disabled
                              ? ClinicalColors.surfaceContainerLow.withValues(alpha: 0.5)
                              : ClinicalColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: ClinicalColors.primary.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : disabled
                                ? ClinicalColors.outlineVariant
                                : ClinicalColors.onSurface,
                        decoration: disabled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutDoctorCard(Doctor doctor) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.person_pin, size: 20, color: ClinicalColors.primary),
              SizedBox(width: 8),
              Text(
                'About Doctor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            doctor.bio,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: ClinicalColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.translate, size: 16, color: ClinicalColors.tertiary),
              const SizedBox(width: 6),
              const Text(
                'Languages: ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
              Expanded(
                child: Text(
                  doctor.languages,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ClinicalColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCard(Doctor doctor) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.medical_services, size: 20, color: ClinicalColors.primary),
              SizedBox(width: 8),
              Text(
                'Services Offered',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: doctor.services.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ClinicalColors.onSurface,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(Doctor doctor) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.history_edu, size: 20, color: ClinicalColors.primary),
              SizedBox(width: 8),
              Text(
                'Experience & Education',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...doctor.timeline.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == doctor.timeline.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item.isCurrent ? ClinicalColors.primary : ClinicalColors.outlineVariant,
                        shape: BoxShape.circle,
                        boxShadow: item.isCurrent
                            ? [
                                BoxShadow(
                                  color: ClinicalColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 38,
                        color: ClinicalColors.surfaceContainerHigh,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.institution} · ${item.period}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: ClinicalColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildClinicLocationCard(Doctor doctor) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, size: 20, color: ClinicalColors.primary),
              SizedBox(width: 8),
              Text(
                'Clinic Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            doctor.hospital,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ClinicalColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            doctor.clinicAddress,
            style: const TextStyle(
              fontSize: 12,
              color: ClinicalColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.near_me, size: 12, color: ClinicalColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      doctor.clinicDistance,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ClinicalColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Interactive Map Simulation Card
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuChxlPYzDZElUsEPVUHfKRvGIQFbG48-vlKZcyan4BHpHzNwi8sG3UeKnM4EPMkt8G0L1x9JNJr8XdLnXVk_QYB5e9bWeEGUSq1aiPKTuSGAiJ4gWkgk9gXALntAx4JBtZogQSWXI9mzEEiJWbm5KPwhkj8hTObNdcA2mYG_XDLnbIxXZYAtR1EX6o76d4Mt43bnJJ7xF-nzPT81X0cpwNIU07nccf_xNg61tvtoumX',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Calling clinic: ${doctor.clinicPhone}')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: ClinicalColors.onSurface,
                          minimumSize: const Size(110, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.call, size: 15, color: ClinicalColors.primary),
                        label: Text(doctor.clinicPhone, style: const TextStyle(fontSize: 11)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening directions in maps...')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClinicalColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.directions, size: 15),
                        label: const Text('Directions', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(Doctor doctor) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.rate_review, size: 20, color: ClinicalColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Patient Reviews',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                '${doctor.reviewsCount} Verified',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Rating Breakdown Bento
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(Icons.star, size: 14, color: Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'out of 5',
                      style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar('5★', 0.92, '92%'),
                      const SizedBox(height: 4),
                      _buildRatingBar('4★', 0.06, '6%'),
                      const SizedBox(height: 4),
                      _buildRatingBar('3★', 0.02, '2%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Recent Reviews List
          ...doctor.reviews.map((rev) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ClinicalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: ClinicalColors.primaryFixed,
                            child: Text(
                              rev.reviewerInitials,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            rev.reviewerName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        rev.timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      rev.rating.toInt(),
                      (index) => const Icon(Icons.star, size: 14, color: Colors.amber),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rev.comment,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: ClinicalColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }),

          // View all reviews text button
          Center(
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Showing all ${doctor.reviewsCount} reviews')),
                );
              },
              icon: const Text(
                'View all reviews',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              label: const Icon(Icons.arrow_forward, size: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String starLabel, double ratio, String percentLabel) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            starLabel,
            style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: ClinicalColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation<Color>(ClinicalColors.primary),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 24,
          child: Text(
            percentLabel,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBookingDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest.withValues(alpha: 0.98),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consultation Fee',
                  style: TextStyle(
                    fontSize: 11,
                    color: ClinicalColors.onSurfaceVariant,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${_currentFee.toInt()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Verified',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ClinicalColors.tertiary,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Includes pre-screening',
                  style: TextStyle(
                    fontSize: 10,
                    color: ClinicalColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _onBookPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: ClinicalColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                label: const Icon(Icons.calendar_today, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
