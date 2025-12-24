import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievements_section_widget.dart';
import './widgets/logout_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_list_widget.dart';
import './widgets/statistics_cards_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Profile tab active
  bool _isDarkMode = false;
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": "user_001",
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "joinDate": "March 2024",
    "isVerified": true,
  };

  // Mock statistics data
  final Map<String, dynamic> _statisticsData = {
    "totalIssues": 24,
    "resolutionRate": 87,
    "impactScore": 156,
    "badgesEarned": 8,
  };

  // Mock achievements data
  final List<Map<String, dynamic>> _achievements = [
    {
      "id": "reporter_badge",
      "title": "Active Reporter",
      "description": "Reported 10+ issues",
      "icon": "report_problem",
      "isEarned": true,
      "progress": 1.0,
    },
    {
      "id": "community_hero",
      "title": "Community Hero",
      "description": "High impact score",
      "icon": "star",
      "isEarned": true,
      "progress": 1.0,
    },
    {
      "id": "problem_solver",
      "title": "Problem Solver",
      "description": "85% resolution rate",
      "icon": "lightbulb",
      "isEarned": false,
      "progress": 0.75,
    },
    {
      "id": "civic_champion",
      "title": "Civic Champion",
      "description": "50+ issues reported",
      "icon": "emoji_events",
      "isEarned": false,
      "progress": 0.48,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshProfile() async {
    await _loadUserData();
  }

  void _handleAvatarTap() {
    _showAvatarOptions();
  }

  void _showAvatarOptions() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Change Profile Picture",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AvatarOption(
                    icon: 'camera_alt',
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _captureFromCamera();
                    },
                  ),
                  _AvatarOption(
                    icon: 'photo_library',
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _selectFromGallery();
                    },
                  ),
                  _AvatarOption(
                    icon: 'delete',
                    label: 'Remove',
                    onTap: () {
                      Navigator.pop(context);
                      _removeAvatar();
                    },
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  void _captureFromCamera() {
    // Implement camera capture
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Camera capture functionality")),
    );
  }

  void _selectFromGallery() {
    // Implement gallery selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gallery selection functionality")),
    );
  }

  void _removeAvatar() {
    setState(() {
      _userData["avatar"] = null;
    });
  }

  void _handleEditProfile() {
    // Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edit profile functionality")),
    );
  }

  void _handleStatisticCardTap(String key) {
    String message = "";
    switch (key) {
      case "total_issues":
        message = "View all your reported issues";
        break;
      case "resolution_rate":
        message = "View resolution details";
        break;
      case "impact_score":
        message = "View community impact breakdown";
        break;
      case "badges_earned":
        message = "View all earned badges";
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleAchievementTap(Map<String, dynamic> achievement) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: achievement["icon"] as String,
                size: 6.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  achievement["title"] as String,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                achievement["description"] as String,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              if (!(achievement["isEarned"] as bool)) ...[
                Text(
                  "Progress",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: achievement["progress"] as double,
                  backgroundColor:
                      theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "${((achievement["progress"] as double) * 100).toInt()}% Complete",
                  style: theme.textTheme.bodySmall,
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor(_isDarkMode)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    "Achievement Earned!",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getSuccessColor(_isDarkMode),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _handleSettingTap(String key) {
    String route = "";
    String message = "";

    switch (key) {
      case "account_info":
        message = "Account information settings";
        break;
      case "notifications":
        message = "Notification preferences";
        break;
      case "privacy":
        message = "Privacy settings";
        break;
      case "language":
        message = "Language selection";
        break;
      case "help":
        message = "Help and support";
        break;
    }

    if (route.isNotEmpty) {
      Navigator.pushNamed(context, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _handleThemeToggle(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    // Implement theme switching logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isDarkMode ? "Switched to dark mode" : "Switched to light mode"),
      ),
    );
  }

  void _handleLogout() {
    // Clear user data and navigate to login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login-screen',
      (route) => false,
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.profile(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    ProfileHeaderWidget(
                      userData: _userData,
                      onEditPressed: _handleEditProfile,
                      onAvatarTap: _handleAvatarTap,
                    ),
                    SizedBox(height: 4.h),

                    // Statistics Cards
                    StatisticsCardsWidget(
                      statisticsData: _statisticsData,
                      onCardTap: _handleStatisticCardTap,
                    ),
                    SizedBox(height: 4.h),

                    // Achievements Section
                    AchievementsSectionWidget(
                      achievements: _achievements,
                      onAchievementTap: _handleAchievementTap,
                    ),
                    SizedBox(height: 4.h),

                    // Settings List
                    SettingsListWidget(
                      onSettingTap: _handleSettingTap,
                      isDarkMode: _isDarkMode,
                      onThemeToggle: _handleThemeToggle,
                    ),
                    SizedBox(height: 4.h),

                    // Logout Section
                    LogoutSectionWidget(
                      onLogoutPressed: _handleLogout,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _AvatarOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              size: 6.w,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
