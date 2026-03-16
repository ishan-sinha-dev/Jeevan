import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import '../screens/auth/login_screen.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  const GlobalAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.green,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Avatar (LEFT)
          GestureDetector(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );

            },
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),

          // Title
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),

          // Logout button (RIGHT)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );

            },
          ),

        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}