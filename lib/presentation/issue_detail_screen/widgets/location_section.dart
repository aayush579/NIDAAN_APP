import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSection extends StatelessWidget {
  final Map<String, dynamic> locationData;

  const LocationSection({
    super.key,
    required this.locationData,
  });

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
                iconName: 'location_on',
                size: 20,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(width: 2.w),
              Text(
                'Location',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Address
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  (locationData["address"] as String?) ??
                      "123 Main Street, Downtown Area, City, State 12345",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Coordinates and Actions Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coordinates',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${(locationData["latitude"] as double?)?.toStringAsFixed(6) ?? "40.712776"}, ${(locationData["longitude"] as double?)?.toStringAsFixed(6) ?? "-74.005974"}',
                      style: AppTheme.getDataTextStyle(
                          isLight: !isDark, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              _buildActionButton(
                context,
                'View on Map',
                'map',
                () => _openInMaps(context),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Additional Location Info
          if (locationData["landmark"] != null || locationData["area"] != null)
            _buildLocationDetails(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, String iconName,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: CustomIconWidget(
        iconName: iconName,
        size: 16,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildLocationDetails(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (locationData["landmark"] != null)
          _buildDetailRow(
            context,
            'Nearby Landmark',
            (locationData["landmark"] as String),
            'place',
          ),
        if (locationData["area"] != null)
          _buildDetailRow(
            context,
            'Area/District',
            (locationData["area"] as String),
            'location_city',
          ),
      ],
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openInMaps(BuildContext context) {
    final latitude = (locationData["latitude"] as double?) ?? 40.712776;
    final longitude = (locationData["longitude"] as double?) ?? -74.005974;

    // This would typically open the native maps app
    // For now, we'll show a snackbar as a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening location ($latitude, $longitude) in maps...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
