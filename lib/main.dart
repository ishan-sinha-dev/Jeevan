import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:jeevan/screens/auth/login_screen.dart';
import 'utils/app_theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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