import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterproject/main.dart';
import 'package:flutterproject/screens/home_dashboard_screen.dart';
import 'package:flutterproject/screens/search_results_screen.dart';
import 'package:flutterproject/screens/complete_payment_screen.dart';
import 'package:flutterproject/screens/appointment_confirmed_screen.dart';
import 'package:flutterproject/screens/booking_cancelled_screen.dart';
import 'package:flutterproject/screens/payment_failed_screen.dart';
import 'package:flutterproject/screens/my_appointments_screen.dart';
import 'package:flutterproject/screens/select_date_time_screen.dart';
import 'package:flutterproject/screens/patient_profile_screen.dart';
import 'package:flutterproject/screens/doctor_dashboard_screen.dart';
import 'package:flutterproject/screens/medical_records_screen.dart';
import 'package:flutterproject/screens/manage_availability_screen.dart';
import 'package:flutterproject/screens/patient_details_consultation_screen.dart';
import 'package:flutterproject/screens/admin_dashboard_screen.dart';
import 'package:flutterproject/screens/admin_doctors_management_screen.dart';
import 'package:flutterproject/screens/reports_analytics_screen.dart';
import 'package:flutterproject/screens/sign_up_screen.dart';
import 'package:flutterproject/screens/forgot_password_screen.dart';
import 'package:flutterproject/screens/settings_screen.dart';
import 'package:flutterproject/screens/appointment_details_screen.dart';
import 'package:flutterproject/screens/personal_information_screen.dart';
import 'package:flutterproject/widgets/filter_bottom_sheet.dart';
import 'package:flutterproject/widgets/doctor_search_empty_state.dart';
import 'package:flutterproject/widgets/main_scaffold.dart';
import 'package:flutterproject/data/mock_healthcare_data.dart';
import 'package:flutterproject/models/appointment.dart';

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return _MockHttpClientRequest();
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  static final _imageBytes = <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
    0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
    0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
    0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
    0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
    0x60, 0x82,
  ];

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _imageBytes.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_imageBytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  testWidgets('CareFlow App Smoke Test: Boots and shows LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthcareAppointmentApp());
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('Login validation and demo login flow works', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthcareAppointmentApp());
    await tester.pumpAndSettle();

    // Tap Login button directly without filling credentials
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Validation errors should appear
    expect(find.text('Please enter your email or phone number'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    // Enter valid demo credentials
    await tester.enterText(find.byType(TextFormField).first, 'patient@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.pumpAndSettle();

    // Sign In with valid demo credentials
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Should navigate to Home Dashboard Screen
    expect(find.byType(HomeDashboardScreen), findsOneWidget);
    expect(find.text('Good morning, Alex 👋'), findsOneWidget);
  });

  testWidgets('Full flow: Login to Home Dashboard with Bottom Navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainScaffold(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Tab 0: Home
    expect(find.text('CareFlow'), findsOneWidget);
    expect(find.text('Good morning, Alex 👋'), findsOneWidget);
    expect(find.text('Next Appointment'), findsOneWidget);

    // Switch to Explore tab
    final exploreTab = find.text('Explore');
    await tester.tap(exploreTab);
    await tester.pumpAndSettle();

    expect(find.text('Medical Specialties'), findsOneWidget);
    expect(find.text('General Physician'), findsOneWidget);
    expect(find.text('Cardiologist'), findsOneWidget);

    // Switch to Appointments tab
    final appointmentsTab = find.text('Appointments');
    await tester.tap(appointmentsTab);
    await tester.pumpAndSettle();

    expect(find.text('My Appointments'), findsOneWidget);
    expect(find.text('Dr. Sarah Johnson'), findsAtLeast(1));

    // Switch to Alerts tab (NotificationsScreen)
    final alertsTab = find.text('Alerts');
    await tester.tap(alertsTab);
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Appointment Reminder'), findsOneWidget);

    // Switch to Profile tab (PatientProfileScreen)
    final profileTab = find.text('Profile');
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    expect(find.text('Alex Kumar'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
  });

  testWidgets('Search flow: Find a Doctor, Filter Sheet, and Empty State', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SearchResultsScreen(initialSpecialty: 'General Physician'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchResultsScreen), findsOneWidget);
    expect(find.text('Search Doctors'), findsOneWidget);

    // Search something nonexistent to test Empty State
    final searchInput = find.byType(TextField);
    await tester.enterText(searchInput, 'NonExistentDoctorName123');
    await tester.pumpAndSettle();

    expect(find.byType(DoctorSearchEmptyState), findsOneWidget);
    expect(find.text('No matching doctors found'), findsOneWidget);
    expect(find.text('Reset All Filters'), findsOneWidget);

    // Clear Search
    await tester.tap(find.text('Reset All Filters'));
    await tester.pumpAndSettle();
    expect(find.byType(DoctorSearchEmptyState), findsNothing);

    // Open Filter Sheet
    final filterButton = find.byIcon(Icons.tune);
    await tester.tap(filterButton);
    await tester.pumpAndSettle();

    expect(find.byType(FilterBottomSheet), findsOneWidget);
    expect(find.text('Filter & Refine'), findsOneWidget);
    expect(find.text('Available Today'), findsAtLeast(1));
  });

  testWidgets('Phase 2 Flow: Complete Payment Screen renders and accepts coupons', (WidgetTester tester) async {
    final drSarah = MockHealthcareData.getDoctors().first;

    await tester.pumpWidget(
      MaterialApp(
        home: CompletePaymentScreen(
          doctor: drSarah,
          selectedDate: 'Oct 14, 2026',
          selectedDayName: 'Wed',
          selectedTimeSlot: '10:30 AM',
          consultationType: ConsultationType.inPerson,
          consultationFee: 500.0,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Appointment Checkout'), findsOneWidget);
    expect(find.text('Dr. Sarah Johnson'), findsAtLeast(1));
    expect(find.text('UPI / Instant Pay'), findsOneWidget);

    // Enter coupon
    final promoField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'Try CARE10 or FIRSTCARE',
    );
    await tester.enterText(promoField, 'CARE10');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(find.text('Voucher CARE10 applied! ₹50.00 saved.'), findsOneWidget);
  });

  testWidgets('Phase 2 Flow: Appointment Confirmed Screen displays ticket pass and copy action', (WidgetTester tester) async {
    final appointment = AppointmentRepository.appointments.first;

    await tester.pumpWidget(
      MaterialApp(
        home: AppointmentConfirmedScreen(
          appointment: appointment,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BOOKING CONFIRMED'), findsOneWidget);
    expect(find.text("You're All Set!"), findsOneWidget);
    expect(find.text('APPOINTMENT PASS'), findsOneWidget);
    expect(find.text('Reference ID'), findsOneWidget);
    expect(find.text('Add to Calendar'), findsOneWidget);
    expect(find.text('View in My Appointments'), findsOneWidget);
  });

  testWidgets('Phase 2 Flow: Booking Cancelled Screen displays slot released info', (WidgetTester tester) async {
    final drSarah = MockHealthcareData.getDoctors().first;

    await tester.pumpWidget(
      MaterialApp(
        home: BookingCancelledScreen(
          doctor: drSarah,
          selectedDate: 'Oct 14, 2026',
          selectedTimeSlot: '10:30 AM',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Booking Not Completed'), findsOneWidget);
    expect(find.text('₹0.00 (No Charge)'), findsOneWidget);
    expect(find.text('Want to try booking again?'), findsOneWidget);
    expect(find.text('Retry Booking'), findsOneWidget);
  });

  testWidgets('Phase 2 Flow: Payment Failed Screen displays error code and countdown', (WidgetTester tester) async {
    final drSarah = MockHealthcareData.getDoctors().first;

    await tester.pumpWidget(
      MaterialApp(
        home: PaymentFailedScreen(
          doctor: drSarah,
          selectedDate: 'Oct 14, 2026',
          selectedDayName: 'Wed',
          selectedTimeSlot: '10:30 AM',
          consultationType: ConsultationType.inPerson,
          totalAmount: 500.0,
          paymentMethod: 'UPI (Google Pay)',
          errorCode: 'ERR_BANK_TIMEOUT',
          errorMessage: 'Bank server did not respond in time',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Payment Unsuccessful'), findsOneWidget);
    expect(find.text('ERR_BANK_TIMEOUT'), findsOneWidget);
    expect(find.text('Bank server did not respond in time'), findsOneWidget);
    expect(find.text('Slot Reserved For'), findsOneWidget);
    expect(find.text('Retry Payment (₹500)'), findsOneWidget);
  });

  testWidgets('Phase 2 Flow: My Appointments Screen shows upcoming, completed, and cancelled tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyAppointmentsScreen(showBackButton: true),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Appointments'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);

    // Switch to Completed tab
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Dr. Sarah Johnson'), findsNothing); // Sarah is upcoming

    // Switch to Cancelled tab
    await tester.tap(find.text('Cancelled'));
    await tester.pumpAndSettle();
    expect(find.text('Book Another Slot'), findsWidgets);
  });

  testWidgets('Phase 3 Flow: Booking Funnel - Select Date Time Screen loads slots', (WidgetTester tester) async {
    final drSarah = MockHealthcareData.getDoctors().first;

    await tester.pumpWidget(
      MaterialApp(
        home: SelectDateTimeScreen(doctor: drSarah),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Date & Time'), findsAtLeast(1));
    expect(find.text('Step 2 of 5'), findsOneWidget);
    expect(find.textContaining('Morning Slots'), findsOneWidget);
    expect(find.text('Next: Select Type'), findsOneWidget);
  });

  testWidgets('Phase 3 Flow: Patient Profile Screen displays hero and clinical records', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PatientProfileScreen(showBackButton: true),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Patient Profile'), findsOneWidget);
    expect(find.text('Alex Kumar'), findsOneWidget);
    expect(find.text('Comprehensive Health Plan'), findsOneWidget);
    expect(find.text('Switch to Doctor Portal'), findsOneWidget);
    expect(find.text('Hospital Admin Console'), findsOneWidget);
  });

  testWidgets('Phase 3 Flow: Doctor Dashboard Screen shows metrics and schedule', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DoctorDashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Good morning, Dr. Sarah 👋'), findsOneWidget);
    expect(find.text("Today's Visits"), findsOneWidget);
    expect(find.text('Next 7 Days'), findsOneWidget);
    expect(find.text("Today's Schedule"), findsOneWidget);
  });

  testWidgets('Phase 4 Flow: Medical Records Screen displays vault allocation & documents', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MedicalRecordsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Medical Records'), findsOneWidget);
    expect(find.text('HIPAA COMPLIANT'), findsOneWidget);
    expect(find.text('Cloud Vault Allocation'), findsOneWidget);
    expect(find.text('Echocardiogram_Report_Final.pdf'), findsOneWidget);
    expect(find.text('Upload'), findsOneWidget);
  });

  testWidgets('Phase 4 Flow: Manage Availability Screen renders schedule tools', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ManageAvailabilityScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Manage Availability'), findsOneWidget);
    expect(find.text('Dr. Sarah Johnson'), findsOneWidget);
    expect(find.text('Working Days'), findsOneWidget);
    expect(find.text('Daily Practice Hours'), findsOneWidget);
    expect(find.text('Save Availability Schedule'), findsOneWidget);
  });

  testWidgets('Phase 4 Flow: Patient Details Consultation Screen renders clinical encounter', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PatientDetailsConsultationScreen(
          patientName: 'Alex Kumar',
          mrn: '#PT-9420',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clinical Consultation'), findsOneWidget);
    expect(find.text('Alex Kumar'), findsOneWidget);
    expect(find.text('Active Note'), findsOneWidget);
    expect(find.text('Save Consultation'), findsOneWidget);
  });

  testWidgets('Phase 4 Flow: Admin Dashboard renders executive KPIs & telemetry', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AdminDashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Admin Console'), findsOneWidget);
    expect(find.text('Executive KPIs'), findsOneWidget);
    expect(find.text('Total Patients'), findsOneWidget);
    expect(find.text('Staff Doctors'), findsOneWidget);
  });

  testWidgets('Phase 4 Flow: Admin Doctors Management displays credentialing roster', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AdminDoctorsManagementScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Doctor Directory & Credentials'), findsOneWidget);
    expect(find.text('Active Registry'), findsOneWidget);
    expect(find.text('Dr. Emily Stone, MD'), findsOneWidget);
    expect(find.text('Dr. Sarah Johnson, MD'), findsOneWidget);
  });

  testWidgets('Phase 4 Flow: Reports and Analytics renders fulfillment & financial stats', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReportsAnalyticsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reports & Analytics'), findsOneWidget);
    expect(find.text('Appointment Fulfillment'), findsOneWidget);
    expect(find.text('Financial Performance'), findsOneWidget);
    expect(find.text('Department Performance Ranking'), findsOneWidget);
  });

  testWidgets('Authentication Flow: SignUpScreen renders inputs and terms', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignUpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsAtLeast(1));
    expect(find.text('Create your account'), findsOneWidget);
  });

  testWidgets('Authentication Flow: ForgotPasswordScreen renders options and submission', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });

  testWidgets('Patient Flow: AppointmentDetailsScreen renders appointment ticket and CTAs', (WidgetTester tester) async {
    final appointment = AppointmentRepository.appointments.first;

    await tester.pumpWidget(
      MaterialApp(
        home: AppointmentDetailsScreen(
          appointment: appointment,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Appointment Details'), findsOneWidget);
    expect(find.text('Dr. Sarah Johnson'), findsAtLeast(1));
    expect(find.text('Appointment Confirmed'), findsOneWidget);
    expect(find.text('ID: ${appointment.id}'), findsOneWidget);
  });

  testWidgets('Patient Flow: PersonalInformationScreen renders patient info fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PersonalInformationScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Alex Morgan'), findsAtLeast(1));
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('Patient Flow: SettingsScreen renders user card, sections and logout modal', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('App Settings'), findsOneWidget);
    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.text('PREFERENCES & DISPLAY'), findsOneWidget);
    expect(find.text('Push Notifications'), findsOneWidget);
  });
}
