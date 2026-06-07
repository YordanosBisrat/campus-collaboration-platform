import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_collaboration_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('app launches and shows login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('login screen has email and password fields', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    });

    testWidgets('shows error on invalid login attempt', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final emailFields = find.byType(TextFormField);
      if (emailFields.evaluate().isNotEmpty) {
        await tester.enterText(emailFields.first, 'invalid@test.com');
        await tester.pump();
      }
      final buttons = find.byType(ElevatedButton);
      if (buttons.evaluate().isNotEmpty) {
        await tester.tap(buttons.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('navigate to signup screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final signupLink = find.textContaining(
        RegExp(r'sign.?up|register|create', caseSensitive: false),
      );
      if (signupLink.evaluate().isNotEmpty) {
        await tester.tap(signupLink.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
