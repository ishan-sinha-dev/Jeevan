import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'report_screen.dart';
import 'reminder_screen.dart';
import 'profile_screen.dart';
import 'scan_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ReportsScreen(),
    RemindersScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(

  body: _screens[_selectedIndex],

  floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.green,
    onPressed: () {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScanScreen(),
        ),
      );

    },
    child: const Icon(
      Icons.camera_alt,
      size: 30,
    ),
  ),

  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

  bottomNavigationBar: BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

Tooltip(
  message: "Home",
  child: IconButton(
    icon: const Icon(Icons.home),
    onPressed: () {
      setState(() {
        _selectedIndex = 0;
      });
    },
  ),
),

Tooltip(
  message: "Reports",
  child: IconButton(
    icon: const Icon(Icons.check_circle),
    onPressed: () {
      setState(() {
        _selectedIndex = 1;
      });
    },
  ),
),
        const SizedBox(width: 40),
Tooltip(
  message: "Reminders",
  child: IconButton(
    icon: const Icon(Icons.alarm),
    onPressed: () {
      setState(() {
        _selectedIndex = 2;
      });
    },
  ),
),
Tooltip(
  message: "Profile",
  child: IconButton(
    icon: const Icon(Icons.person),
    onPressed: () {
      setState(() {
        _selectedIndex = 3;
      });
    },
  ),
),
      ],
    ),
  ),
);
  }
} 