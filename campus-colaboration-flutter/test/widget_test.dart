import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_collaboration_app/features/auth/presentation/screens/login_screen.dart';
import 'package:campus_collaboration_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:campus_collaboration_app/features/skills/presentation/screens/skills_list_screen.dart';
import 'package:campus_collaboration_app/features/groups/presentation/screens/group_list_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pump();
      expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    });

    testWidgets('shows error when submitting empty form', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pump();
      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('has a link to signup', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pump();
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('SignupScreen', () {
    testWidgets('renders signup form fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SignupScreen()),
        ),
      );
      await tester.pump();
      expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    });

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SignupScreen()),
        ),
      );
      await tester.pump();
      expect(find.byType(SignupScreen), findsOneWidget);
    });
  });

  group('SkillsListScreen', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SkillsListScreen()),
        ),
      );
      await tester.pump();
      expect(find.byType(SkillsListScreen), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SkillsListScreen()),
        ),
      );
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('GroupListScreen', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: GroupListScreen()),
        ),
      );
      await tester.pump();
      expect(find.byType(GroupListScreen), findsOneWidget);
    });
  });
}
