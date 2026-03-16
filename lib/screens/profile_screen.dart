import 'package:flutter/material.dart';
import '../widgets/global_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(
        title: "Profile"
      ),
      body: const Center(
        child: Text(
          "Profile Module",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}