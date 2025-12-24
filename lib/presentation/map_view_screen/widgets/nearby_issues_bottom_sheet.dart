import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NearbyIssuesBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> nearbyIssues;
  final Function(Map<String, dynamic>) onIssueSelected;
  final VoidCallback onViewAllIssues;

  const NearbyIssuesBottomSheet({
    super.key,
    required this.nearbyIssues,
    required this.onIssueSelected,
    required this.onViewAllIssues,
  });

  @override
  State<NearbyIssuesBottomSheet> createState() =>
      _NearbyIssuesBottomSheetState();
}

class _NearbyIssuesBottomSheetState extends State<NearbyIssuesBottomSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final isExpanded = _controller.size > 0.6;
      if (isExpanded != _isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.3,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.15, 0.3, 0.6, 0.9],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.15),
                offset: const Offset(0, -2),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar and header
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nearby Issues',
                                style: theme.textTheme.headlineSmall,
                              ),
                              Text(
                                '${widget.nearbyIssues.length} issues in this area',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          if (_isExpanded)
                            TextButton(
                              onPressed: widget.onViewAllIssues,
                              child: Text(
                                'View All',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Issues list
              Expanded(
                child: widget.nearbyIssues.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: widget.nearbyIssues.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          final issue = widget.nearbyIssues[index];
                          return _buildIssueCard(issue, theme);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'location_off',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No issues in this area',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Move the map to explore other areas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(Map<String, dynamic> issue, ThemeData theme) {
    final category = issue['category'] as String? ?? 'road';
    final status = issue['status'] as String? ?? 'pending';
    final priority = issue['priority'] as String? ?? 'medium';

    final categoryData = _getCategoryData(category);
    final statusData = _getStatusData(status);
    final priorityData = _getPriorityData(priority);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => widget.onIssueSelected(issue),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Issue thumbnail
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: issue['imageUrl'] != null
                      ? CustomImageWidget(
                          imageUrl: issue['imageUrl'],
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: CustomIconWidget(
                            iconName: categoryData['icon'],
                            color: categoryData['color'],
                            size: 24,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${issue['id']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          '${issue['distance']}m away',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),

                    Text(
                      issue['title'] ?? 'Untitled Issue',
                      style: theme.textTheme.titleSmall,
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
                          size: 14,
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
                    SizedBox(height: 1.h),

                    // Status badges
                    Row(
                      children: [
                        _buildSmallBadge(
                            statusData['name'], statusData['color'], theme),
                        SizedBox(width: 1.w),
                        _buildSmallBadge(
                            priorityData['name'], priorityData['color'], theme),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallBadge(String text, Color color, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
        ),
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
}
