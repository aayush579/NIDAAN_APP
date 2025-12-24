import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class IssueMarkerWidget extends StatelessWidget {
  final Map<String, dynamic> issue;
  final bool isSelected;
  final VoidCallback onTap;

  const IssueMarkerWidget({
    super.key,
    required this.issue,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = issue['category'] as String? ?? 'road';
    final status = issue['status'] as String? ?? 'pending';

    final categoryData = _getCategoryData(category);
    final statusColor = _getStatusColor(status);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isSelected ? 1.2 : 1.0),
        child: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: categoryData['color'],
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: CustomIconWidget(
                  iconName: categoryData['icon'],
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getCategoryData(String category) {
    switch (category) {
      case 'road':
        return {'icon': 'construction', 'color': const Color(0xFFEF4444)};
      case 'water':
        return {'icon': 'water_drop', 'color': const Color(0xFF3B82F6)};
      case 'electricity':
        return {
          'icon': 'electrical_services',
          'color': const Color(0xFFF59E0B)
        };
      case 'waste':
        return {'icon': 'delete', 'color': const Color(0xFF10B981)};
      case 'public_safety':
        return {'icon': 'security', 'color': const Color(0xFF8B5CF6)};
      case 'parks':
        return {'icon': 'park', 'color': const Color(0xFF059669)};
      default:
        return {'icon': 'report_problem', 'color': const Color(0xFF6B7280)};
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'in_progress':
        return const Color(0xFF3B82F6);
      case 'resolved':
        return const Color(0xFF10B981);
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

class ClusterMarkerWidget extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const ClusterMarkerWidget({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
