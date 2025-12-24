import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusTimelineSection extends StatelessWidget {
  final List<Map<String, dynamic>> timelineData;

  const StatusTimelineSection({
    super.key,
    required this.timelineData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                iconName: 'timeline',
                size: 20,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(width: 2.w),
              Text(
                'Status Timeline',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Timeline Items
          ...timelineData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == timelineData.length - 1;

            return _buildTimelineItem(context, item, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      BuildContext context, Map<String, dynamic> item, bool isLast) {
    final theme = Theme.of(context);
    final status = (item["status"] as String?) ?? "Unknown";
    final timestamp = (item["timestamp"] as DateTime?) ?? DateTime.now();
    final description = (item["description"] as String?) ?? "";
    final authority = (item["authority"] as String?) ?? "";
    final isAuthorityResponse = authority.isNotEmpty;

    final statusColor = _getStatusColor(status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 8.h,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                ),
            ],
          ),

          SizedBox(width: 3.w),

          // Timeline Content
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status and Timestamp Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getStatusDisplayName(status),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      Text(
                        _formatTimestamp(timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Description
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),

                  // Authority Response
                  if (isAuthorityResponse)
                    Container(
                      margin: EdgeInsets.only(top: 1.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'verified',
                            size: 16,
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Official Response',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  authority,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
      case 'open':
        return Colors.blue;
      case 'acknowledged':
      case 'under_review':
        return Colors.orange;
      case 'in_progress':
      case 'assigned':
        return Colors.purple;
      case 'resolved':
      case 'completed':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Issue Submitted';
      case 'acknowledged':
        return 'Acknowledged';
      case 'under_review':
        return 'Under Review';
      case 'assigned':
        return 'Assigned to Department';
      case 'in_progress':
        return 'Work in Progress';
      case 'resolved':
        return 'Issue Resolved';
      case 'completed':
        return 'Work Completed';
      case 'closed':
        return 'Issue Closed';
      case 'rejected':
        return 'Issue Rejected';
      default:
        return status;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
