import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IssueMetadataCard extends StatelessWidget {
  final Map<String, dynamic> issueData;

  const IssueMetadataCard({
    super.key,
    required this.issueData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
          // Category and Priority Row
          Row(
            children: [
              _buildCategoryBadge(context),
              const Spacer(),
              _buildPriorityBadge(context),
            ],
          ),

          SizedBox(height: 3.h),

          // Issue Title
          Text(
            (issueData["title"] as String?) ?? "Issue Title",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          // Metadata Row
          Row(
            children: [
              Expanded(
                child: _buildMetadataItem(
                  context,
                  'date_range',
                  'Submitted',
                  _formatDate((issueData["submissionDate"] as DateTime?) ??
                      DateTime.now()),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetadataItem(
                  context,
                  'update',
                  'Last Updated',
                  _formatDate((issueData["lastUpdated"] as DateTime?) ??
                      DateTime.now()),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Status Row
          Row(
            children: [
              Expanded(
                child: _buildStatusIndicator(context),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetadataItem(
                  context,
                  'confirmation_number',
                  'Issue ID',
                  '#${(issueData["id"] as String?) ?? "12345"}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    final category = (issueData["category"] as String?) ?? "General";
    final categoryColors = {
      'Road & Transport': Colors.orange,
      'Water & Sanitation': Colors.blue,
      'Electricity': Colors.yellow.shade700,
      'Public Safety': Colors.red,
      'Environment': Colors.green,
      'Healthcare': Colors.purple,
      'Education': Colors.indigo,
      'General': Colors.grey,
    };

    final color = categoryColors[category] ?? Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getCategoryIcon(category),
            size: 16,
            color: color,
          ),
          SizedBox(width: 1.w),
          Text(
            category,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final priority = (issueData["priority"] as String?) ?? "Medium";
    final priorityColors = {
      'High': Colors.red,
      'Medium': Colors.orange,
      'Low': Colors.green,
    };

    final color = priorityColors[priority] ?? Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getPriorityIcon(priority),
            size: 16,
            color: color,
          ),
          SizedBox(width: 1.w),
          Text(
            '$priority Priority',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final status = (issueData["status"] as String?) ?? "Open";
    final statusColors = {
      'Open': Colors.blue,
      'In Progress': Colors.orange,
      'Resolved': Colors.green,
      'Closed': Colors.grey,
      'Rejected': Colors.red,
    };

    final color = statusColors[status] ?? Colors.blue;

    return Row(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              Text(
                status,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataItem(
      BuildContext context, String iconName, String label, String value) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 16,
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Road & Transport':
        return 'directions_car';
      case 'Water & Sanitation':
        return 'water_drop';
      case 'Electricity':
        return 'electrical_services';
      case 'Public Safety':
        return 'security';
      case 'Environment':
        return 'eco';
      case 'Healthcare':
        return 'local_hospital';
      case 'Education':
        return 'school';
      default:
        return 'category';
    }
  }

  String _getPriorityIcon(String priority) {
    switch (priority) {
      case 'High':
        return 'priority_high';
      case 'Medium':
        return 'remove';
      case 'Low':
        return 'keyboard_arrow_down';
      default:
        return 'remove';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
