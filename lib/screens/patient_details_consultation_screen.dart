import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PatientDetailsConsultationScreen extends StatefulWidget {
  final String patientName;
  final String mrn;

  const PatientDetailsConsultationScreen({
    super.key,
    this.patientName = 'Alex Kumar',
    this.mrn = '#PT-9420',
  });

  @override
  State<PatientDetailsConsultationScreen> createState() =>
      _PatientDetailsConsultationScreenState();
}

class _PatientDetailsConsultationScreenState
    extends State<PatientDetailsConsultationScreen> {
  int _activeTabIndex = 0; // 0 = Active Note, 1 = History & Vault
  bool _isSaving = false;
  bool _isSigned = false;

  final TextEditingController _chiefComplaintController = TextEditingController(
    text:
        'Mild exertional shortness of breath during morning jog; resolved within 5 minutes of rest. No syncope or radiating chest pain.',
  );
  final TextEditingController _observationsController = TextEditingController(
    text:
        'BP: 128/82 mmHg | Heart Rate: 74 bpm (Regular) | SpO2: 98% on room air. S1/S2 audible, no murmurs. Lungs clear to auscultation bilaterally.',
  );
  final TextEditingController _diagnosisController = TextEditingController(
    text:
        'Benign Exertional Tachycardia / Trace Exercise Dyspnea (ICD-10: R00.0)',
  );
  final TextEditingController _doctorNotesController = TextEditingController(
    text:
        'Patient responded well to initial lifestyle adjustments. Resting ECG today confirms normal sinus rhythm without acute ST-T elevation. Advised continued moderate aerobic training with smartwatch ceiling capped at 160 bpm.',
  );

  String _selectedFollowup = '4 Weeks';

  final List<Map<String, String>> _medications = [
    {
      'name': 'Metoprolol Tartrate 25mg',
      'instruction': 'Oral tablet • 1 tablet twice daily with meals',
      'details': 'Dispense: 60 • Refills: 2 • Pharmacy: Walgreens #3821',
    },
    {
      'name': 'CoQ10 Dietary Supplement 100mg',
      'instruction': 'Oral capsule • Daily morning with breakfast (OTC)',
      'details': 'Cardiac Cellular Support • Optional',
    },
  ];

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _observationsController.dispose();
    _diagnosisController.dispose();
    _doctorNotesController.dispose();
    super.dispose();
  }

  void _appendSymptomTag(String tag) {
    final clean = tag.replaceAll('+', '').trim();
    if (!_chiefComplaintController.text.contains(clean)) {
      setState(() {
        _chiefComplaintController.text =
            '${_chiefComplaintController.text.trim()} Patient also reports: $clean.';
      });
    }
  }

  void _finalizeEncounter() {
    setState(() {
      _isSaving = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isSigned = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.task_alt, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Encounter digitally signed & synchronized with EHR!'),
              ],
            ),
            backgroundColor: ClinicalColors.tertiary,
          ),
        );
      }
    });
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
              'Clinical Encounter',
              style: TextStyle(
                fontSize: 11,
                color: ClinicalColors.onSurfaceVariant,
              ),
            ),
            Text(
              'Clinical Consultation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_shared, color: ClinicalColors.primary),
            onPressed: () {
              setState(() => _activeTabIndex = 1);
            },
            tooltip: 'View patient vault',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {},
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
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Ambient Banner
                _buildConsultationStatusBar(),
                const SizedBox(height: 14),

                // Patient Identity Card & Demographics
                _buildPatientBioCard(),
                const SizedBox(height: 16),

                // Segment Tab Pills
                _buildTabPills(),
                const SizedBox(height: 16),

                // Tab Content
                if (_activeTabIndex == 0)
                  _buildActiveNoteView()
                else
                  _buildHistoryVaultView(),
              ],
            ),
          ),

          // Sticky Bottom Consultation Actions
          _buildStickyBottomBar(),
        ],
      ),
    );
  }

  Widget _buildConsultationStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const SizedBox(width: 8),
              const Text(
                'In Consultation • Confirmed (10:00 AM)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ClinicalColors.tertiary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.call, size: 18, color: ClinicalColors.primary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling patient direct telephone line...')),
                  );
                },
                tooltip: 'Direct call',
              ),
              IconButton(
                icon: const Icon(Icons.ios_share, size: 18, color: ClinicalColors.primary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('FHIR JSON clinical payload exported')),
                  );
                },
                tooltip: 'Export FHIR record',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientBioCard() {
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
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClinicalColors.surfaceContainerHigh,
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: ClinicalColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, size: 11, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.patientName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: ClinicalColors.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: ClinicalColors.primaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'O+ POS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: ClinicalColors.onPrimaryFixedVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'MRN ${widget.mrn} • Identity Verified',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ClinicalColors.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 11, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Intake Verified',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Demographics Grid
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ClinicalColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _buildDemographicCol('Age / DOB', '30 Yrs (Mar 14, 1994)')),
                Container(width: 1, height: 28, color: ClinicalColors.surfaceContainerHighest),
                Expanded(child: _buildDemographicCol('Gender & Lang', 'Male (EN, HI)')),
                Container(width: 1, height: 28, color: ClinicalColors.surfaceContainerHighest),
                Expanded(child: _buildDemographicCol('Clinical Visits', '14 (2 Active)')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemographicCol(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: ClinicalColors.outline, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildTabPills() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeTabIndex = 0),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _activeTabIndex == 0 ? ClinicalColors.surfaceContainerLowest : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _activeTabIndex == 0
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 18,
                      color: _activeTabIndex == 0 ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Active Note',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _activeTabIndex == 0 ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeTabIndex = 1),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _activeTabIndex == 1 ? ClinicalColors.surfaceContainerLowest : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _activeTabIndex == 1
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 18,
                      color: _activeTabIndex == 1 ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'History & Vault',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _activeTabIndex == 1 ? ClinicalColors.primary : ClinicalColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveNoteView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Attending Physician Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ClinicalColors.primaryFixed,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.medical_services, size: 18, color: ClinicalColors.onPrimaryFixed),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ATTENDING PHYSICIAN INPUT • DR. SARAH JOHNSON',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onPrimaryFixed),
                    ),
                    Text(
                      'Auto-saving active • Encrypted clinical note',
                      style: TextStyle(fontSize: 11, color: ClinicalColors.onPrimaryFixedVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Chief Complaint & Symptoms
        _buildClinicalSection(
          title: 'Chief Complaint & Symptoms',
          icon: Icons.personal_injury,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _chiefComplaintController,
                maxLines: 3,
                style: const TextStyle(fontSize: 13, height: 1.4),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ClinicalColors.surfaceContainerLow,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    '+ Chest Tightness',
                    '+ Palpitations',
                    '+ Fatigue',
                    '+ Dizziness',
                  ].map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(tag),
                        onPressed: () => _appendSymptomTag(tag),
                        backgroundColor: ClinicalColors.surfaceContainerLow,
                        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Physical Exam & Observations
        _buildClinicalSection(
          title: 'Clinical Observations & Physical Exam',
          icon: Icons.favorite,
          child: TextField(
            controller: _observationsController,
            maxLines: 3,
            style: const TextStyle(fontSize: 13, height: 1.4),
            decoration: InputDecoration(
              filled: true,
              fillColor: ClinicalColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Assessment & Diagnosis
        _buildClinicalSection(
          title: 'Assessment & Clinical Diagnosis',
          icon: Icons.assignment,
          child: TextField(
            controller: _diagnosisController,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: ClinicalColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ClinicalColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ICD-10',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Doctor Progress Notes
        _buildClinicalSection(
          title: 'Doctor Clinical Progress Notes',
          icon: Icons.psychology,
          child: TextField(
            controller: _doctorNotesController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13, height: 1.4),
            decoration: InputDecoration(
              filled: true,
              fillColor: ClinicalColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Prescription & Orders
        _buildClinicalSection(
          title: 'Prescription & Medication Plan',
          icon: Icons.medication,
          child: Column(
            children: [
              ..._medications.map((med) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ClinicalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 8, color: ClinicalColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(med['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(med['instruction']!, style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant)),
                            const SizedBox(height: 2),
                            Text(med['details']!, style: const TextStyle(fontSize: 10, color: ClinicalColors.outline)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('E-Prescription formularies opened')),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Medication / Lab Order'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Recommended Follow-up
        _buildClinicalSection(
          title: 'Recommended Follow-Up',
          icon: Icons.calendar_month,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: ClinicalColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Follow-up in $_selectedFollowup',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const Icon(Icons.event, size: 18, color: ClinicalColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['2 Weeks', '4 Weeks', '3 Months', 'PRN'].map((dur) {
                  final isSelected = _selectedFollowup == dur;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () => setState(() => _selectedFollowup = dur),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? ClinicalColors.primary : ClinicalColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              dur,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : ClinicalColors.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryVaultView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ClinicalColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.inventory_2, color: ClinicalColors.secondary, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ARCHIVED EHR MEDICAL RECORDS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalColors.onSurfaceVariant)),
                    Text('Synchronized with St. Jude Cardiology Network', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Past encounters list
        _buildHistoryItem('Oct 02, 2026', 'Routine Follow-up & Medication Titration', 'Dr. Sarah Johnson', 'Stable vitals. Lisinopril dose confirmed.'),
        _buildHistoryItem('Sep 15, 2026', 'Baseline Resting Electrocardiogram (ECG)', 'Dr. Sarah Johnson', 'Normal sinus rhythm. No acute ischemia.'),
        _buildHistoryItem('Aug 01, 2026', 'Initial Cardiology Referral Assessment', 'Dr. Michael Chen', 'Mild exertional palpitations noted.'),
      ],
    );
  }

  Widget _buildHistoryItem(String date, String title, String doctor, String notes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalColors.primary)),
              const Text('Encounter Completed', style: TextStyle(fontSize: 10, color: ClinicalColors.tertiary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(doctor, style: const TextStyle(fontSize: 11, color: ClinicalColors.outline)),
          const SizedBox(height: 6),
          Text(notes, style: const TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildClinicalSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: ClinicalColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ClinicalColors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Laboratory diagnostic order sheet opened')),
                        );
                      },
                      icon: const Icon(Icons.biotech, size: 18),
                      label: const Text('Order Labs'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _finalizeEncounter,
                      icon: _isSaving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Icon(_isSigned ? Icons.task_alt : Icons.check_circle, size: 18),
                      label: Text(
                        _isSaving
                            ? 'Signing...'
                            : _isSigned
                                ? 'Encounter Signed'
                                : 'Save Consultation',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSigned ? ClinicalColors.tertiary : ClinicalColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Finalize & Digitally Sign Encounter (Dr. S. Johnson)',
                style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
