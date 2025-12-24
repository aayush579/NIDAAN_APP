import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IssueDescriptionSection extends StatefulWidget {
  final String description;

  const IssueDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<IssueDescriptionSection> createState() =>
      _IssueDescriptionSectionState();
}

class _IssueDescriptionSectionState extends State<IssueDescriptionSection> {
  bool _isExpanded = false;
  static const int _maxLines = 4;

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
                iconName: 'description',
                size: 20,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(width: 2.w),
              Text(
                'Issue Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Description Content
          _buildDescriptionContent(context),

          // Expand/Collapse Button
          if (_shouldShowExpandButton()) _buildExpandButton(context),
        ],
      ),
    );
  }

  Widget _buildDescriptionContent(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Text(
        widget.description.isNotEmpty
            ? widget.description
            : "No description provided for this issue.",
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.6,
          color: widget.description.isEmpty
              ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
              : null,
          fontStyle: widget.description.isEmpty ? FontStyle.italic : null,
        ),
        maxLines: _isExpanded ? null : _maxLines,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isExpanded ? 'Show Less' : 'Show More',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                size: 20,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowExpandButton() {
    if (widget.description.isEmpty) return false;

    // Create a TextPainter to measure the text
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
      ),
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 92.w - 8.w); // Account for container padding

    return textPainter.didExceedMaxLines;
  }
}
