import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/skills/presentation/screens/skills_list_screen.dart';
import '../../features/groups/presentation/screens/group_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

import '../../features/groups/presentation/screens/create_group_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../features/groups/presentation/screens/my_groups_screen.dart';
import '../../features/groups/presentation/screens/empty_groups_screen.dart';
import '../../features/groups/presentation/screens/empty_my_groups_screen.dart';
import '../../features/groups/models/group_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/forgot',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
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




    // New routes to add inside routes for groups: [ ... ]:
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


  ],
);
