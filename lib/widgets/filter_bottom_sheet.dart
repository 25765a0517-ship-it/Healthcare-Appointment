import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterCriteria {
  String sortBy;
  String specialty;
  bool availableToday;
  bool topRatedOnly;
  bool videoVisitOnly;
  String feeRange; // 'any', '<50', '50-100', '>100'

  FilterCriteria({
    this.sortBy = 'recommended',
    this.specialty = 'All',
    this.availableToday = false,
    this.topRatedOnly = false,
    this.videoVisitOnly = false,
    this.feeRange = 'any',
  });

  FilterCriteria copyWith({
    String? sortBy,
    String? specialty,
    bool? availableToday,
    bool? topRatedOnly,
    bool? videoVisitOnly,
    String? feeRange,
  }) {
    return FilterCriteria(
      sortBy: sortBy ?? this.sortBy,
      specialty: specialty ?? this.specialty,
      availableToday: availableToday ?? this.availableToday,
      topRatedOnly: topRatedOnly ?? this.topRatedOnly,
      videoVisitOnly: videoVisitOnly ?? this.videoVisitOnly,
      feeRange: feeRange ?? this.feeRange,
    );
  }

  int get activeFilterCount {
    int count = 0;
    if (sortBy != 'recommended') count++;
    if (specialty != 'All') count++;
    if (availableToday) count++;
    if (topRatedOnly) count++;
    if (videoVisitOnly) count++;
    if (feeRange != 'any') count++;
    return count;
  }
}

class FilterBottomSheet extends StatefulWidget {
  final FilterCriteria initialCriteria;
  final ValueChanged<FilterCriteria> onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<FilterCriteria?> show(
    BuildContext context, {
    required FilterCriteria currentCriteria,
    required ValueChanged<FilterCriteria> onApply,
  }) {
    return showModalBottomSheet<FilterCriteria>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialCriteria: currentCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterCriteria _criteria;

  @override
  void initState() {
    super.initState();
    _criteria = widget.initialCriteria.copyWith();
  }

  void _resetAll() {
    setState(() {
      _criteria = FilterCriteria();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.86,
      ),
      decoration: const BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: ClinicalColors.outlineVariant.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: ClinicalColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tune,
                    size: 18,
                    color: ClinicalColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Filter & Refine',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetAll,
                  child: const Text(
                    'Reset All',
                    style: TextStyle(
                      color: ClinicalColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                  color: ClinicalColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Filter Options Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Sort By Section
                _buildSectionTitle('Sort By', 'Single choice'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSortChip('Recommended', 'recommended'),
                    _buildSortChip('Highest Rated', 'rating'),
                    _buildSortChip('Lowest Fee', 'fee'),
                    _buildSortChip('Nearest Distance', 'distance'),
                  ],
                ),
                const SizedBox(height: 24),

                // Availability
                _buildSectionTitle('Availability', 'Schedule time'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildToggleChip(
                      label: 'Available Today',
                      icon: Icons.event_available,
                      selected: _criteria.availableToday,
                      onSelected: (val) {
                        setState(() => _criteria.availableToday = val);
                      },
                    ),
                    _buildToggleChip(
                      label: 'Video Visit Available',
                      icon: Icons.video_call_outlined,
                      selected: _criteria.videoVisitOnly,
                      onSelected: (val) {
                        setState(() => _criteria.videoVisitOnly = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Specialty
                _buildSectionTitle('Specialty', 'Department'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'All',
                    'Cardiologist',
                    'Dermatologist',
                    'Pediatrician',
                    'General Physician',
                    'Orthopedic',
                  ].map((s) {
                    final selected = _criteria.specialty == s;
                    return ChoiceChip(
                      label: Text(s),
                      selected: selected,
                      selectedColor: ClinicalColors.primaryFixed,
                      backgroundColor: ClinicalColors.surfaceContainerLow,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                        color: selected ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selected ? ClinicalColors.primary : Colors.transparent,
                        ),
                      ),
                      onSelected: (_) {
                        setState(() => _criteria.specialty = s);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Minimum Rating
                _buildSectionTitle('Rating', 'Patient feedback'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildToggleChip(
                      label: 'Top Rated (4.8+ ★)',
                      icon: Icons.star,
                      selected: _criteria.topRatedOnly,
                      onSelected: (val) {
                        setState(() => _criteria.topRatedOnly = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Fee Range
                _buildSectionTitle('Consultation Fee', 'Per visit price'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFeeChip('Any Fee', 'any'),
                    _buildFeeChip('< \$50', '<50'),
                    _buildFeeChip('\$50 - \$100', '50-100'),
                    _buildFeeChip('> \$100', '>100'),
                  ],
                ),
              ],
            ),
          ),

          // Sticky Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_criteria);
                  Navigator.pop(context, _criteria);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Apply Filters'),
                    if (_criteria.activeFilterCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_criteria.activeFilterCount}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: ClinicalColors.onSurface,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: ClinicalColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSortChip(String label, String value) {
    final selected = _criteria.sortBy == value;
    return ChoiceChip(
      avatar: selected ? const Icon(Icons.check, size: 16, color: ClinicalColors.primary) : null,
      label: Text(label),
      selected: selected,
      selectedColor: ClinicalColors.primaryFixed,
      backgroundColor: ClinicalColors.surfaceContainerLow,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
        color: selected ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? ClinicalColors.primary : Colors.transparent,
        ),
      ),
      onSelected: (_) {
        setState(() => _criteria.sortBy = value);
      },
    );
  }

  Widget _buildToggleChip({
    required String label,
    required IconData icon,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return FilterChip(
      avatar: Icon(
        icon,
        size: 16,
        color: selected ? ClinicalColors.primary : ClinicalColors.outline,
      ),
      label: Text(label),
      selected: selected,
      selectedColor: ClinicalColors.primaryFixed,
      backgroundColor: ClinicalColors.surfaceContainerLow,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
        color: selected ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? ClinicalColors.primary : Colors.transparent,
        ),
      ),
      onSelected: onSelected,
    );
  }

  Widget _buildFeeChip(String label, String value) {
    final selected = _criteria.feeRange == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: ClinicalColors.primaryFixed,
      backgroundColor: ClinicalColors.surfaceContainerLow,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
        color: selected ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? ClinicalColors.primary : Colors.transparent,
        ),
      ),
      onSelected: (_) {
        setState(() => _criteria.feeRange = value);
      },
    );
  }
}
