import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MedicalRecordItem {
  final String id;
  final String title;
  final String category; // 'report', 'lab', 'prescription', 'note'
  final String doctorName;
  final String date;
  final String fileSize;
  final String format;
  final bool isVerified;
  final bool isDigitallySigned;

  MedicalRecordItem({
    required this.id,
    required this.title,
    required this.category,
    required this.doctorName,
    required this.date,
    required this.fileSize,
    this.format = 'PDF',
    this.isVerified = true,
    this.isDigitallySigned = true,
  });
}

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  late List<MedicalRecordItem> _records;

  @override
  void initState() {
    super.initState();
    _initializeRecords();
  }

  void _initializeRecords() {
    _records = [
      MedicalRecordItem(
        id: '1',
        title: 'Echocardiogram_Report_Final.pdf',
        category: 'report',
        doctorName: 'Dr. Sarah Johnson, MD',
        date: 'Oct 12, 2026',
        fileSize: '2.4 MB',
        isVerified: true,
        isDigitallySigned: true,
      ),
      MedicalRecordItem(
        id: '2',
        title: 'Lipid_Panel_Lab_Results.pdf',
        category: 'lab',
        doctorName: 'Pathology Core Lab',
        date: 'Sep 28, 2026',
        fileSize: '840 KB',
        isVerified: true,
        isDigitallySigned: false,
      ),
      MedicalRecordItem(
        id: '3',
        title: 'Cardiology_Prescription_Rx.pdf',
        category: 'prescription',
        doctorName: 'Dr. Sarah Johnson, MD',
        date: 'Sep 28, 2026',
        fileSize: '420 KB',
        isVerified: true,
        isDigitallySigned: true,
      ),
      MedicalRecordItem(
        id: '4',
        title: 'Consultation_Summary_Notes.pdf',
        category: 'note',
        doctorName: 'Dr. Sarah Johnson, MD',
        date: 'Aug 15, 2026',
        fileSize: '1.1 MB',
        isVerified: true,
        isDigitallySigned: true,
      ),
      MedicalRecordItem(
        id: '5',
        title: 'Comprehensive_Metabolic_Panel.pdf',
        category: 'lab',
        doctorName: 'St. Jude Health Diagnostics',
        date: 'Aug 10, 2026',
        fileSize: '950 KB',
        isVerified: true,
        isDigitallySigned: false,
      ),
      MedicalRecordItem(
        id: '6',
        title: 'Chest_XRay_Digital_Scan.pdf',
        category: 'report',
        doctorName: 'Dr. Marcus Vance, MD',
        date: 'Jul 22, 2026',
        fileSize: '4.8 MB',
        isVerified: true,
        isDigitallySigned: true,
      ),
      MedicalRecordItem(
        id: '7',
        title: 'Atorvastatin_Refill_Authorization.pdf',
        category: 'prescription',
        doctorName: 'Dr. Sarah Johnson, MD',
        date: 'Jul 15, 2026',
        fileSize: '310 KB',
        isVerified: true,
        isDigitallySigned: true,
      ),
      MedicalRecordItem(
        id: '8',
        title: 'Lisinopril_Daily_Dosage_Prescription.pdf',
        category: 'prescription',
        doctorName: 'Dr. Michael Chen, MD',
        date: 'Jun 30, 2026',
        fileSize: '380 KB',
        isVerified: true,
        isDigitallySigned: true,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicalRecordItem> get _filteredRecords {
    return _records.where((rec) {
      final matchesCategory = _selectedCategory == 'all' || rec.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          rec.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rec.doctorName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int _countForCategory(String category) {
    if (category == 'all') return _records.length;
    return _records.where((r) => r.category == category).length;
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
        title: const Text(
          'Medical Records',
          style: TextStyle(
            color: ClinicalColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: ClinicalColors.onSurfaceVariant),
            onPressed: _showVaultSecurityDialog,
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Vault Security & Storage Status Card
                _buildVaultStatusCard(),
                const SizedBox(height: 14),

                // Search Bar
                _buildSearchBar(),
                const SizedBox(height: 12),

                // Category Filter Pills
                _buildCategoryPills(),
                const SizedBox(height: 16),

                // Document Feed or Empty State
                if (_filteredRecords.isEmpty)
                  _buildEmptyState()
                else
                  ..._filteredRecords.map(_buildDocumentCard),
              ],
            ),
          ),

          // Uploading State Overlay
          if (_isUploading) _buildUploadingOverlay(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadBottomSheet,
        backgroundColor: ClinicalColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Upload', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildVaultStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ClinicalColors.secondaryFixed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.verified_user, color: ClinicalColors.onSecondaryFixed, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'HIPAA COMPLIANT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                              color: ClinicalColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: ClinicalColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '256-Bit AES',
                            style: TextStyle(
                              fontSize: 11,
                              color: ClinicalColors.outline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'End-to-end encrypted medical vault',
                        style: TextStyle(
                          fontSize: 12,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.lock, size: 20, color: ClinicalColors.onSurfaceVariant),
                onPressed: _showVaultSecurityDialog,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Cloud Vault Allocation', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurface, fontWeight: FontWeight.w500)),
              Text('14.8 MB of 500 MB', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.03,
              minHeight: 6,
              backgroundColor: ClinicalColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(ClinicalColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Search records, lab tests, prescriptions...',
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

  Widget _buildCategoryPills() {
    final categories = [
      {'id': 'all', 'label': 'All'},
      {'id': 'prescription', 'label': 'Prescriptions'},
      {'id': 'lab', 'label': 'Lab Reports'},
      {'id': 'report', 'label': 'Medical Reports'},
      {'id': 'note', 'label': 'Doctor Notes'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat['id'];
          final count = _countForCategory(cat['id']!);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat['label']!),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.25)
                          : ClinicalColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
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
              onSelected: (_) => setState(() => _selectedCategory = cat['id']!),
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

  Widget _buildDocumentCard(MedicalRecordItem item) {
    IconData icon;
    Color iconColor;

    switch (item.category) {
      case 'prescription':
        icon = Icons.medication;
        iconColor = ClinicalColors.secondary;
        break;
      case 'lab':
        icon = Icons.science;
        iconColor = ClinicalColors.tertiary;
        break;
      case 'note':
        icon = Icons.edit_note;
        iconColor = ClinicalColors.primary;
        break;
      case 'report':
      default:
        icon = Icons.favorite_border;
        iconColor = ClinicalColors.primary;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail / Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: iconColor, size: 22),
                      const SizedBox(height: 2),
                      Text(
                        item.format,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: ClinicalColors.secondaryFixed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _categoryDisplayName(item.category),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ClinicalColors.onSecondaryFixedVariant,
                              ),
                            ),
                          ),
                          if (item.isDigitallySigned) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: ClinicalColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, size: 10, color: ClinicalColors.tertiary),
                                  SizedBox(width: 3),
                                  Text(
                                    'Signed',
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
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ClinicalColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${item.doctorName} • ${item.date} • ${item.fileSize}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: ClinicalColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _viewDocument(item),
                      icon: const Icon(Icons.visibility, size: 15),
                      label: const Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ClinicalColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _downloadDocument(item),
                      icon: const Icon(Icons.download, size: 15),
                      label: const Text('Download', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ClinicalColors.onSurface,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: ClinicalColors.outline),
                  onPressed: () => _deleteDocument(item),
                  tooltip: 'Delete document',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _categoryDisplayName(String category) {
    switch (category) {
      case 'prescription':
        return 'Prescription';
      case 'lab':
        return 'Lab Report';
      case 'note':
        return 'Doctor Note';
      case 'report':
      default:
        return 'Medical Report';
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.folder_off, size: 32, color: ClinicalColors.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'No documents found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
          ),
          const SizedBox(height: 6),
          const Text(
            'There are no medical records matching your current filter. You can upload diagnostic reports or prescriptions at any time.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              _selectedCategory = 'all';
              _searchQuery = '';
              _searchController.clear();
            }),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ClinicalColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 20),
              const Text(
                'Encrypting & Uploading...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_uploadProgress * 100).toInt()}% complete',
                style: const TextStyle(fontSize: 12, color: ClinicalColors.outline),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  minHeight: 6,
                  backgroundColor: ClinicalColors.surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation<Color>(ClinicalColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ClinicalColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Add Medical Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Encrypted & verified upon arrival', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildUploadOption(
                    icon: Icons.photo_camera,
                    title: 'Camera',
                    subtitle: 'Scan paper',
                    bgColor: ClinicalColors.secondaryFixed,
                    textColor: ClinicalColors.onSecondaryFixed,
                    onTap: () {
                      Navigator.pop(ctx);
                      _simulateUpload('Camera_Scan_ECG.pdf', 'report');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildUploadOption(
                    icon: Icons.image,
                    title: 'Photos',
                    subtitle: 'From library',
                    bgColor: ClinicalColors.tertiaryFixed,
                    textColor: ClinicalColors.onTertiaryFixed,
                    onTap: () {
                      Navigator.pop(ctx);
                      _simulateUpload('Lab_Photo_Bloodwork.png', 'lab');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildUploadOption(
                    icon: Icons.upload_file,
                    title: 'Files',
                    subtitle: 'PDF, DICOM',
                    bgColor: ClinicalColors.primaryFixed,
                    textColor: ClinicalColors.onPrimaryFixed,
                    onTap: () {
                      Navigator.pop(ctx);
                      _simulateUpload('Hospital_Summary_Discharge.pdf', 'report');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ClinicalColors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: ClinicalColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Supports PDF, JPG, PNG, DICOM up to 25MB per document.',
                      style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: ClinicalColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: textColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  void _simulateUpload(String fileName, String category) {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.2;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _uploadProgress = 0.6);
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _uploadProgress = 1.0;
          _isUploading = false;
          _records.insert(
            0,
            MedicalRecordItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: fileName,
              category: category,
              doctorName: 'Uploaded by Patient',
              date: 'Just now',
              fileSize: '1.4 MB',
              isVerified: true,
              isDigitallySigned: false,
            ),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('$fileName securely uploaded to Vault!'),
              ],
            ),
            backgroundColor: ClinicalColors.tertiary,
          ),
        );
      }
    });
  }

  void _viewDocument(MedicalRecordItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${item.doctorName}'),
            const SizedBox(height: 4),
            Text('Date: ${item.date} • Size: ${item.fileSize}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ClinicalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Clinical findings verified by board-certified specialist. 256-bit hash signature validated.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _downloadDocument(item);
            },
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadDocument(MedicalRecordItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${item.title}... Saved to local storage')),
    );
  }

  void _deleteDocument(MedicalRecordItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Medical Record?'),
        content: Text('Are you sure you want to permanently delete "${item.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _records.removeWhere((r) => r.id == item.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Record removed from vault')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: ClinicalColors.error, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showVaultSecurityDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shield, color: ClinicalColors.tertiary),
            SizedBox(width: 8),
            Text('Vault Encryption & HIPAA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: const Text(
          'All documents stored in your CareFlow Medical Vault are secured via 256-bit AES encryption at rest and in transit. Only you and your authorized treating providers have decryption privileges.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Understood')),
        ],
      ),
    );
  }
}
