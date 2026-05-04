import 'package:flutter/material.dart';

class SkillsListScreen extends StatelessWidget {
  const SkillsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Skills")),
      body: const Center(child: Text("Skills List Screen")),
    );
  }
}
