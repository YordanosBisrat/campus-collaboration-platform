import 'package:flutter/material.dart';

class CreateSkillScreen extends StatelessWidget {
  const CreateSkillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Skill")),
      body: const Center(child: Text("Create Skill Screen")),
    );
  }
}
