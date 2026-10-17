import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'booking_summary_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Doctor doctor;
  final String selectedDate;
  final String selectedDayName;
  final String selectedTimeSlot;
  final ConsultationType consultationType;
  final double consultationFee;

  const PatientDetailsScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedDayName,
    required this.selectedTimeSlot,
    required this.consultationType,
    required this.consultationFee,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  bool _isForMyself = true;
  final TextEditingController _nameController = TextEditingController(text: 'Alex Morgan');
  final TextEditingController _phoneController = TextEditingController(text: '+1 (555) 234-5678');
  final TextEditingController _ageController = TextEditingController(text: '30');
  final TextEditingController _notesController = TextEditingController();

  String _gender = 'Male';
  String _selectedReason = 'Routine Cardiovascular Evaluation';
  String? _attachedFileName;

  final List<String> _availableReasons = [
    'Routine Cardiovascular Evaluation',
    'Follow-up Visit & Prescription Review',
    'Chest Discomfort & Tightness',
    'High Blood Pressure Monitoring',
    'Second Opinion Consultation',
  ];

  final List<String> _allSymptoms = [
    'Chest tightness',
    'Palpitations',
    'Shortness of breath',
    'High BP',
    'Occasional dizziness',
    'Fatigue',
  ];

  final Set<String> _selectedSymptoms = {'Chest tightness', 'High BP'};

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onNext() {
    final patientName = _nameController.text.trim().isEmpty ? 'Alex Morgan' : _nameController.text.trim();
    final patientPhone = _phoneController.text.trim().isEmpty ? '+1 (555) 234-5678' : _phoneController.text.trim();
    final patientAge = int.tryParse(_ageController.text.trim()) ?? 30;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSummaryScreen(
          doctor: widget.doctor,
          selectedDate: widget.selectedDate,
          selectedDayName: widget.selectedDayName,
          selectedTimeSlot: widget.selectedTimeSlot,
          consultationType: widget.consultationType,
          consultationFee: widget.consultationFee,
          patientName: patientName,
          patientPhone: patientPhone,
          patientAge: patientAge,
          patientGender: _gender,
          reasonForVisit: _selectedReason,
          symptoms: _selectedSymptoms.toList(),
          notes: _notesController.text.trim(),
          attachedFile: _attachedFileName,
        ),
      ),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Patient Details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            Text(
              'Step 4 of 5',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ClinicalColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: ClinicalColors.onSurfaceVariant),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stepper
            _buildStepper(),
            const SizedBox(height: 14),

            // Doctor Snapshot Banner
            _buildContextBanner(),
            const SizedBox(height: 18),

            // Who is this appointment for?
            const Text(
              'Who is this appointment for?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ClinicalColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildForWhomOption(
                    title: 'Myself',
                    subtitle: 'Alex Morgan',
                    isSelected: _isForMyself,
                    onTap: () {
                      setState(() {
                        _isForMyself = true;
                        _nameController.text = 'Alex Morgan';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildForWhomOption(
                    title: 'Someone Else',
                    subtitle: 'Family / Dependent',
                    isSelected: !_isForMyself,
                    onTap: () {
                      setState(() {
                        _isForMyself = false;
                        _nameController.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Patient Basic Info Fields
            _buildPatientFields(),
            const SizedBox(height: 20),

            // Reason for Visit Section
            _buildReasonSection(),
            const SizedBox(height: 20),

            // Symptoms Checklist
            _buildSymptomsSection(),
            const SizedBox(height: 20),

            // Attachment Section
            _buildAttachmentSection(),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildStepper() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: ClinicalColors.tertiaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: ClinicalColors.onTertiaryFixed),
                ),
                const SizedBox(width: 4),
                const Text('Doctor', style: TextStyle(fontSize: 11, color: ClinicalColors.tertiary)),
              ],
            ),
            Container(width: 10, height: 2, color: ClinicalColors.tertiaryFixed),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: ClinicalColors.tertiaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: ClinicalColors.onTertiaryFixed),
                ),
                const SizedBox(width: 4),
                const Text('Date/Time', style: TextStyle(fontSize: 11, color: ClinicalColors.tertiary)),
              ],
            ),
            Container(width: 10, height: 2, color: ClinicalColors.tertiaryFixed),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: ClinicalColors.tertiaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: ClinicalColors.onTertiaryFixed),
                ),
                const SizedBox(width: 4),
                const Text('Type', style: TextStyle(fontSize: 11, color: ClinicalColors.tertiary)),
              ],
            ),
            Container(width: 10, height: 2, color: ClinicalColors.primaryFixed),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: ClinicalColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('4', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Details', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalColors.primary)),
              ],
            ),
            Container(width: 10, height: 2, color: ClinicalColors.surfaceContainerHighest),
            Text('Confirm', style: TextStyle(fontSize: 11, color: ClinicalColors.outline.withValues(alpha: 0.8))),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: 0.80,
            minHeight: 4,
            backgroundColor: ClinicalColors.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(ClinicalColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildContextBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.doctor.imageUrl),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.doctor.name,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: ClinicalColors.primaryFixed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.consultationType.label.split(' ').first,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: ClinicalColors.onPrimaryFixed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.selectedDate} · ${widget.selectedTimeSlot}',
                    style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.verified_user, color: ClinicalColors.tertiary, size: 20),
        ],
      ),
    );
  }

  Widget _buildForWhomOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? ClinicalColors.surfaceContainerHigh
              : ClinicalColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ClinicalColors.primary : ClinicalColors.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? ClinicalColors.primary : ClinicalColors.outline,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Information',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Name
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter patient full legal name',
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: ClinicalColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.person, size: 20, color: ClinicalColors.primary),
            ),
          ),
          const SizedBox(height: 12),

          // Phone
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1 (555) 000-0000',
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: ClinicalColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.phone, size: 20, color: ClinicalColors.primary),
            ),
          ),
          const SizedBox(height: 12),

          // Age and Gender Row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    hintText: 'e.g. 30',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    filled: true,
                    fillColor: ClinicalColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Row(
                  children: ['Male', 'Female', 'Other'].map((g) {
                    final isSelected = _gender == g;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _gender = g);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ClinicalColors.primary
                                : ClinicalColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              g,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : ClinicalColors.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reason for Consultation',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _selectedReason,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: ClinicalColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: _availableReasons
                .map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(r, style: const TextStyle(fontSize: 13)),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedReason = val);
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Additional Notes or Symptoms (Optional)',
              hintText: 'Describe how you feel or questions for the doctor...',
              hintStyle: const TextStyle(fontSize: 12, color: ClinicalColors.outline),
              contentPadding: const EdgeInsets.all(12),
              filled: true,
              fillColor: ClinicalColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Observed Symptoms',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allSymptoms.map((s) {
            final isSelected = _selectedSymptoms.contains(s);
            return FilterChip(
              label: Text(s),
              selected: isSelected,
              selectedColor: ClinicalColors.primaryFixed,
              backgroundColor: ClinicalColors.surfaceContainerLow,
              checkmarkColor: ClinicalColors.primary,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ClinicalColors.primary : ClinicalColors.onSurface,
              ),
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedSymptoms.add(s);
                  } else {
                    _selectedSymptoms.remove(s);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: ClinicalColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.attach_file, color: ClinicalColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _attachedFileName ?? 'Attach Reports / ECG (Optional)',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'PDF, PNG, JPG up to 10MB',
                    style: TextStyle(fontSize: 11, color: ClinicalColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _attachedFileName = 'Cardiac_Report_Sep2026.pdf';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attached: Cardiac_Report_Sep2026.pdf'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              _attachedFileName != null ? 'Change' : 'Upload',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ClinicalColors.surfaceContainerLowest,
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
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _onNext,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text(
              'Next: Review & Confirm',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
