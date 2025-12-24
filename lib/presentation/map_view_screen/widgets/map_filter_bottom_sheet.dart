import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MapFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const MapFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();
}

class _MapFilterBottomSheetState extends State<MapFilterBottomSheet> {
  late Map<String, dynamic> _filters;

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'road',
      'name': 'Road Issues',
      'icon': 'construction',
      'color': Color(0xFFEF4444)
    },
    {
      'id': 'water',
      'name': 'Water & Drainage',
      'icon': 'water_drop',
      'color': Color(0xFF3B82F6)
    },
    {
      'id': 'electricity',
      'name': 'Electricity',
      'icon': 'electrical_services',
      'color': Color(0xFFF59E0B)
    },
    {
      'id': 'waste',
      'name': 'Waste Management',
      'icon': 'delete',
      'color': Color(0xFF10B981)
    },
    {
      'id': 'public_safety',
      'name': 'Public Safety',
      'icon': 'security',
      'color': Color(0xFF8B5CF6)
    },
    {
      'id': 'parks',
      'name': 'Parks & Recreation',
      'icon': 'park',
      'color': Color(0xFF059669)
    },
  ];

  final List<Map<String, dynamic>> _statuses = [
    {'id': 'pending', 'name': 'Pending', 'color': Color(0xFFF59E0B)},
    {'id': 'in_progress', 'name': 'In Progress', 'color': Color(0xFF3B82F6)},
    {'id': 'resolved', 'name': 'Resolved', 'color': Color(0xFF10B981)},
    {'id': 'rejected', 'name': 'Rejected', 'color': Color(0xFFEF4444)},
  ];

  final List<Map<String, dynamic>> _priorities = [
    {'id': 'low', 'name': 'Low', 'color': Color(0xFF10B981)},
    {'id': 'medium', 'name': 'Medium', 'color': Color(0xFFF59E0B)},
    {'id': 'high', 'name': 'High', 'color': Color(0xFFEF4444)},
    {'id': 'critical', 'name': 'Critical', 'color': Color(0xFF7C2D12)},
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Issues',
                  style: theme.textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(theme),
                  SizedBox(height: 3.h),
                  _buildStatusSection(theme),
                  SizedBox(height: 3.h),
                  _buildPrioritySection(theme),
                  SizedBox(height: 3.h),
                  _buildDateRangeSection(theme),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFiltersChanged(_filters);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories.map((category) {
            final isSelected = (_filters['categories'] as List<String>? ?? [])
                .contains(category['id']);
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: category['icon'],
                    color: isSelected ? Colors.white : category['color'],
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(category['name']),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) =>
                  _toggleFilter('categories', category['id']),
              selectedColor: category['color'],
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _statuses.map((status) {
            final isSelected = (_filters['statuses'] as List<String>? ?? [])
                .contains(status['id']);
            return FilterChip(
              label: Text(status['name']),
              selected: isSelected,
              onSelected: (selected) => _toggleFilter('statuses', status['id']),
              selectedColor: status['color'],
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrioritySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _priorities.map((priority) {
            final isSelected = (_filters['priorities'] as List<String>? ?? [])
                .contains(priority['id']);
            return FilterChip(
              label: Text(priority['name']),
              selected: isSelected,
              onSelected: (selected) =>
                  _toggleFilter('priorities', priority['id']),
              selectedColor: priority['color'],
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(context, 'start'),
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                label: Text(
                  _filters['startDate'] != null
                      ? '${(_filters['startDate'] as DateTime).day}/${(_filters['startDate'] as DateTime).month}/${(_filters['startDate'] as DateTime).year}'
                      : 'Start Date',
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(context, 'end'),
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                label: Text(
                  _filters['endDate'] != null
                      ? '${(_filters['endDate'] as DateTime).day}/${(_filters['endDate'] as DateTime).month}/${(_filters['endDate'] as DateTime).year}'
                      : 'End Date',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toggleFilter(String filterType, String value) {
    setState(() {
      final currentList = (_filters[filterType] as List<String>?) ?? <String>[];
      if (currentList.contains(value)) {
        currentList.remove(value);
      } else {
        currentList.add(value);
      }
      _filters[filterType] = currentList;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'categories': <String>[],
        'statuses': <String>[],
        'priorities': <String>[],
        'startDate': null,
        'endDate': null,
      };
    });
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filters['${type}Date'] = picked;
      });
    }
  }
}
