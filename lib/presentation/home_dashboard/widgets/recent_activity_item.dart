import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityItem extends StatefulWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onViewDetails;
  final VoidCallback? onShare;
  final VoidCallback? onFollow;

  const RecentActivityItem({
    super.key,
    required this.activity,
    this.onViewDetails,
    this.onShare,
    this.onFollow,
  });

  @override
  State<RecentActivityItem> createState() => _RecentActivityItemState();
}

class _RecentActivityItemState extends State<RecentActivityItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return const Color(0xFF10B981);
      case 'in progress':
        return const Color(0xFFF59E0B);
      case 'pending':
        return const Color(0xFFEF4444);
      case 'under review':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return 'check_circle';
      case 'in progress':
        return 'hourglass_empty';
      case 'pending':
        return 'pending';
      case 'under review':
        return 'visibility';
      default:
        return 'help';
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor(widget.activity['status'] ?? '');
    final statusIcon = _getStatusIcon(widget.activity['status'] ?? '');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Slidable(
        key: ValueKey(widget.activity['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onViewDetails?.call(),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) => widget.onShare?.call(),
              backgroundColor: AppTheme.getAccentColor(isDark),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
            SlidableAction(
              onPressed: (_) => widget.onFollow?.call(),
              backgroundColor: AppTheme.getSuccessColor(isDark),
              foregroundColor: Colors.white,
              icon: Icons.notifications,
              label: 'Follow',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: widget.activity['userAvatar'] != null
                          ? CustomImageWidget(
                              imageUrl: widget.activity['userAvatar'],
                              width: 10.w,
                              height: 10.w,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              child: CustomIconWidget(
                                iconName: 'person',
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.activity['userName'] ?? 'Anonymous User',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: statusIcon,
                                    color: statusColor,
                                    size: 12,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    widget.activity['status'] ?? 'Unknown',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              widget.activity['timestamp'] != null
                                  ? _formatTimeAgo(widget.activity['timestamp'])
                                  : 'Unknown time',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                fontSize: 10.sp,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                widget.activity['location'] ??
                                    'Unknown location',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: 10.sp,
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
              Text(
                widget.activity['title'] ?? 'No title',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                widget.activity['description'] ?? 'No description available',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              widget.activity['imageUrl'] != null
                  ? Column(
                      children: [
                        SizedBox(height: 2.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: widget.activity['imageUrl'],
                            width: double.infinity,
                            height: 20.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.activity['category'] ?? 'General',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Swipe for actions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 9.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'swipe',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
