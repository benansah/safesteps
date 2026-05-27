import 'package:flutter/widgets.dart';
import '../screens/splash_screen.dart';
import '../screens/language_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/student_profile_screen.dart';
import '../screens/parent_dashboard_screen.dart';
import '../screens/teacher_dashboard_screen.dart';
import '../screens/teacher_analytics_screen.dart';
import '../screens/record_detail_screen.dart';
import '../screens/game_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/completion_screen.dart';
import '../screens/help_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String parentDashboard = '/parent-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String teacherAnalytics = '/teacher-analytics';
  static const String recordDetail = '/record-detail';
  static const String game = '/game';
  static const String feedback = '/feedback';
  static const String completion = '/completion';
  static const String help = '/help';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
      language: (_) => const LanguageScreen(),
      login: (_) => const LoginScreen(),
      home: (_) => const HomeScreen(),
      profile: (_) => const StudentProfileScreen(),
      parentDashboard: (_) => const ParentDashboardScreen(),
      teacherDashboard: (_) => const TeacherDashboardScreen(),
      teacherAnalytics: (_) => const TeacherAnalyticsScreen(),
      recordDetail: (_) => const RecordDetailScreen(),
      game: (_) => const GameScreen(),
      feedback: (_) => const FeedbackScreen(),
      completion: (_) => const CompletionScreen(),
      help: (_) => const HelpScreen(),
    };
  }
}
