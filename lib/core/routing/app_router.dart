import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';

// Main tabs
import '../../features/home/home_screen.dart';
import '../../features/skills/presentation/screens/skills_list_screen.dart';
import '../../features/groups/presentation/screens/group_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

// Home sub-screens
import '../../features/home/search_screen.dart';

// Groups and skills sub-screens
import '../../features/groups/presentation/screens/create_group_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../features/groups/presentation/screens/my_groups_screen.dart';
import '../../features/groups/presentation/screens/empty_groups_screen.dart';
import '../../features/groups/presentation/screens/empty_my_groups_screen.dart';
import '../../features/groups/presentation/screens/groups_error_screen.dart';
import '../../features/groups/models/group_model.dart';

import '../../features/profile/presentation/screens/change_password_screen.dart';

import '../../features/skills/presentation/screens/skill_detail_screen.dart';
import '../../features/skills/presentation/screens/create_skill_screen.dart';
import '../../features/skills/presentation/screens/my_skills_screen.dart';
import '../../features/skills/presentation/screens/skill_requests_screen.dart';
import '../../features/skills/presentation/screens/skills_error_screen.dart';
import '../../features/skills/models/skill_model.dart';
import '../../features/skills/presentation/screens/success_confirmation_screen.dart';
// Shell (bottom nav wrapper)
import 'main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Auth routes (no bottom nav)
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/forgot',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Shell: main tabs with bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/skills',
          builder: (context, state) => const SkillsListScreen(),
        ),
        GoRoute(
          path: '/groups',
          builder: (context, state) => const GroupListScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    //  Home sub-screens
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final query = state.extra as String? ?? '';
        return SearchResultsScreen(initialQuery: query);
      },
    ),

    // Groups and skills sub-screens
    GoRoute(
      path: '/groups/detail',
      builder: (context, state) {
        final group = state.extra as GroupModel;
        return GroupDetailScreen(group: group);
      },
    ),
    GoRoute(
      path: '/groups/my-groups',
      builder: (context, state) => const MyGroupsScreen(),
    ),
    GoRoute(
      path: '/groups/create',
      builder: (context, state) => const CreateGroupScreen(),
    ),
    GoRoute(
      path: '/groups/empty',
      builder: (context, state) => const EmptyGroupsScreen(),
    ),
    GoRoute(
      path: '/groups/my-groups/empty',
      builder: (context, state) => const EmptyMyGroupsScreen(),
    ),
    GoRoute(
      path: '/groups/error',
      builder: (context, state) => const GroupsErrorScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/skills/detail',
      builder: (context, state) {
        final skill = state.extra as SkillModel;
        return SkillDetailScreen(skill: skill);
      },
    ),
    GoRoute(
      path: '/skills/create',
      builder: (context, state) => const CreateSkillScreen(),
    ),
    GoRoute(
      path: '/skills/my-skills',
      builder: (context, state) => const MySkillsScreen(),
    ),
    GoRoute(
      path: '/skills/requests',
      builder: (context, state) => const SkillRequestsScreen(),
    ),
    GoRoute(
      path: '/skills/error',
      builder: (context, state) => const SkillsErrorScreen(),
    ),
    GoRoute(
      path: '/skills/success-confirmation',
      builder: (context, state) => const SuccessConfirmationScreen(),
    ),
  ],
);
