/// App-wide string and config constants.
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Campus Collaboration';
  static const String appVersion = '1.0.0';

  // Database
  static const String dbName = 'campus_app.db';
  static const int dbVersion = 1;

  // Session
  static const String sessionTable = 'session';
  static const String usersTable = 'users';
  static const String skillsTable = 'skills';
  static const String skillRequestsTable = 'skill_requests';
  static const String groupsTable = 'study_groups';
  static const String groupMembersTable = 'group_members';

  // Skill categories
  static const List<String> skillCategories = [
    'Programming',
    'Language',
    'Design',
    'Math',
    'Science',
    'Music',
    'Other',
  ];

  // Group roles
  static const String roleAdmin = 'admin';
  static const String roleMember = 'member';

  // Request statuses
  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';

  // Validation
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
  static const int maxDescriptionLength = 500;
  static const int maxTitleLength = 100;

  // UI
  static const int shimmerCardCount = 4;
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration mockApiDelay = Duration(milliseconds: 600);
}
