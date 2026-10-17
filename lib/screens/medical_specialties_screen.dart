import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/clinical_app_bar.dart';
import '../models/doctor.dart';
import '../data/mock_healthcare_data.dart';
import 'search_results_screen.dart';

class MedicalSpecialtiesScreen extends StatefulWidget {
  const MedicalSpecialtiesScreen({super.key});

  @override
  State<MedicalSpecialtiesScreen> createState() => _MedicalSpecialtiesScreenState();
}

class _MedicalSpecialtiesScreenState extends State<MedicalSpecialtiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeCategory = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Specialty> get _filteredSpecialties {
    final query = _searchController.text.trim().toLowerCase();
    return MockHealthcareData.specialties.where((s) {
      if (_activeCategory != 'all' && s.category != _activeCategory) {
        return false;
      }
      if (query.isNotEmpty && !s.name.toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();
  }

  void _onSpecialtyTap(Specialty specialty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          initialSpecialty: specialty.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredSpecialties;

    return Scaffold(
      appBar: const ClinicalAppBar(
        title: 'Browse Specialties',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Context & Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CLINICAL CARE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: ClinicalColors.primary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Medical Specialties',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: ClinicalColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '10+ Fields',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ClinicalColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Find experienced specialists across clinical departments with instant consultation slots.',
                style: TextStyle(
                  fontSize: 13,
                  color: ClinicalColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search clinical field, condition...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: ClinicalColors.outline),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
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
              const SizedBox(height: 14),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('All (10)', 'all'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Primary Care', 'primary'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Surgical & Skeletal', 'surgical'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Family Health', 'pediatric'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick Telehealth Banner Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ClinicalColors.primaryFixed.withValues(alpha: 0.7),
                      ClinicalColors.surfaceContainerHigh,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: ClinicalColors.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Instant Triage',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ClinicalColors.onPrimaryFixedVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Need urgent medical help?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Connect with on-call MDs in under 3 mins.',
                            style: TextStyle(
                              fontSize: 12,
                              color: ClinicalColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.video_call,
                        color: ClinicalColors.primary,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section Title: Specialized Departments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Specialized Departments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ClinicalColors.onSurface,
                    ),
                  ),
                  Text(
                    'Showing ${list.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ClinicalColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2-Column Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final specialty = list[index];
                  return _buildSpecialtyCard(specialty);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String categoryKey) {
    final isSelected = _activeCategory == categoryKey;
    return InkWell(
      onTap: () {
        setState(() {
          _activeCategory = categoryKey;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ClinicalColors.primary : ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : ClinicalColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard(Specialty specialty) {
    return InkWell(
      onTap: () => _onSpecialtyTap(specialty),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    specialty.icon,
                    size: 22,
                    color: specialty.color ?? ClinicalColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: ClinicalColors.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Live',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  specialty.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ClinicalColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${specialty.doctorsCount} Doctors',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: ClinicalColors.outline,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
