import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReporterInfoSection extends StatelessWidget {
  final Map<String, dynamic> reporterData;

  const ReporterInfoSection({
    super.key,
    required this.reporterData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAnonymous = (reporterData["isAnonymous"] as bool?) ?? false;

    if (isAnonymous) {
      return _buildAnonymousReporter(context, isDark);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'person',
                size: 20,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(width: 2.w),
              Text(
                'Reported By',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Reporter Info
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: (reporterData["avatar"] as String?) ??
                          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Reporter Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (reporterData["name"] as String?) ?? "John Doe",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_isVerifiedUser())
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: CustomIconWidget(
                                iconName: 'verified',
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      // Reputation Score
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            size: 14,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${(reporterData["reputationScore"] as double?)?.toStringAsFixed(1) ?? "4.2"} Rating',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '•',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${(reporterData["totalReports"] as int?) ?? 12} Reports',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Navigation Arrow
                CustomIconWidget(
                  iconName: 'chevron_right',
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Reporter Stats
          _buildReporterStats(context),
        ],
      ),
    );
  }

  Widget _buildAnonymousReporter(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            child: CustomIconWidget(
              iconName: 'person_outline',
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anonymous Reporter',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Reporter chose to remain anonymous',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReporterStats(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              'Total Reports',
              '${(reporterData["totalReports"] as int?) ?? 12}',
              'assignment',
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              'Resolved',
              '${(reporterData["resolvedReports"] as int?) ?? 8}',
              'check_circle',
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              'Success Rate',
              '${((((reporterData["resolvedReports"] as int?) ?? 8) / ((reporterData["totalReports"] as int?) ?? 12)) * 100).toStringAsFixed(0)}%',
              'trending_up',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 20,
          color: AppTheme.lightTheme.primaryColor,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  bool _isVerifiedUser() {
    final totalReports = (reporterData["totalReports"] as int?) ?? 0;
    final reputationScore = (reporterData["reputationScore"] as double?) ?? 0.0;
    return totalReports >= 10 && reputationScore >= 4.0;
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile-screen');
  }
}
