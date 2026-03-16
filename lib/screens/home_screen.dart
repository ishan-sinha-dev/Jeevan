import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Jeevan"),
        actions: [

          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 10),

          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {

              if (value == "logout") {

                Navigator.popUntil(context, (route) => route.isFirst);

              }

            },
            itemBuilder: (context) => [

              const PopupMenuItem(
                value: "logout",
                child: Text("Logout"),
              ),

            ],
          ),

          const SizedBox(width: 10),

        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Hi, Ishan 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text(
                    "Analytics",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text("Reports scanned: 0"),
                  Text("Upcoming reminders: 0"),

                ],
              ),
            ),

          ],
        ),
      ),

    );
  }
}