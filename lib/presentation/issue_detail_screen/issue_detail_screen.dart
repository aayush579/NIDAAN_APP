import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/comments_section.dart';
import './widgets/issue_description_section.dart';
import './widgets/issue_image_gallery.dart';
import './widgets/issue_metadata_card.dart';
import './widgets/location_section.dart';
import './widgets/reporter_info_section.dart';
import './widgets/status_timeline_section.dart';

class IssueDetailScreen extends StatefulWidget {
  const IssueDetailScreen({super.key});

  @override
  State<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends State<IssueDetailScreen> {
  bool _isFollowing = false;

  // Mock data for the issue
  final Map<String, dynamic> _issueData = {
    "id": "NIDAAN-2025-001234",
    "title": "Broken Street Light on Main Road Causing Safety Hazard",
    "description":
        """The street light pole near the bus stop on Main Road has been non-functional for over two weeks now. This is creating a serious safety hazard for pedestrians, especially during evening hours when visibility is poor.

The issue affects a busy intersection where many office workers and students pass daily. Several near-miss incidents have been reported due to poor visibility. The light pole appears to have electrical issues as there are no visible physical damages to the structure.

Local residents have been requesting immediate attention to this matter as it's affecting the safety of the entire neighborhood. The area becomes particularly dangerous during monsoon season when the roads are wet and slippery.""",
    "category": "Road & Transport",
    "priority": "High",
    "status": "In Progress",
    "submissionDate": DateTime.now().subtract(const Duration(days: 12)),
    "lastUpdated": DateTime.now().subtract(const Duration(hours: 6)),
  };

  final List<String> _imageUrls = [
    "https://images.pexels.com/photos/2219024/pexels-photo-2219024.jpeg?auto=compress&cs=tinysrgb&w=800",
    "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=800",
    "https://images.pexels.com/photos/2219064/pexels-photo-2219064.jpeg?auto=compress&cs=tinysrgb&w=800",
  ];

  final Map<String, dynamic> _locationData = {
    "address":
        "Main Road, Near Central Bus Stop, Downtown Area, Mumbai, Maharashtra 400001",
    "latitude": 19.0760,
    "longitude": 72.8777,
    "landmark": "Central Bus Stop",
    "area": "Downtown Area",
  };

  final Map<String, dynamic> _reporterData = {
    "isAnonymous": false,
    "name": "Rajesh Kumar",
    "avatar":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    "reputationScore": 4.3,
    "totalReports": 15,
    "resolvedReports": 12,
  };

  final List<Map<String, dynamic>> _timelineData = [
    {
      "status": "submitted",
      "timestamp": DateTime.now().subtract(const Duration(days: 12)),
      "description": "Issue reported by citizen with photo evidence",
      "authority": "",
    },
    {
      "status": "acknowledged",
      "timestamp": DateTime.now().subtract(const Duration(days: 10)),
      "description":
          "Issue acknowledged and assigned to Municipal Electricity Department",
      "authority": "Mumbai Municipal Corporation",
    },
    {
      "status": "under_review",
      "timestamp": DateTime.now().subtract(const Duration(days: 8)),
      "description":
          "Technical team conducted site inspection and confirmed the electrical fault",
      "authority": "Electrical Maintenance Division",
    },
    {
      "status": "in_progress",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "description":
          "Repair work has been initiated. Expected completion within 48 hours",
      "authority": "Field Operations Team",
    },
  ];

  final List<Map<String, dynamic>> _commentsData = [
    {
      "userName": "Priya Sharma",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "Thank you for reporting this! I walk through this area daily and it's been really dangerous. Hope it gets fixed soon.",
      "timestamp": DateTime.now().subtract(const Duration(days: 8)),
      "likes": 12,
      "dislikes": 0,
      "isLiked": false,
      "isDisliked": false,
    },
    {
      "userName": "Municipal Officer",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "We have received your complaint and our technical team will inspect the site within 24 hours. Thank you for bringing this to our attention.",
      "timestamp": DateTime.now().subtract(const Duration(days: 7)),
      "likes": 8,
      "dislikes": 1,
      "isLiked": true,
      "isDisliked": false,
    },
    {
      "userName": "Amit Patel",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "Same issue near my area too. When will the authorities take these safety concerns seriously?",
      "timestamp": DateTime.now().subtract(const Duration(days: 5)),
      "likes": 5,
      "dislikes": 2,
      "isLiked": false,
      "isDisliked": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Gallery
            IssueImageGallery(imageUrls: _imageUrls),

            SizedBox(height: 2.h),

            // Issue Metadata Card
            IssueMetadataCard(issueData: _issueData),

            // Location Section
            LocationSection(locationData: _locationData),

            // Issue Description
            IssueDescriptionSection(
                description: _issueData["description"] as String),

            // Reporter Information
            ReporterInfoSection(reporterData: _reporterData),

            // Status Timeline
            StatusTimelineSection(timelineData: _timelineData),

            // Comments Section
            CommentsSection(comments: _commentsData),

            // Bottom Padding for FAB
            SizedBox(height: 10.h),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios_new',
          size: 20,
          color:
              theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Issue #${_issueData["id"]?.toString().split('-').last ?? "001234"}',
        style: theme.appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'share',
            size: 24,
            color: theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
          ),
          onPressed: () => _shareIssue(context),
          tooltip: 'Share Issue',
        ),
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            size: 24,
            color: theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
          ),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'follow',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        _isFollowing ? 'notifications_off' : 'notifications',
                    size: 20,
                    color: theme.colorScheme.onSurface,
                  ),
                  SizedBox(width: 3.w),
                  Text(_isFollowing ? 'Unfollow Issue' : 'Follow Issue'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'flag',
                    size: 20,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Report Issue'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'bookmark',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'bookmark_border',
                    size: 20,
                    color: theme.colorScheme.onSurface,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Bookmark'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Follow/Unfollow FAB
        FloatingActionButton(
          heroTag: "follow",
          onPressed: () => _toggleFollow(context),
          backgroundColor: _isFollowing
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.lightTheme.primaryColor,
          foregroundColor:
              _isFollowing ? AppTheme.lightTheme.primaryColor : Colors.white,
          child: CustomIconWidget(
            iconName: _isFollowing ? 'notifications_off' : 'notifications',
            size: 24,
            color:
                _isFollowing ? AppTheme.lightTheme.primaryColor : Colors.white,
          ),
        ),

        SizedBox(height: 2.h),

        // Quick Actions FAB
        FloatingActionButton.extended(
          heroTag: "actions",
          onPressed: () => _showQuickActions(context),
          backgroundColor: AppTheme.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          icon: CustomIconWidget(
            iconName: 'more_horiz',
            size: 20,
            color: Colors.white,
          ),
          label: Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _shareIssue(BuildContext context) {
    final issueUrl = "https://nidaan.gov.in/issues/${_issueData["id"]}";
    final shareText = """
🚨 Civic Issue Alert - NIDAAN

Issue: ${_issueData["title"]}
ID: ${_issueData["id"]}
Status: ${_issueData["status"]}
Location: ${_locationData["address"]}

Help resolve this civic issue by viewing details:
$issueUrl

#NIDAAN #CivicIssues #CommunityAction
""";

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Issue details copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Share',
          onPressed: () {
            // This would typically open the system share sheet
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Opening share options...'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'follow':
        _toggleFollow(context);
        break;
      case 'report':
        _reportIssue(context);
        break;
      case 'bookmark':
        _bookmarkIssue(context);
        break;
    }
  }

  void _toggleFollow(BuildContext context) {
    setState(() {
      _isFollowing = !_isFollowing;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing
            ? 'You will receive notifications about this issue'
            : 'You will no longer receive notifications about this issue'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _reportIssue(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content: const Text(
            'Are you sure you want to report this issue as inappropriate or spam?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Issue reported successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _bookmarkIssue(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Issue bookmarked successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionTile(
              context,
              'Update Status',
              'Provide status update if you\'re an authority',
              'update',
              () {
                Navigator.pop(context);
                _updateStatus(context);
              },
            ),
            _buildQuickActionTile(
              context,
              'Similar Issues',
              'View other issues in this area',
              'location_on',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/map-view-screen');
              },
            ),
            _buildQuickActionTile(
              context,
              'Contact Reporter',
              'Send a message to the issue reporter',
              'message',
              () {
                Navigator.pop(context);
                _contactReporter(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(BuildContext context, String title,
      String subtitle, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          size: 24,
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
    );
  }

  void _updateStatus(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status update feature coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactReporter(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Messaging feature coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
