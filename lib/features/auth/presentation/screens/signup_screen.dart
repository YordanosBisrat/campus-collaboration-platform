import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),

      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: AppSizes.p24),

            const CustomTextField(
              label: "Full Name",
              hintText: "Enter your name",
              prefixIcon: Icons.person,
            ),

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

            CustomButton(text: "Sign Up", onPressed: () => context.go('/home')),

            const SizedBox(height: AppSizes.p8),

            CustomButton(
              text: "Already have an account? Login",
              isPrimary: false,
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
