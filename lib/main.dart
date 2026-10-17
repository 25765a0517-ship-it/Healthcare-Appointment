import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ClinicalColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const HealthcareAppointmentApp());
}

class HealthcareAppointmentApp extends StatelessWidget {
  const HealthcareAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinical Clarity Healthcare',
      debugShowCheckedModeBanner: false,
      theme: ClinicalTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}