import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),

      // 🔥 REPLACE BODY WITH THIS
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome Home"),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => context.go('/skills'),
              child: const Text("Go to Skills"),
            ),

            ElevatedButton(
              onPressed: () => context.go('/groups'),
              child: const Text("Go to Groups"),
            ),

            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text("Go to Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
