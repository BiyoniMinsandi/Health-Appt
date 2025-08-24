import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/health_data_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/wellness_provider.dart';
import 'services/database_helper.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/patient/dashboard_screen.dart';
import 'screens/doctor/doctor_dashboard.dart';
import 'screens/hospital/hospital_dashboard.dart';
import 'screens/caregiver/caregiver_dashboard.dart';
import 'screens/common/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HealthDataProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => WellnessProvider()),
      ],
      child: MaterialApp(
        title: 'Health Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal[600],
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            primary: Colors.teal[600]!,
            secondary: Colors.green[600]!,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.teal[600],
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.teal[600],
            foregroundColor: Colors.white,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/patient-dashboard': (context) => PatientDashboard(),
          '/doctor-dashboard': (context) => DoctorDashboard(),
          '/hospital-dashboard': (context) => HospitalDashboard(),
          '/caregiver-dashboard': (context) => CaregiverDashboard(),
          '/settings': (context) => SettingsScreen(),
        },
      ),
    );
  }
}