import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_bottom_nav.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/skills')) return 1;
    if (location.startsWith('/groups')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // /home
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _locationToIndex(location),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/skills');
              break;
            case 2:
              context.go('/groups');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}
