import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:jeevan/services/auth_services.dart';

class  RegisterScreen extends StatelessWidget {
 RegisterScreen({super.key});

  AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              decoration: InputDecoration(
                hintText: "Full Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController, 
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController, 
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextButton(
              onPressed: () async {

                final user = await authService.register(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                if (user != null) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account created successfully"),
                    ),
                  );

                  Navigator.pop(context); 

                } else {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Registration failed"),
                    ),
                  );

                }

              },
              child: const Text("Register"),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text("Already have an account? Login"),
            ),

          ],
        ),
      ),
    );
  }
}