import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IssuePreviewCard extends StatelessWidget {
  final Map<String, dynamic> issue;
  final VoidCallback onViewDetails;
  final VoidCallback onClose;

  const IssuePreviewCard({
    super.key,
    required this.issue,
    required this.onViewDetails,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final category = issue['category'] as String? ?? 'road';
    final status = issue['status'] as String? ?? 'pending';
    final priority = issue['priority'] as String? ?? 'medium';

    final categoryData = _getCategoryData(category);
    final statusData = _getStatusData(status);
    final priorityData = _getPriorityData(priority);

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.w, 2.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Issue #${issue['id']}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Issue image and content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Issue thumbnail
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: issue['imageUrl'] != null
                            ? CustomImageWidget(
                                imageUrl: issue['imageUrl'],
                                width: 20.w,
                                height: 20.w,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: CustomIconWidget(
                                  iconName: categoryData['icon'],
                                  color: categoryData['color'],
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 3.w),

                    // Issue details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue['title'] ?? 'Untitled Issue',
                            style: theme.textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),

                          Text(
                            issue['description'] ?? 'No description available',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),

                          // Location
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  issue['location'] ?? 'Unknown location',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Status badges
                Row(
                  children: [
                    _buildBadge(
                      categoryData['name'],
                      categoryData['color'],
                      categoryData['icon'],
                      theme,
                    ),
                    SizedBox(width: 2.w),
                    _buildBadge(
                      statusData['name'],
                      statusData['color'],
                      null,
                      theme,
                    ),
                    SizedBox(width: 2.w),
                    _buildBadge(
                      priorityData['name'],
                      priorityData['color'],
                      null,
                      theme,
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Timestamp
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatTimestamp(issue['createdAt']),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // View details button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onViewDetails,
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
      String text, Color color, String? iconName, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconName != null) ...[
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 12,
            ),
            SizedBox(width: 1.w),
          ],
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getCategoryData(String category) {
    switch (category) {
      case 'road':
        return {
          'name': 'Road',
          'icon': 'construction',
          'color': const Color(0xFFEF4444)
        };
      case 'water':
        return {
          'name': 'Water',
          'icon': 'water_drop',
          'color': const Color(0xFF3B82F6)
        };
      case 'electricity':
        return {
          'name': 'Electricity',
          'icon': 'electrical_services',
          'color': const Color(0xFFF59E0B)
        };
      case 'waste':
        return {
          'name': 'Waste',
          'icon': 'delete',
          'color': const Color(0xFF10B981)
        };
      case 'public_safety':
        return {
          'name': 'Safety',
          'icon': 'security',
          'color': const Color(0xFF8B5CF6)
        };
      case 'parks':
        return {
          'name': 'Parks',
          'icon': 'park',
          'color': const Color(0xFF059669)
        };
      default:
        return {
          'name': 'Other',
          'icon': 'report_problem',
          'color': const Color(0xFF6B7280)
        };
    }
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case 'pending':
        return {'name': 'Pending', 'color': const Color(0xFFF59E0B)};
      case 'in_progress':
        return {'name': 'In Progress', 'color': const Color(0xFF3B82F6)};
      case 'resolved':
        return {'name': 'Resolved', 'color': const Color(0xFF10B981)};
      case 'rejected':
        return {'name': 'Rejected', 'color': const Color(0xFFEF4444)};
      default:
        return {'name': 'Unknown', 'color': const Color(0xFF6B7280)};
    }
  }

  Map<String, dynamic> _getPriorityData(String priority) {
    switch (priority) {
      case 'low':
        return {'name': 'Low', 'color': const Color(0xFF10B981)};
      case 'medium':
        return {'name': 'Medium', 'color': const Color(0xFFF59E0B)};
      case 'high':
        return {'name': 'High', 'color': const Color(0xFFEF4444)};
      case 'critical':
        return {'name': 'Critical', 'color': const Color(0xFF7C2D12)};
      default:
        return {'name': 'Medium', 'color': const Color(0xFFF59E0B)};
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';

    try {
      final DateTime dateTime = timestamp is DateTime
          ? timestamp
          : DateTime.parse(timestamp.toString());
      final Duration difference = DateTime.now().difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}
