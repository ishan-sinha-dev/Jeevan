import 'package:flutter/material.dart';
import 'package:jeevan/screens/auth/login_screen.dart';
import 'screens/main_navigation.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const JeevanApp());
}

class JeevanApp extends StatelessWidget {
  const JeevanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jeevan",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}