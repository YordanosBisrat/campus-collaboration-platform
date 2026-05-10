// lib/features/skills/models/skill_model.dart

import 'package:flutter/material.dart';

class SkillModel {
  final String id;
  final String title;
  final String category;
  final Color categoryColor;
  final Color categoryTextColor;
  final String description;
  final String ownerName;
  final String ownerYear;
  final String availability;
  final String prerequisites;

  const SkillModel({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.categoryTextColor,
    required this.description,
    required this.ownerName,
    required this.ownerYear,
    this.availability = '',
    this.prerequisites = '',
  });
}

class SkillMockData {
  static const List<SkillModel> allSkills = [
    SkillModel(
      id: '1',
      title: 'Java Tutoring',
      category: 'Programming',
      categoryColor: Color(0xFFD6EAF8),
      categoryTextColor: Color(0xFF2E86C1),
      description:
          'Offering help with core Java concepts, object-oriented programming, and debugging assignments.',
      ownerName: 'Solomon Elias',
      ownerYear: 'Computer Science, Year 3',
      availability:
          'Tuesdays and Thursdays: 4:00 PM – 6:00 PM\nWeekends: Flexible upon request',
      prerequisites: 'None',
    ),
    SkillModel(
      id: '2',
      title: 'Conversational Spanish',
      category: 'Language',
      categoryColor: Color(0xFFF9EBEA),
      categoryTextColor: Color(0xFFC0392B),
      description:
          'Native Spanish speaker looking to exchange language practice for help with introductory Calculus.',
      ownerName: 'Ruth Tewodros',
      ownerYear: 'Languages, Year 2',
      availability: 'Mondays and Wednesdays: 3:00 PM – 5:00 PM',
      prerequisites: 'None',
    ),
    SkillModel(
      id: '3',
      title: 'Figma UI/UX Design',
      category: 'Design',
      categoryColor: Color(0xFFF5EEF8),
      categoryTextColor: Color(0xFF8E44AD),
      description:
          'Can teach the basics of UI/UX design and prototyping using Figma for your app projects.',
      ownerName: 'Yordanos Bisrat',
      ownerYear: 'Software Engineering, Year 3',
      availability: 'Flexible – weekdays after 5:00 PM',
      prerequisites: 'None',
    ),
    SkillModel(
      id: '4',
      title: 'Calculus II Help',
      category: 'Math',
      categoryColor: Color(0xFFE8F8F5),
      categoryTextColor: Color(0xFF1E8449),
      description:
          'Available to explain integrals, series, and complex problem-solving strategies for Calculus.',
      ownerName: 'Henok Tewodros',
      ownerYear: 'Mathematics, Year 4',
      availability: 'Saturdays: 10:00 AM – 1:00 PM',
      prerequisites: 'Calculus I',
    ),
    SkillModel(
      id: '5',
      title: 'Advanced Java & Spring Boot Tutoring',
      category: 'Programming',
      categoryColor: Color(0xFFD6EAF8),
      categoryTextColor: Color(0xFF2E86C1),
      description:
          'I am offering tutoring sessions for Advanced Java and Spring Boot. I have 2 years of experience working as a backend developer intern and I can help you with your coursework, assignments, and understanding complex OOP concepts, REST APIs, and database integration.',
      ownerName: 'Bisrat Tewodros',
      ownerYear: 'Computer Science, Year 3',
      availability:
          'Tuesdays and Thursdays: 4:00 PM – 6:00 PM\nWeekends: Flexible upon request',
      prerequisites:
          'Basic understanding of Java syntax and core Object-Oriented Programming principles. Please have your IDE (IntelliJ or Eclipse) installed before our first session.',
    ),
  ];
}
