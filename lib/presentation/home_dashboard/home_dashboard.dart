import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/category_card.dart';
import './widgets/community_overview_card.dart';
import './widgets/empty_state_widget.dart';
import './widgets/recent_activity_item.dart';
import './widgets/user_stats_card.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isOffline = false;
  int _currentBottomNavIndex = 0;

  // Mock data for user statistics
  final Map<String, dynamic> _userStats = {
    'totalReports': 24,
    'resolvedIssues': 18,
    'successRate': 75,
    'impactScore': 892,
  };

  // Mock data for community overview
  final Map<String, dynamic> _communityStats = {
    'totalIssues': 15847,
    'resolutionRate': 68,
    'trendingCategory': 'Roads',
    'monthlyIncrease': 234,
  };

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 1,
      'name': 'Roads',
      'description': 'Potholes, traffic signals',
      'count': 156,
      'percentage': 32,
    },
    {
      'id': 2,
      'name': 'Water',
      'description': 'Leaks, supply issues',
      'count': 89,
      'percentage': 18,
    },
    {
      'id': 3,
      'name': 'Electricity',
      'description': 'Power outages, streetlights',
      'count': 124,
      'percentage': 25,
    },
    {
      'id': 4,
      'name': 'Waste',
      'description': 'Collection, disposal',
      'count': 67,
      'percentage': 14,
    },
    {
      'id': 5,
      'name': 'Public Safety',
      'description': 'Security, emergency',
      'count': 43,
      'percentage': 9,
    },
    {
      'id': 6,
      'name': 'Healthcare',
      'description': 'Medical facilities',
      'count': 21,
      'percentage': 4,
    },
  ];

  // Mock data for recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'id': 1,
      'userName': 'Sarah Johnson',
      'userAvatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'title': 'Pothole on Main Street causing traffic delays',
      'description':
          'Large pothole near the intersection is causing vehicles to swerve dangerously. Multiple cars have been damaged.',
      'status': 'In Progress',
      'category': 'Roads',
      'location': 'Main Street, Downtown',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'imageUrl':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
    },
    {
      'id': 2,
      'userName': 'Michael Chen',
      'userAvatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'title': 'Water leak flooding residential area',
      'description':
          'Burst water main is flooding the street and affecting multiple households in the neighborhood.',
      'status': 'Resolved',
      'category': 'Water',
      'location': 'Oak Avenue, Residential',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'imageUrl':
          'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400&h=300&fit=crop',
    },
    {
      'id': 3,
      'userName': 'Emily Rodriguez',
      'userAvatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      'title': 'Broken streetlight creating safety hazard',
      'description':
          'Streetlight has been out for over a week, making the area unsafe for pedestrians at night.',
      'status': 'Under Review',
      'category': 'Electricity',
      'location': 'Park Street, Near School',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'imageUrl':
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=300&fit=crop',
    },
    {
      'id': 4,
      'userName': 'David Thompson',
      'userAvatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'title': 'Overflowing garbage bins attracting pests',
      'description':
          'Garbage collection has been delayed and bins are overflowing, creating unsanitary conditions.',
      'status': 'Pending',
      'category': 'Waste',
      'location': 'Elm Street, Commercial',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'imageUrl':
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400&h=300&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _isOffline = false;
    });
  }

  Future<void> _refreshData() async {
    await _loadDashboardData();
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);
  }

  void _showUserStatsDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStatsBottomSheet(),
    );
  }

  Widget _buildStatsBottomSheet() {
    final theme = Theme.of(context);

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detailed Statistics',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                _buildDetailedStatItem(
                    'Total Reports Submitted', '24', 'All-time contributions'),
                _buildDetailedStatItem('Successfully Resolved', '18',
                    'Issues marked as completed'),
                _buildDetailedStatItem(
                    'Success Rate', '75%', 'Resolution percentage'),
                _buildDetailedStatItem('Community Impact Score', '892',
                    'Based on engagement and resolution'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStatItem(
      String title, String value, String description) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.home(context),
      body: _isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: theme.colorScheme.primary,
              child: _recentActivities.isEmpty
                  ? _buildEmptyState()
                  : _buildDashboardContent(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/report-issue-screen'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        child: CustomIconWidget(
          iconName: 'camera_alt',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
            strokeWidth: 3,
          ),
          SizedBox(height: 3.h),
          Text(
            'Loading dashboard...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 80.h,
        child: EmptyStateWidget(
          title: 'Welcome to NIDAAN',
          subtitle:
              'Start making a difference in your community by reporting your first civic issue. Your voice matters!',
          buttonText: 'Report Your First Issue',
          onButtonPressed: () =>
              Navigator.pushNamed(context, '/report-issue-screen'),
          illustrationUrl:
              'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400&h=300&fit=crop',
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offline indicator
          _isOffline
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.only(bottom: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.dark)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.dark)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'wifi_off',
                        color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.dark),
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'You\'re offline. Showing cached data.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.getWarningColor(
                                theme.brightness == Brightness.dark),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),

          // User Statistics Card
          UserStatsCard(
            userStats: _userStats,
            onTap: _showUserStatsDetails,
          ),
          SizedBox(height: 3.h),

          // Community Overview Card
          CommunityOverviewCard(
            communityStats: _communityStats,
            onTap: () => Navigator.pushNamed(context, '/map-view-screen'),
          ),
          SizedBox(height: 4.h),

          // Categories Section
          Row(
            children: [
              Text(
                'Issue Categories',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/map-view-screen'),
                child: Text(
                  'View All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Categories Horizontal List
          SizedBox(
            height: 18.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                return CategoryCard(
                  category: _categories[index],
                  onTap: () {
                    // Navigate to filtered issue list
                    Navigator.pushNamed(context, '/map-view-screen');
                  },
                );
              },
            ),
          ),
          SizedBox(height: 4.h),

          // Recent Activity Section
          Row(
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_recentActivities.length} updates',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Recent Activities List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentActivities.length,
            itemBuilder: (context, index) {
              return RecentActivityItem(
                activity: _recentActivities[index],
                onViewDetails: () {
                  Navigator.pushNamed(
                    context,
                    '/issue-detail-screen',
                    arguments: _recentActivities[index]['id'],
                  );
                },
                onShare: () {
                  // Handle share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Issue shared successfully!'),
                      backgroundColor: AppTheme.getSuccessColor(
                          theme.brightness == Brightness.dark),
                    ),
                  );
                },
                onFollow: () {
                  // Handle follow functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You will receive updates for this issue'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 10.h), // Extra space for FAB
        ],
      ),
    );
  }
}
