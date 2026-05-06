import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_sizes.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),

      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Reset Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: AppSizes.p24),

            const CustomTextField(
              label: "Email",
              hintText: "Enter your email",
              prefixIcon: Icons.email,
            ),

            const SizedBox(height: AppSizes.p16),

            CustomButton(
              text: "Send Reset Link",
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
