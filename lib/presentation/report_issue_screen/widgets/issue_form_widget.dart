import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class IssueFormWidget extends StatefulWidget {
  final String? title;
  final String? description;
  final String? category;
  final String? priority;
  final bool isAnonymous;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;
  final Function(String) onCategoryChanged;
  final Function(String) onPriorityChanged;
  final Function(bool) onAnonymousChanged;
  final GlobalKey<FormState> formKey;

  const IssueFormWidget({
    super.key,
    this.title,
    this.description,
    this.category,
    this.priority,
    required this.isAnonymous,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
    required this.onAnonymousChanged,
    required this.formKey,
  });

  @override
  State<IssueFormWidget> createState() => _IssueFormWidgetState();
}

class _IssueFormWidgetState extends State<IssueFormWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'roads',
      'name': 'Roads & Transportation',
      'icon': 'directions_car',
      'color': Color(0xFF2563EB),
    },
    {
      'id': 'water',
      'name': 'Water & Sanitation',
      'icon': 'water_drop',
      'color': Color(0xFF0891B2),
    },
    {
      'id': 'electricity',
      'name': 'Electricity & Power',
      'icon': 'electrical_services',
      'color': Color(0xFFF59E0B),
    },
    {
      'id': 'waste',
      'name': 'Waste Management',
      'icon': 'delete',
      'color': Color(0xFF059669),
    },
    {
      'id': 'safety',
      'name': 'Public Safety',
      'icon': 'security',
      'color': Color(0xFFDC2626),
    },
    {
      'id': 'other',
      'name': 'Other Issues',
      'icon': 'more_horiz',
      'color': Color(0xFF7C3AED),
    },
  ];

  final List<Map<String, dynamic>> _priorities = [
    {
      'id': 'low',
      'name': 'Low',
      'description': 'Minor issue, can wait',
      'color': Color(0xFF059669),
    },
    {
      'id': 'medium',
      'name': 'Medium',
      'description': 'Moderate concern',
      'color': Color(0xFFF59E0B),
    },
    {
      'id': 'high',
      'name': 'High',
      'description': 'Urgent attention needed',
      'color': Color(0xFFDC2626),
    },
    {
      'id': 'emergency',
      'name': 'Emergency',
      'description': 'Immediate action required',
      'color': Color(0xFF991B1B),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.title != null) _titleController.text = widget.title!;
    if (widget.description != null)
      _descriptionController.text = widget.description!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Issue Category
          _buildSectionHeader('Category', true, isDark),
          SizedBox(height: 2.h),
          _buildCategorySelector(isDark),
          SizedBox(height: 3.h),

          // Issue Title
          _buildSectionHeader('Issue Title', true, isDark),
          SizedBox(height: 2.h),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Brief title for the issue',
              hintText: 'e.g., Pothole on Main Street',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'title',
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  size: 5.w,
                ),
              ),
              counterText: '${_titleController.text.length}/100',
            ),
            maxLength: 100,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              widget.onTitleChanged(value);
              setState(() {}); // Update counter
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an issue title';
              }
              if (value.trim().length < 5) {
                return 'Title must be at least 5 characters long';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Issue Description
          _buildSectionHeader('Description', true, isDark),
          SizedBox(height: 2.h),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Detailed description',
              hintText: 'Describe the issue in detail...',
              alignLabelWithHint: true,
              counterText: '${_descriptionController.text.length}/500',
            ),
            maxLines: 4,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              widget.onDescriptionChanged(value);
              setState(() {}); // Update counter
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please provide a description';
              }
              if (value.trim().length < 10) {
                return 'Description must be at least 10 characters long';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Priority Level
          _buildSectionHeader('Priority Level', true, isDark),
          SizedBox(height: 2.h),
          _buildPrioritySelector(isDark),
          SizedBox(height: 3.h),

          // Anonymous Reporting
          _buildAnonymousToggle(isDark),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isRequired, bool isDark) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color:
                isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.errorLight,
            ),
          ),
      ],
    );
  }

  Widget _buildCategorySelector(bool isDark) {
    return Wrap(
      spacing: 3.w,
      runSpacing: 2.h,
      children: _categories.map((category) {
        final isSelected = widget.category == category['id'];
        return GestureDetector(
          onTap: () => widget.onCategoryChanged(category['id']),
          child: Container(
            width: 42.w,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? (category['color'] as Color).withValues(alpha: 0.1)
                  : (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (category['color'] as Color)
                    : (isDark ? AppTheme.dividerDark : AppTheme.dividerLight),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: category['icon'],
                  color: isSelected
                      ? (category['color'] as Color)
                      : (isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight),
                  size: 8.w,
                ),
                SizedBox(height: 1.h),
                Text(
                  category['name'],
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? (category['color'] as Color)
                        : (isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritySelector(bool isDark) {
    return Column(
      children: _priorities.map((priority) {
        final isSelected = widget.priority == priority['id'];
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: GestureDetector(
            onTap: () => widget.onPriorityChanged(priority['id']),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? (priority['color'] as Color).withValues(alpha: 0.1)
                    : (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? (priority['color'] as Color)
                      : (isDark ? AppTheme.dividerDark : AppTheme.dividerLight),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: priority['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          priority['name'],
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isDark
                                ? AppTheme.textPrimaryDark
                                : AppTheme.textPrimaryLight,
                          ),
                        ),
                        Text(
                          priority['description'],
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: priority['color'] as Color,
                      size: 6.w,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnonymousToggle(bool isDark) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: widget.isAnonymous ? 'visibility_off' : 'visibility',
            color: widget.isAnonymous
                ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                : (isDark
                    ? AppTheme.textDisabledDark
                    : AppTheme.textDisabledLight),
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anonymous Reporting',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  widget.isAnonymous
                      ? 'Your identity will be kept private'
                      : 'Your name will be visible to authorities',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.isAnonymous,
            onChanged: widget.onAnonymousChanged,
          ),
        ],
      ),
    );
  }
}