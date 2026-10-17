import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';

class MockHealthcareData {
  static final List<Specialty> specialties = [
    const Specialty(
      name: 'General Physician',
      icon: Icons.medical_services_outlined,
      doctorsCount: 124,
      category: 'primary',
      isLive: true,
      color: ClinicalColors.primary,
    ),
    const Specialty(
      name: 'Cardiologist',
      icon: Icons.favorite_outline,
      doctorsCount: 24,
      category: 'primary',
      isLive: true,
      color: ClinicalColors.error,
    ),
    const Specialty(
      name: 'Dermatologist',
      icon: Icons.health_and_safety_outlined,
      doctorsCount: 48,
      category: 'primary',
      isLive: true,
      color: ClinicalColors.tertiary,
    ),
    const Specialty(
      name: 'Dentist',
      icon: Icons.clean_hands_outlined,
      doctorsCount: 36,
      category: 'primary',
      isLive: true,
      color: ClinicalColors.secondary,
    ),
    const Specialty(
      name: 'Orthopedic',
      icon: Icons.accessibility_new_outlined,
      doctorsCount: 19,
      category: 'surgical',
      isLive: true,
      color: ClinicalColors.secondary,
    ),
    const Specialty(
      name: 'Pediatrician',
      icon: Icons.child_care_outlined,
      doctorsCount: 52,
      category: 'pediatric',
      isLive: true,
      color: ClinicalColors.primary,
    ),
    const Specialty(
      name: 'Neurologist',
      icon: Icons.psychology_outlined,
      doctorsCount: 15,
      category: 'surgical',
      isLive: true,
      color: ClinicalColors.primaryContainer,
    ),
    const Specialty(
      name: 'Ophthalmologist',
      icon: Icons.visibility_outlined,
      doctorsCount: 28,
      category: 'primary',
      isLive: true,
      color: ClinicalColors.tertiary,
    ),
    const Specialty(
      name: 'ENT Specialist',
      icon: Icons.hearing_outlined,
      doctorsCount: 22,
      category: 'surgical',
      isLive: true,
      color: ClinicalColors.secondary,
    ),
    const Specialty(
      name: 'Family Medicine',
      icon: Icons.family_restroom_outlined,
      doctorsCount: 31,
      category: 'pediatric',
      isLive: true,
      color: ClinicalColors.primary,
    ),
  ];

  static List<Doctor> getDoctors() {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialty: 'Cardiologist',
        hospital: 'St. Jude Heart Clinic · Floor 3',
        rating: 4.9,
        reviewsCount: 142,
        experienceYears: 12,
        distanceKm: 1.0,
        consultationFee: 85,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCegCTeCu1tm4mpFIBBswPHIySUNBNPVMbnhWixIpYKld5Wqo3TTcl152ztq7biSfYTSE2M7XIzg0_OghW5N_mk7KIy1fAlBJWqeoaSPICg0ikFkWH2THwcYaa722lxRSXlOSaf2HPzT_6PrpEFs2nhBH-v6E8YG6roS4w3UVAdvr_hMteEqz8lcMJVLJa2rk5BVnHo9e0EMClsdH4f9CJ5AzNoM-VVWAKX86NNREHr',
        availableToday: true,
        isVideoVisitAvailable: true,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Marcus Vance, MD',
        specialty: 'Senior Cardiologist',
        hospital: 'St. Jude Hospital',
        rating: 4.9,
        reviewsCount: 184,
        experienceYears: 14,
        distanceKm: 1.2,
        consultationFee: 80,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCQ7p9qH3i1xVvylamVcHfesC01sq44sDGTwg1GP5vpjQpI0zq8TKiLz9cr-snN5n-wazfP-DBEKB4JGl_oHzxBQl9Yo6jbR5m_CAUPbaBqKLZVoPd21ngkr5g4emmbTQT1NHLj2O2NOamISAXbQC4uBf_pfIRXFh4ZTJYo4BX4-xMIQumUzbpSp1XTL8FzhWtbwveEifRlsFmCFsWMjkQ648SW2w0cA3ut7U7pxDyn',
        availableToday: true,
        isVideoVisitAvailable: true,
      ),
      Doctor(
        id: '3',
        name: 'Dr. Marcus Chen',
        specialty: 'Dermatologist',
        hospital: 'Downtown Care Center',
        rating: 4.9,
        reviewsCount: 128,
        experienceYears: 8,
        distanceKm: 2.4,
        consultationFee: 75,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBuUsBsoCwxIQ_nN2a76I-mNsrb9NF01nTxRyiPDeCa4kpYNwMRnVfIFY7ybB1_4IRWcsOUt8pnYUl1PtLWTOJZxRv3L1fo-3dQwmnHE3uTtezmxxVE16-lmY_jt6IhnOrJQoMAbAo6JzEtF8wd92Qf8e72CFKOFpfWTozBMfes5VrUswMGMrQ3vo0MGCgau6xrsbiUrr__eAa2yvNki6-m2Z7AnYXcGbLBIcessRs8',
        availableToday: true,
        isVideoVisitAvailable: false,
      ),
      Doctor(
        id: '4',
        name: 'Dr. Elena Vance',
        specialty: 'Pediatrician',
        hospital: 'Children Health Pavilion',
        rating: 4.8,
        reviewsCount: 210,
        experienceYears: 10,
        distanceKm: 3.1,
        consultationFee: 90,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAef6N9lXogkhejfDow7bRAVmErf4dDs86kY_iqE6LYQQnr1vbAT-PYYvLsi1fdX9m522Acc50nVtnk4E6S_75pfzNTgAu7vk3GpQ37lqyaDczv3c5TeaKt5F5SpuxbVOQ1RjA8_UXCyN_KiR5hPbICu9NNiN9m6mVggp67wr6R80KbVjwqI-Q-l0MudW7aa6-YBJk2LnqE6XJ0NUxKMWQVjkLfrOpW9UJDW95QVRgd',
        availableToday: true,
        isVideoVisitAvailable: true,
      ),
      Doctor(
        id: '5',
        name: 'Dr. Elena Rostova, MD',
        specialty: 'Cardiologist',
        hospital: 'Metro Cardiac Wing',
        rating: 4.9,
        reviewsCount: 184,
        experienceYears: 12,
        distanceKm: 1.8,
        consultationFee: 95,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAOpAPyWhnmjQqIQWZCkGjM-6YWVanKn_g8oCmlX_ylHz4ozSlelzDt-Y30wpOn_HM0QzGf36X1PEKW-uu_Lo4u0uKota3p8eZWp2d4DHjhl_FwAGqd40os_ZkSttIR7pqYCU0bxhE7Szb3SHpY3_bg7NMs5-jfngXLY0YsPSy_EvSNjon4i0BJYHGNBpD69NxtU-NA0t-H749kperXj0RkzH2y___l0GT5yHLAd9Yf',
        availableToday: true,
        isVideoVisitAvailable: true,
      ),
      Doctor(
        id: '6',
        name: 'Dr. Olivia Patel',
        specialty: 'General Physician',
        hospital: 'Community Care Clinic',
        rating: 4.8,
        reviewsCount: 160,
        experienceYears: 7,
        distanceKm: 0.8,
        consultationFee: 45,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB9Y8LEouVctgWv19iXvQkyis6_A4lyQBaxfK5tZNxOd0s_U69_yup_1uA7r4SSCM0HVY2p-ih1ZHNj8PraJbcLGjQk3IvS6O69AFOt63MWmtRUaCeoh4HvEvGjDLdrjLrOn2V6Cv2piNrmYpjYOBUyhsa__AisgXtdZsQ2jwFzU4BObUh2DeTqxab_DjC0zbu9yr5pqGJMwR1B0UMnWuNA79qy-VSDptv2PnJqz7q6',
        availableToday: true,
        isVideoVisitAvailable: true,
      ),
      Doctor(
        id: '7',
        name: 'Dr. Michael Torres',
        specialty: 'Orthopedic',
        hospital: 'Sports Medicine Institute',
        rating: 4.7,
        reviewsCount: 95,
        experienceYears: 15,
        distanceKm: 4.5,
        consultationFee: 120,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCutnzflPO2O1lDL8xMmjvvJGcae2J2YI7QlEKxSk7YHidBsZBxTca2S2F4jlc-ZZUlZnIq5i_x1Kr2uyO_6uzxz4aMY2nAyiUCPyFbylOo7FsG9XfRQUNvq_f10sJaLYnv0jw3nFzd43-j5vg-AK8Dd5N7f075IrumUnStESBie-UuXUmV_8rkYEDYRGWukAJh8pH2RoDADh2C8EM_GK7zyvRyZUfooFeAwKNYRlYn',
        availableToday: false,
        isVideoVisitAvailable: false,
      ),
    ];
  }
}

class AppointmentRepository {
  static final Doctor _drSarah = MockHealthcareData.getDoctors()[0];
  static final Doctor _drChen = MockHealthcareData.getDoctors()[2];
  static final Doctor _drVance = MockHealthcareData.getDoctors()[3];
  static final Doctor _drRostova = MockHealthcareData.getDoctors()[4];

  static final ValueNotifier<List<Appointment>> appointmentsNotifier = ValueNotifier<List<Appointment>>([
    Appointment(
      id: '#CF-849204',
      doctor: _drSarah,
      patientName: 'Alex Morgan',
      date: DateTime.now(),
      dateDisplay: 'Today, Oct 13',
      dayDisplay: 'Tuesday',
      timeSlot: '10:30 AM',
      consultationType: ConsultationType.inPerson,
      locationOrRoom: 'In-Person Consultation · Room 304, Bldg B',
      status: AppointmentStatus.upcoming,
      consultationFee: 500,
      bookingFee: 0,
      totalAmount: 500,
      paymentMethod: 'UPI · Google Pay',
      isPaid: true,
      countdownLabel: 'In 45 mins',
    ),
    Appointment(
      id: '#CF-849205',
      doctor: _drChen,
      patientName: 'Alex Morgan',
      date: DateTime.now().add(const Duration(days: 6)),
      dateDisplay: 'Mon, Oct 19',
      dayDisplay: 'Monday',
      timeSlot: '02:00 PM',
      consultationType: ConsultationType.video,
      locationOrRoom: 'Video Consultation · Telehealth Room',
      status: AppointmentStatus.upcoming,
      consultationFee: 450,
      bookingFee: 0,
      totalAmount: 450,
      paymentMethod: 'UPI · Instant Pay',
      isPaid: true,
      countdownLabel: 'In 6 days',
    ),
    Appointment(
      id: '#CF-719302',
      doctor: _drVance,
      patientName: 'Alex Morgan',
      date: DateTime.now().subtract(const Duration(days: 15)),
      dateDisplay: 'Sep 28, 2024',
      dayDisplay: 'Saturday',
      timeSlot: '11:00 AM',
      consultationType: ConsultationType.inPerson,
      locationOrRoom: 'In-Person Consultation · General Checkup',
      status: AppointmentStatus.completed,
      consultationFee: 500,
      bookingFee: 0,
      totalAmount: 500,
      paymentMethod: 'Credit / Debit Card',
      isPaid: true,
    ),
    Appointment(
      id: '#CF-619284',
      doctor: _drRostova,
      patientName: 'Alex Morgan',
      date: DateTime.now().subtract(const Duration(days: 60)),
      dateDisplay: 'Aug 15, 2024',
      dayDisplay: 'Thursday',
      timeSlot: '04:30 PM',
      consultationType: ConsultationType.video,
      locationOrRoom: 'Video Consultation · Telehealth Room',
      status: AppointmentStatus.cancelled,
      consultationFee: 500,
      bookingFee: 0,
      totalAmount: 500,
      paymentMethod: 'UPI · Google Pay',
      isPaid: false,
      cancellationReason: 'Cancelled by patient (Schedule conflict)',
    ),
  ]);

  static List<Appointment> get appointments => appointmentsNotifier.value;

  static List<Appointment> get upcoming =>
      appointmentsNotifier.value.where((a) => a.status == AppointmentStatus.upcoming).toList();

  static List<Appointment> get completed =>
      appointmentsNotifier.value.where((a) => a.status == AppointmentStatus.completed).toList();

  static List<Appointment> get cancelled =>
      appointmentsNotifier.value.where((a) => a.status == AppointmentStatus.cancelled).toList();

  static void addAppointment(Appointment app) {
    final current = List<Appointment>.from(appointmentsNotifier.value);
    current.insert(0, app);
    appointmentsNotifier.value = current;
  }

  static void cancelAppointment(String id, String reason) {
    final current = List<Appointment>.from(appointmentsNotifier.value);
    final index = current.indexWhere((a) => a.id == id);
    if (index != -01 && index < current.length && index >= 0) {
      final updated = current[index].copyWith(
        status: AppointmentStatus.cancelled,
        cancellationReason: reason,
      );
      current[index] = updated;
      appointmentsNotifier.value = current;
    }
  }

  static void rescheduleAppointment(String id, String newDate, String newSlot) {
    final current = List<Appointment>.from(appointmentsNotifier.value);
    final index = current.indexWhere((a) => a.id == id);
    if (index >= 0) {
      final updated = current[index].copyWith(
        dateDisplay: newDate,
        timeSlot: newSlot,
      );
      current[index] = updated;
      appointmentsNotifier.value = current;
    }
  }
}
