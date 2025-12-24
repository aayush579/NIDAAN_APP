import 'package:flutter/material.dart';
import '../presentation/report_issue_screen/report_issue_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/map_view_screen/map_view_screen.dart';
import '../presentation/issue_detail_screen/issue_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String reportIssue = '/report-issue-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String login = '/login-screen';
  static const String profile = '/profile-screen';
  static const String mapView = '/map-view-screen';
  static const String issueDetail = '/issue-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    reportIssue: (context) => const ReportIssueScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    login: (context) => const LoginScreen(),
    profile: (context) => const ProfileScreen(),
    mapView: (context) => const MapViewScreen(),
    issueDetail: (context) => const IssueDetailScreen(),
    // TODO: Add your other routes here
  };
}