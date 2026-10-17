import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Alex Morgan');
  final TextEditingController _emailController = TextEditingController(text: 'alex@careflow.org');
  final TextEditingController _phoneController = TextEditingController(text: '+1 (555) 234-5678');
  final TextEditingController _emergencyContactController = TextEditingController(text: 'Sarah Morgan (Spouse) · +1 (555) 987-6543');

  String _gender = 'Male';
  String _dob = 'March 14, 1994';
  String _bloodGroup = 'O+ Positive';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personal information updated successfully!'),
        backgroundColor: ClinicalColors.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
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
        title: const Text(
          'Personal Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalColors.onSurface),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: ClinicalColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          children: [
            // Top Hero Avatar
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 46,
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBs1x2VtnTYL6TksFOr2PLth1AP2pdjParIQ10FtsrOzobI-TpGyRKynz-jzKnHAv-2x5tJkxlH7AiFFV4XRh6hGf_4xQNEeIwMTgj_6E1ap88gaoCJ5HNuRYCNVPSSA6cKTGpKfNFhK97tW0I1tMGVoBqxqj0x1dqCgEz7oQHbRFiBb-yJchP0KB21j7sJpP-PaCI-0kPnbZNN5bRikmKZzuQFtZcKZIR8vpRHO_bQ',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: ClinicalColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.photo_camera, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Alex Morgan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ClinicalColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user, size: 14, color: ClinicalColors.tertiary),
                        SizedBox(width: 4),
                        Text(
                          'VERIFIED IDENTITY • HIPAA PROTECTED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: ClinicalColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Card
            Container(
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
                    'Core Identification',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ClinicalColors.primary),
                  ),
                  const SizedBox(height: 14),

                  // Full Name
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Legal Name',
                      prefixIcon: const Icon(Icons.person, size: 20, color: ClinicalColors.primary),
                      suffixIcon: const Icon(Icons.check_circle, size: 18, color: ClinicalColors.tertiary),
                      filled: true,
                      fillColor: ClinicalColors.surfaceContainerLow,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date of Birth
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1994, 3, 14),
                        firstDate: DateTime(1930),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && mounted) {
                        setState(() => _dob = '${picked.day} ${_monthName(picked.month)}, ${picked.year}');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: ClinicalColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.cake, size: 20, color: ClinicalColors.primary),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Date of Birth', style: TextStyle(fontSize: 10, color: ClinicalColors.onSurfaceVariant)),
                                  Text('$_dob (30 yrs)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.calendar_month, size: 18, color: ClinicalColors.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Administrative Gender
                  const Text('Administrative Gender', style: TextStyle(fontSize: 12, color: ClinicalColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  Row(
                    children: ['Male', 'Female', 'Other'].map((g) {
                      final isSelected = _gender == g;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _gender = g),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? ClinicalColors.primary : ClinicalColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: 12,
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
                  const SizedBox(height: 14),

                  // Blood Group
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _bloodGroup,
                          decoration: InputDecoration(
                            labelText: 'Blood Group',
                            filled: true,
                            fillColor: ClinicalColors.surfaceContainerLow,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                          items: ['A+ Positive', 'B+ Positive', 'O+ Positive', 'AB+ Positive', 'O- Negative']
                              .map((bg) => DropdownMenuItem(value: bg, child: Text(bg, style: const TextStyle(fontSize: 12))))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _bloodGroup = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Primary Email Address',
                      prefixIcon: const Icon(Icons.email, size: 20, color: ClinicalColors.primary),
                      filled: true,
                      fillColor: ClinicalColors.surfaceContainerLow,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Phone
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Phone Number',
                      prefixIcon: const Icon(Icons.phone, size: 20, color: ClinicalColors.primary),
                      filled: true,
                      fillColor: ClinicalColors.surfaceContainerLow,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Emergency contact
                  TextField(
                    controller: _emergencyContactController,
                    decoration: InputDecoration(
                      labelText: 'Emergency Contact Person',
                      prefixIcon: const Icon(Icons.contact_phone, size: 20, color: ClinicalColors.primary),
                      filled: true,
                      fillColor: ClinicalColors.surfaceContainerLow,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ClinicalColors.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -3)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return m[month];
  }
}
