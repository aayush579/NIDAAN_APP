import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MapControlsWidget extends StatelessWidget {
  final VoidCallback onMyLocationPressed;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLayerToggle;
  final String currentLayer;
  final bool isLocationLoading;

  const MapControlsWidget({
    super.key,
    required this.onMyLocationPressed,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLayerToggle,
    required this.currentLayer,
    this.isLocationLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      right: 4.w,
      bottom: 20.h,
      child: Column(
        children: [
          // Layer toggle button
          _buildControlButton(
            theme,
            isDark,
            onTap: onLayerToggle,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: _getLayerIcon(currentLayer),
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _getLayerName(currentLayer),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Zoom controls
          Column(
            children: [
              _buildControlButton(
                theme,
                isDark,
                onTap: onZoomIn,
                child: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              SizedBox(height: 1.h),
              _buildControlButton(
                theme,
                isDark,
                onTap: onZoomOut,
                child: CustomIconWidget(
                  iconName: 'remove',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // My location button
          _buildControlButton(
            theme,
            isDark,
            onTap: onMyLocationPressed,
            isPrimary: true,
            child: isLocationLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'my_location',
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    ThemeData theme,
    bool isDark, {
    required VoidCallback onTap,
    required Widget child,
    bool isPrimary = false,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: isPrimary
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  String _getLayerIcon(String layer) {
    switch (layer) {
      case 'satellite':
        return 'satellite_alt';
      case 'traffic':
        return 'traffic';
      case 'terrain':
        return 'terrain';
      default:
        return 'map';
    }
  }

  String _getLayerName(String layer) {
    switch (layer) {
      case 'satellite':
        return 'Satellite';
      case 'traffic':
        return 'Traffic';
      case 'terrain':
        return 'Terrain';
      default:
        return 'Standard';
    }
  }
}

class ReportIssueHereButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isVisible;

  const ReportIssueHereButton({
    super.key,
    required this.onPressed,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: isVisible ? 35.h : 30.h,
      left: 4.w,
      right: 4.w,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isVisible ? 1.0 : 0.0,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          shadowColor: isDark
              ? Colors.black.withValues(alpha: 0.4)
              : Colors.black.withValues(alpha: 0.2),
          child: InkWell(
            onTap: isVisible ? onPressed : null,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add_location',
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Report Issue Here',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
