import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_sizes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: AppSizes.p24),

            const CustomTextField(
              label: "Email",
              hintText: "Enter your email",
              prefixIcon: Icons.email,
            ),

            const CustomTextField(
              label: "Password",
              hintText: "Enter your password",
              prefixIcon: Icons.lock,
              isPassword: true,
            ),

            const SizedBox(height: AppSizes.p16),

            CustomButton(text: "Login", onPressed: () => context.go('/home')),

            const SizedBox(height: AppSizes.p8),

            CustomButton(
              text: "Create Account",
              isPrimary: false,
              onPressed: () => context.go('/signup'),
            ),

            TextButton(
              onPressed: () => context.go('/forgot'),
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
