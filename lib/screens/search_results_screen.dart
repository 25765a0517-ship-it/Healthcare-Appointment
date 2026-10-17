import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/clinical_app_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/doctor_search_empty_state.dart';
import '../models/doctor.dart';
import '../data/mock_healthcare_data.dart';
import 'medical_specialties_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialSpecialty;

  const SearchResultsScreen({
    super.key,
    this.initialQuery,
    this.initialSpecialty,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Doctor> _allDoctors;
  late FilterCriteria _criteria;

  @override
  void initState() {
    super.initState();
    _allDoctors = MockHealthcareData.getDoctors();
    _criteria = FilterCriteria(
      specialty: widget.initialSpecialty ?? 'All',
    );
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Doctor> get _filteredDoctors {
    final query = _searchController.text.trim().toLowerCase();

    return _allDoctors.where((doc) {
      // Search query filter
      if (query.isNotEmpty) {
        final matchesName = doc.name.toLowerCase().contains(query);
        final matchesSpecialty = doc.specialty.toLowerCase().contains(query);
        final matchesHospital = doc.hospital.toLowerCase().contains(query);
        if (!matchesName && !matchesSpecialty && !matchesHospital) {
          return false;
        }
      }

      // Specialty filter
      if (_criteria.specialty != 'All') {
        if (!doc.specialty.toLowerCase().contains(_criteria.specialty.toLowerCase())) {
          return false;
        }
      }

      // Availability filter
      if (_criteria.availableToday && !doc.availableToday) {
        return false;
      }

      // Video visit filter
      if (_criteria.videoVisitOnly && !doc.isVideoVisitAvailable) {
        return false;
      }

      // Rating filter
      if (_criteria.topRatedOnly && doc.rating < 4.8) {
        return false;
      }

      // Fee filter
      if (_criteria.feeRange == '<50' && doc.consultationFee >= 50) {
        return false;
      }
      if (_criteria.feeRange == '50-100' &&
          (doc.consultationFee < 50 || doc.consultationFee > 100)) {
        return false;
      }
      if (_criteria.feeRange == '>100' && doc.consultationFee <= 100) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        if (_criteria.sortBy == 'rating') {
          return b.rating.compareTo(a.rating);
        } else if (_criteria.sortBy == 'fee') {
          return a.consultationFee.compareTo(b.consultationFee);
        } else if (_criteria.sortBy == 'distance') {
          return a.distanceKm.compareTo(b.distanceKm);
        }
        return 0; // recommended order
      });
  }

  void _openFilterSheet() {
    FilterBottomSheet.show(
      context,
      currentCriteria: _criteria,
      onApply: (newCriteria) {
        setState(() {
          _criteria = newCriteria;
        });
      },
    );
  }

  void _bookDoctor(Doctor doctor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: ClinicalColors.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: ClinicalColors.primaryFixed,
                  child: const Icon(Icons.person, color: ClinicalColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${doctor.specialty} · \$${doctor.consultationFee}/visit',
                        style: const TextStyle(color: ClinicalColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ClinicalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: ClinicalColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Earliest Slot: Today at 2:30 PM',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Appointment confirmed with ${doctor.name}!'),
                    backgroundColor: ClinicalColors.tertiary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctors = _filteredDoctors;

    return Scaffold(
      appBar: const ClinicalAppBar(
        title: 'Search Doctors',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Active Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search doctors, specialties...',
                    prefixIcon: const Icon(Icons.search, color: ClinicalColors.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: ClinicalColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),

            // Quick Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  // Master Filter Button with Count
                  InkWell(
                    onTap: _openFilterSheet,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: ClinicalColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: ClinicalColors.primary.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tune, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          const Text(
                            'Filters',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_criteria.activeFilterCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: ClinicalColors.primaryFixed,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_criteria.activeFilterCount}',
                                style: const TextStyle(
                                  color: ClinicalColors.onPrimaryFixed,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Quick Filter Chip: Available Today
                  _buildQuickPill(
                    label: 'Available Today',
                    isActive: _criteria.availableToday,
                    onTap: () {
                      setState(() {
                        _criteria.availableToday = !_criteria.availableToday;
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  // Quick Filter Chip: Top Rated 4.8+
                  _buildQuickPill(
                    label: 'Top Rated 4.8+',
                    icon: Icons.star,
                    isActive: _criteria.topRatedOnly,
                    onTap: () {
                      setState(() {
                        _criteria.topRatedOnly = !_criteria.topRatedOnly;
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  // Quick Filter Chip: Fee < $100
                  _buildQuickPill(
                    label: 'Fee < \$100',
                    isActive: _criteria.feeRange == '<50' || _criteria.feeRange == '50-100',
                    onTap: () {
                      setState(() {
                        _criteria.feeRange =
                            _criteria.feeRange == '50-100' ? 'any' : '50-100';
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  // Quick Filter Chip: Video Visit
                  _buildQuickPill(
                    label: 'Video Visit',
                    icon: Icons.video_call_outlined,
                    isActive: _criteria.videoVisitOnly,
                    onTap: () {
                      setState(() {
                        _criteria.videoVisitOnly = !_criteria.videoVisitOnly;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Results Count & Sorting Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Found ${doctors.length} verified doctors',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ClinicalColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: ClinicalColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    initialValue: _criteria.sortBy,
                    onSelected: (val) {
                      setState(() => _criteria.sortBy = val);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'recommended', child: Text('Relevance')),
                      const PopupMenuItem(value: 'rating', child: Text('Highest Rated')),
                      const PopupMenuItem(value: 'fee', child: Text('Lowest Fee')),
                      const PopupMenuItem(value: 'distance', child: Text('Nearest')),
                    ],
                    child: Row(
                      children: [
                        Text(
                          _getSortLabel(_criteria.sortBy),
                          style: const TextStyle(
                            fontSize: 13,
                            color: ClinicalColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.expand_more, size: 16, color: ClinicalColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content: List of Doctors or Empty State
            Expanded(
              child: doctors.isEmpty
                  ? DoctorSearchEmptyState(
                      onResetFilters: () {
                        setState(() {
                          _searchController.clear();
                          _criteria = FilterCriteria();
                        });
                      },
                      onBrowseSpecialties: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicalSpecialtiesScreen(),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return _buildDoctorCard(doctors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'rating':
        return 'Highest Rated';
      case 'fee':
        return 'Lowest Fee';
      case 'distance':
        return 'Nearest';
      default:
        return 'Relevance';
    }
  }

  Widget _buildQuickPill({
    required String label,
    IconData? icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? ClinicalColors.surfaceContainerHigh
              : ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? ClinicalColors.primary : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isActive ? ClinicalColors.primary : ClinicalColors.outline,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? ClinicalColors.primary : ClinicalColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      doctor.avatarUrl,
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: ClinicalColors.primaryFixed,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: ClinicalColors.primary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            doctor.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            size: 20,
                            color: doctor.isBookmarked
                                ? ClinicalColors.primary
                                : ClinicalColors.outline,
                          ),
                          onPressed: () {
                            setState(() {
                              doctor.isBookmarked = !doctor.isBookmarked;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${doctor.specialty} · ${doctor.hospital}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 15, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          '${doctor.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${doctor.reviewsCount})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: ClinicalColors.outline,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('•', style: TextStyle(color: ClinicalColors.outlineVariant)),
                        const SizedBox(width: 8),
                        Text(
                          '${doctor.experienceYears} yrs exp',
                          style: const TextStyle(
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
          const SizedBox(height: 12),

          // Detail Strip: Distance & Fee
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
                    const Icon(Icons.location_on, size: 15, color: ClinicalColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.distanceKm} km away',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    text: '\$${doctor.consultationFee}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurface,
                    ),
                    children: const [
                      TextSpan(
                        text: ' / visit',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: ClinicalColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Book CTA
          ElevatedButton(
            onPressed: () => _bookDoctor(doctor),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Book Now'),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
