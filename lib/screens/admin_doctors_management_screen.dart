import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdminDoctorItem {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String npi;
  final String experience;
  final String status; // 'pending', 'verified', 'rejected', 'suspended'
  final String avatarUrl;

  AdminDoctorItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.npi,
    required this.experience,
    required this.status,
    required this.avatarUrl,
  });
}

class AdminDoctorsManagementScreen extends StatefulWidget {
  const AdminDoctorsManagementScreen({super.key});

  @override
  State<AdminDoctorsManagementScreen> createState() =>
      _AdminDoctorsManagementScreenState();
}

class _AdminDoctorsManagementScreenState
    extends State<AdminDoctorsManagementScreen> {
  String _selectedStatus = 'All';
  String _selectedSpecialty = 'All Specialties';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late List<AdminDoctorItem> _doctors;

  @override
  void initState() {
    super.initState();
    _initializeDoctors();
  }

  void _initializeDoctors() {
    _doctors = [
      AdminDoctorItem(
        id: '1',
        name: 'Dr. Emily Stone, MD',
        specialty: 'Neurology',
        hospital: 'St. Jude Neurological Institute',
        npi: '1942083921',
        experience: '8 Yrs',
        status: 'pending',
        avatarUrl:
            'https://images.unsplash.com/photo-1594824813593-18c64269d0d3?auto=format&fit=crop&w=300&q=80',
      ),
      AdminDoctorItem(
        id: '2',
        name: 'Dr. Sarah Johnson, MD',
        specialty: 'Cardiology',
        hospital: 'St. Jude Heart Clinic',
        npi: '1084920491',
        experience: '12 Yrs',
        status: 'verified',
        avatarUrl:
            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=300&q=80',
      ),
      AdminDoctorItem(
        id: '3',
        name: 'Dr. Michael Chen, MD',
        specialty: 'Pediatrics',
        hospital: 'Children\'s Clinical Pavilion',
        npi: '1492048102',
        experience: '15 Yrs',
        status: 'verified',
        avatarUrl:
            'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=300&q=80',
      ),
      AdminDoctorItem(
        id: '4',
        name: 'Dr. Robert Martinez, DO',
        specialty: 'Orthopedics',
        hospital: 'Valley Sports Medicine Center',
        npi: '1820492810',
        experience: '6 Yrs',
        status: 'pending',
        avatarUrl:
            'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&w=300&q=80',
      ),
      AdminDoctorItem(
        id: '5',
        name: 'Dr. Lisa Ray, MD',
        specialty: 'Dermatology',
        hospital: 'Skin & Laser Medical Pavilion',
        npi: '1294029481',
        experience: '10 Yrs',
        status: 'suspended',
        avatarUrl:
            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=300&q=80',
      ),
      AdminDoctorItem(
        id: '6',
        name: 'Dr. Alan Harper, MD',
        specialty: 'Cardiology',
        hospital: 'Metro General Hospital',
        npi: '1749204812',
        experience: '4 Yrs',
        status: 'rejected',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminDoctorItem> get _filteredDoctors {
    return _doctors.where((doc) {
      final matchesStatus = _selectedStatus == 'All' ||
          doc.status.toLowerCase() == _selectedStatus.toLowerCase();
      final matchesSpecialty = _selectedSpecialty == 'All Specialties' ||
          doc.specialty == _selectedSpecialty;
      final matchesSearch = _searchQuery.isEmpty ||
          doc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.npi.contains(_searchQuery) ||
          doc.hospital.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSpecialty && matchesSearch;
    }).toList();
  }

  int _countForStatus(String status) {
    if (status == 'All') return _doctors.length;
    return _doctors.where((d) => d.status.toLowerCase() == status.toLowerCase()).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalColors.surface,
      appBar: AppBar(
        backgroundColor: ClinicalColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ClinicalColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Doctor Directory & Credentials',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
            ),
            Text(
              'Hospital Regulatory Oversight',
              style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Doctor registry exported as certified PDF')),
              );
            },
            tooltip: 'Export roster',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ClinicalColors.primary,
              child: const Icon(Icons.badge, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Vital Counters
            _buildVitalCounters(),
            const SizedBox(height: 14),

            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 12),

            // Status Filter Chips
            _buildStatusFilterChips(),
            const SizedBox(height: 12),

            // Specialties Filter Dropdown
            _buildSpecialtiesFilter(),
            const SizedBox(height: 16),

            // Doctor List Roster
            if (_filteredDoctors.isEmpty)
              _buildEmptyState()
            else
              ..._filteredDoctors.map(_buildDoctorCard),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCounters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: ClinicalColors.secondaryFixed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.badge, color: ClinicalColors.onSecondaryFixed, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Active Registry', style: TextStyle(fontSize: 10, color: ClinicalColors.outline, fontWeight: FontWeight.bold)),
                    SizedBox(height: 1),
                    Text('184 Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClinicalColors.errorContainer.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: ClinicalColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.notification_important, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Attention', style: TextStyle(fontSize: 10, color: ClinicalColors.onErrorContainer, fontWeight: FontWeight.bold)),
                    SizedBox(height: 1),
                    Text('12 Action Req.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ClinicalColors.onErrorContainer)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Search doctors by name, NPI, or hospital...',
          hintStyle: const TextStyle(fontSize: 13, color: ClinicalColors.outline),
          prefixIcon: const Icon(Icons.search, size: 20, color: ClinicalColors.outline),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final tabs = [
      {'label': 'All'},
      {'label': 'Pending'},
      {'label': 'Verified'},
      {'label': 'Rejected'},
      {'label': 'Suspended'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((t) {
          final isSelected = _selectedStatus == t['label'];
          final count = _countForStatus(t['label']!);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(t['label']!),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withValues(alpha: 0.25) : ClinicalColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedStatus = t['label']!),
              selectedColor: ClinicalColors.primary,
              backgroundColor: ClinicalColors.surfaceContainer,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : ClinicalColors.onSurface,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpecialtiesFilter() {
    final specialties = [
      'All Specialties',
      'Cardiology',
      'Neurology',
      'Pediatrics',
      'Orthopedics',
      'Dermatology',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSpecialty,
          isExpanded: true,
          items: specialties.map((s) {
            return DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)));
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedSpecialty = val);
          },
        ),
      ),
    );
  }

  Widget _buildDoctorCard(AdminDoctorItem doc) {
    Color badgeBg;
    Color badgeFg;
    String badgeLabel;

    switch (doc.status) {
      case 'verified':
        badgeBg = ClinicalColors.tertiaryFixed;
        badgeFg = ClinicalColors.onTertiaryFixed;
        badgeLabel = 'Verified';
        break;
      case 'rejected':
        badgeBg = ClinicalColors.errorContainer;
        badgeFg = ClinicalColors.onErrorContainer;
        badgeLabel = 'Rejected';
        break;
      case 'suspended':
        badgeBg = ClinicalColors.surfaceVariant;
        badgeFg = ClinicalColors.onSurfaceVariant;
        badgeLabel = 'Suspended';
        break;
      case 'pending':
      default:
        badgeBg = ClinicalColors.secondaryFixed;
        badgeFg = ClinicalColors.onSecondaryFixedVariant;
        badgeLabel = 'Pending Review';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(doc.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              doc.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(10)),
                            child: Text(badgeLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeFg)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('${doc.specialty} • ${doc.experience} exp', style: const TextStyle(fontSize: 12, color: ClinicalColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(doc.hospital, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                      const SizedBox(height: 2),
                      Text('NPI: ${doc.npi}', style: const TextStyle(fontSize: 10, color: ClinicalColors.outline)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showDoctorVerificationDetails(doc),
                  icon: const Icon(Icons.verified_user, size: 15),
                  label: const Text('Credentials', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                Row(
                  children: [
                    if (doc.status != 'verified')
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final idx = _doctors.indexWhere((d) => d.id == doc.id);
                            if (idx != -1) {
                              _doctors[idx] = AdminDoctorItem(
                                id: doc.id,
                                name: doc.name,
                                specialty: doc.specialty,
                                hospital: doc.hospital,
                                npi: doc.npi,
                                experience: doc.experience,
                                status: 'verified',
                                avatarUrl: doc.avatarUrl,
                              );
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${doc.name} approved & registered')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClinicalColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    if (doc.status == 'verified')
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            final idx = _doctors.indexWhere((d) => d.id == doc.id);
                            if (idx != -1) {
                              _doctors[idx] = AdminDoctorItem(
                                id: doc.id,
                                name: doc.name,
                                specialty: doc.specialty,
                                hospital: doc.hospital,
                                npi: doc.npi,
                                experience: doc.experience,
                                status: 'suspended',
                                avatarUrl: doc.avatarUrl,
                              );
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${doc.name} privileges suspended')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ClinicalColors.error,
                          side: const BorderSide(color: ClinicalColors.error),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Suspend', style: TextStyle(fontSize: 11)),
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Icon(Icons.person_search, size: 40, color: ClinicalColors.outline),
          SizedBox(height: 12),
          Text('No doctors match the selected filter', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showDoctorVerificationDetails(AdminDoctorItem doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Credentials: ${doc.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            _buildCredRow('National Provider Identifier (NPI)', doc.npi),
            _buildCredRow('State Medical License', 'CA-MD-982104 (Active • Exp: 2027)'),
            _buildCredRow('DEA Controlled Substance Reg.', 'BJ-9481920 (Schedule II-V)'),
            _buildCredRow('Board Certification', 'American Board of Medical Specialties (ABMS)'),
            _buildCredRow('Medical Malpractice Coverage', 'Norcal Mutual • \$2M / \$4M Active'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Verification dossier verified for ${doc.name}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirm Credential Check'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: ClinicalColors.outline, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
