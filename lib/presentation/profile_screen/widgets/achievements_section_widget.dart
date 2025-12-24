import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementsSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;
  final Function(Map<String, dynamic>) onAchievementTap;

  const AchievementsSectionWidget({
    super.key,
    required this.achievements,
    required this.onAchievementTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Achievements",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all achievements
              },
              child: Text(
                "View All",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return _AchievementCard(
                achievement: achievement,
                onTap: () => onAchievementTap(achievement),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Map<String, dynamic> achievement;
  final VoidCallback onTap;

  const _AchievementCard({
    required this.achievement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEarned = achievement["isEarned"] as bool? ?? false;
    final progress = achievement["progress"] as double? ?? 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isEarned
                ? AppTheme.getSuccessColor(isDark).withValues(alpha: 0.3)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Badge Icon
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: isEarned
                    ? AppTheme.getSuccessColor(isDark).withValues(alpha: 0.1)
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: achievement["icon"] as String? ?? "military_tech",
                size: 8.w,
                color: isEarned
                    ? AppTheme.getSuccessColor(isDark)
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            // Badge Title
            Text(
              achievement["title"] as String? ?? "Achievement",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isEarned
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            // Description
            Text(
              achievement["description"] as String? ?? "Badge description",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Progress Indicator
            if (!isEarned) ...[
              SizedBox(height: 1.h),
              Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor:
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "${(progress * 100).toInt()}% Complete",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.getSuccessColor(isDark).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  "Earned",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getSuccessColor(isDark),
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
