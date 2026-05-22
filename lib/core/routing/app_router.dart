import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Auth
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state.dart';

// Main tabs
import '../../features/home/home_screen.dart';
import '../../features/skills/presentation/screens/skills_list_screen.dart';
import '../../features/groups/presentation/screens/group_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

// Home
import '../../features/home/search_screen.dart';

// Groups sub-screens
import '../../features/groups/presentation/screens/create_group_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../features/groups/presentation/screens/my_groups_screen.dart';
import '../../features/groups/presentation/screens/empty_groups_screen.dart';
import '../../features/groups/presentation/screens/empty_my_groups_screen.dart';
import '../../features/groups/presentation/screens/groups_error_screen.dart';
import '../../features/groups/models/group_model.dart';

// Profile sub-screens
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';

// Skills sub-screens
import '../../features/skills/presentation/screens/skill_detail_screen.dart';
import '../../features/skills/presentation/screens/create_skill_screen.dart';
import '../../features/skills/presentation/screens/my_skills_screen.dart';
import '../../features/skills/presentation/screens/skill_requests_screen.dart';
import '../../features/skills/presentation/screens/skills_error_screen.dart';
import '../../features/skills/presentation/screens/success_confirmation_screen.dart';
import '../../features/skills/models/skill_model.dart';

// Shell
import 'main_shell.dart';

// ── Route path constants ──────────────────────────────────────────────────────

class AppRoutes {
  // Auth (public)
  static const login = '/';
  static const signup = '/signup';
  static const forgot = '/forgot';

  // Protected tabs
  static const home = '/home';
  static const skills = '/skills';
  static const groups = '/groups';
  static const profile = '/profile';

  // Search
  static const search = '/search';

  // Groups sub
  static const groupDetail = '/groups/detail';
  static const myGroups = '/groups/my-groups';
  static const createGroup = '/groups/create';
  static const emptyGroups = '/groups/empty';
  static const emptyMyGroups = '/groups/my-groups/empty';
  static const groupsError = '/groups/error';

  // Profile sub
  static const changePassword = '/change-password';
  static const editProfile = '/edit-profile';

  // Skills sub
  static const skillDetail = '/skills/detail';
  static const createSkill = '/skills/create';
  static const mySkills = '/skills/my-skills';
  static const skillRequests = '/skills/requests';
  static const skillsError = '/skills/error';
  static const successConfirmation = '/skills/success-confirmation';
}

// ── Public routes (no login required) ────────────────────────────────────────

const _publicRoutes = [AppRoutes.login, AppRoutes.signup, AppRoutes.forgot];

// ── Router provider ───────────────────────────────────────────────────────────

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Riverpod provider — rebuilds router when auth state changes.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    refreshListenable: _AuthStateListenable(ref),

    // ── REDIRECT LOGIC (authorization) ──────────────────────────────────
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublic = _publicRoutes.contains(location);

      // Still loading session — show nothing (splash)
      if (authState is AuthLoading) return null;

      final isLoggedIn = authState is AuthAuthenticated;

      // Guest trying to access protected route → send to login
      if (!isLoggedIn && !isPublic) return AppRoutes.login;

      // Logged-in user visiting auth pages → send to home
      if (isLoggedIn && isPublic) return AppRoutes.home;

      return null; // no redirect
    },

    routes: [
      // ── Auth routes (no bottom nav) ────────────────────────────────────
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.signup, builder: (_, _) => const SignupScreen()),
      GoRoute(
        path: AppRoutes.forgot,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),

      // ── Shell: tabs with bottom nav (PROTECTED) ────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, _, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: AppRoutes.skills,
            builder: (_, _) => const SkillsListScreen(),
          ),
          GoRoute(
            path: AppRoutes.groups,
            builder: (_, _) => const GroupListScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Search ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.search,
        builder: (_, state) {
          final query = state.extra as String? ?? '';
          return SearchResultsScreen(initialQuery: query);
        },
      ),

      // ── Groups sub-screens ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.groupDetail,
        builder: (_, state) {
          final group = state.extra as GroupModel;
          return GroupDetailScreen(group: group);
        },
      ),
      GoRoute(
        path: AppRoutes.myGroups,
        builder: (_, _) => const MyGroupsScreen(),
      ),
      GoRoute(
        path: AppRoutes.createGroup,
        builder: (_, _) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: AppRoutes.emptyGroups,
        builder: (_, _) => const EmptyGroupsScreen(),
      ),
      GoRoute(
        path: AppRoutes.emptyMyGroups,
        builder: (_, _) => const EmptyMyGroupsScreen(),
      ),
      GoRoute(
        path: AppRoutes.groupsError,
        builder: (_, _) => const GroupsErrorScreen(),
      ),

      // ── Profile sub-screens ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, _) => const EditProfileScreen(),
      ),

      // ── Skills sub-screens ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.skillDetail,
        builder: (_, state) {
          final skill = state.extra as SkillModel;
          return SkillDetailScreen(skill: skill);
        },
      ),
      GoRoute(
        path: AppRoutes.createSkill,
        builder: (_, _) => const CreateSkillScreen(),
      ),
      GoRoute(
        path: AppRoutes.mySkills,
        builder: (_, _) => const MySkillsScreen(),
      ),
      GoRoute(
        path: AppRoutes.skillRequests,
        builder: (_, _) => const SkillRequestsScreen(),
      ),
      GoRoute(
        path: AppRoutes.skillsError,
        builder: (_, _) => const SkillsErrorScreen(),
      ),
      GoRoute(
        path: AppRoutes.successConfirmation,
        builder: (_, _) => const SuccessConfirmationScreen(),
      ),
    ],
  );
});

// ── Convenience — used by screens that just need appRouter ───────────────────

/// For backward compat: screens can still call `appRouter` directly.
/// But MyApp now uses [appRouterProvider] for reactive rebuilds.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (_, _) => const LoginScreen())],
);

// ── Helper: makes GoRouter react to Riverpod auth changes ────────────────────

class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}
