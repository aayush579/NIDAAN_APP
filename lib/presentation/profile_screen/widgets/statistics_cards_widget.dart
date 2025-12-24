import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatisticsCardsWidget extends StatelessWidget {
  final Map<String, dynamic> statisticsData;
  final Function(String) onCardTap;

  const StatisticsCardsWidget({
    super.key,
    required this.statisticsData,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> statsCards = [
      {
        "title": "Issues Reported",
        "value": statisticsData["totalIssues"]?.toString() ?? "0",
        "icon": "report_problem",
        "color": theme.colorScheme.primary,
        "key": "total_issues",
      },
      {
        "title": "Resolution Rate",
        "value": "${statisticsData["resolutionRate"]?.toString() ?? "0"}%",
        "icon": "check_circle",
        "color": AppTheme.getSuccessColor(isDark),
        "key": "resolution_rate",
      },
      {
        "title": "Community Impact",
        "value": statisticsData["impactScore"]?.toString() ?? "0",
        "icon": "people",
        "color": AppTheme.getAccentColor(isDark),
        "key": "impact_score",
      },
      {
        "title": "Badges Earned",
        "value": statisticsData["badgesEarned"]?.toString() ?? "0",
        "icon": "military_tech",
        "color": AppTheme.getWarningColor(isDark),
        "key": "badges_earned",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Statistics",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: statsCards.length,
          itemBuilder: (context, index) {
            final card = statsCards[index];
            return _StatisticCard(
              title: card["title"] as String,
              value: card["value"] as String,
              iconName: card["icon"] as String,
              color: card["color"] as Color,
              onTap: () => onCardTap(card["key"] as String),
            );
          },
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconName;
  final Color color;
  final VoidCallback onTap;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.iconName,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    size: 6.w,
                    color: color,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  size: 4.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
