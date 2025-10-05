import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart'; // <-- import alarm package
import 'pages/home_page.dart';
import 'services/panchang_service.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async initialization
  await Alarm.init(); // Initialize Alarm system before app starts
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Panchang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.pumpkin,
        scaffoldBackgroundColor: AppColors.bgLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.pumpkin,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: HomePage(service: PanchangService()),
    );
  }
}
