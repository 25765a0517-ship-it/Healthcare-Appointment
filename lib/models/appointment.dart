import 'doctor.dart';

enum ConsultationType {
  inPerson,
  video,
  phone;

  String get label {
    switch (this) {
      case ConsultationType.inPerson:
        return 'In-Person Consultation';
      case ConsultationType.video:
        return 'Video Consultation';
      case ConsultationType.phone:
        return 'Phone Consultation';
    }
  }
}

enum AppointmentStatus {
  upcoming,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case AppointmentStatus.upcoming:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum PaymentOptionType {
  upi,
  card,
  netbanking,
  clinic;

  String get label {
    switch (this) {
      case PaymentOptionType.upi:
        return 'UPI / Instant Pay';
      case PaymentOptionType.card:
        return 'Credit / Debit Card';
      case PaymentOptionType.netbanking:
        return 'Net Banking';
      case PaymentOptionType.clinic:
        return 'Pay at Clinic';
    }
  }
}

class Appointment {
  final String id;
  final Doctor doctor;
  final String patientName;
  final String patientPhone;
  final int patientAge;
  final String patientGender;
  final String reasonForVisit;
  final List<String> symptoms;
  final DateTime date;
  final String dateDisplay;
  final String dayDisplay;
  final String timeSlot;
  final ConsultationType consultationType;
  final String locationOrRoom;
  AppointmentStatus status;
  final double consultationFee;
  final double bookingFee;
  final double totalAmount;
  final String paymentMethod;
  final bool isPaid;
  final String? cancellationReason;
  final String countdownLabel;

  Appointment({
    required this.id,
    required this.doctor,
    this.patientName = 'Alex Morgan',
    this.patientPhone = '+1 (555) 234-5678',
    this.patientAge = 30,
    this.patientGender = 'Male',
    this.reasonForVisit = 'Cardiovascular routine evaluation and BP checkup',
    this.symptoms = const ['Chest tightness', 'Occasional Palpitations'],
    required this.date,
    required this.dateDisplay,
    required this.dayDisplay,
    required this.timeSlot,
    required this.consultationType,
    required this.locationOrRoom,
    this.status = AppointmentStatus.upcoming,
    this.consultationFee = 500.0,
    this.bookingFee = 0.0,
    this.totalAmount = 500.0,
    this.paymentMethod = 'UPI · Google Pay',
    this.isPaid = true,
    this.cancellationReason,
    this.countdownLabel = 'In 45 mins',
  });

  Appointment copyWith({
    String? id,
    Doctor? doctor,
    String? patientName,
    String? patientPhone,
    int? patientAge,
    String? patientGender,
    String? reasonForVisit,
    List<String>? symptoms,
    DateTime? date,
    String? dateDisplay,
    String? dayDisplay,
    String? timeSlot,
    ConsultationType? consultationType,
    String? locationOrRoom,
    AppointmentStatus? status,
    double? consultationFee,
    double? bookingFee,
    double? totalAmount,
    String? paymentMethod,
    bool? isPaid,
    String? cancellationReason,
    String? countdownLabel,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      symptoms: symptoms ?? this.symptoms,
      date: date ?? this.date,
      dateDisplay: dateDisplay ?? this.dateDisplay,
      dayDisplay: dayDisplay ?? this.dayDisplay,
      timeSlot: timeSlot ?? this.timeSlot,
      consultationType: consultationType ?? this.consultationType,
      locationOrRoom: locationOrRoom ?? this.locationOrRoom,
      status: status ?? this.status,
      consultationFee: consultationFee ?? this.consultationFee,
      bookingFee: bookingFee ?? this.bookingFee,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      countdownLabel: countdownLabel ?? this.countdownLabel,
    );
  }
}
