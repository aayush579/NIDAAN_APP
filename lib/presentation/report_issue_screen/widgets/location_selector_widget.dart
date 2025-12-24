import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationSelectorWidget extends StatefulWidget {
  final String? currentLocation;
  final Function(String) onLocationSelected;
  final bool useCurrentLocation;
  final Function(bool) onUseCurrentLocationChanged;

  const LocationSelectorWidget({
    super.key,
    this.currentLocation,
    required this.onLocationSelected,
    required this.useCurrentLocation,
    required this.onUseCurrentLocationChanged,
  });

  @override
  State<LocationSelectorWidget> createState() => _LocationSelectorWidgetState();
}

class _LocationSelectorWidgetState extends State<LocationSelectorWidget> {
  final TextEditingController _locationController = TextEditingController();
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentLocation != null) {
      _locationController.text = widget.currentLocation!;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Location',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
            ),
            Text(
              ' *',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.errorLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Use current location toggle
        Container(
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
                iconName: 'my_location',
                color: widget.useCurrentLocation
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
                      'Use Current Location',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Automatically detect your location',
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
                value: widget.useCurrentLocation,
                onChanged: (value) {
                  widget.onUseCurrentLocationChanged(value);
                  if (value) {
                    _getCurrentLocation();
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Manual location input
        if (!widget.useCurrentLocation) ...[
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Enter Location',
              hintText: 'Type address or landmark',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'edit_location',
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: _showMapPicker,
                icon: CustomIconWidget(
                  iconName: 'map',
                  color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                  size: 5.w,
                ),
                tooltip: 'Pick from map',
              ),
            ),
            onChanged: widget.onLocationSelected,
            validator: (value) {
              if (!widget.useCurrentLocation &&
                  (value == null || value.trim().isEmpty)) {
                return 'Please enter a location or use current location';
              }
              return null;
            },
          ),
        ] else ...[
          // Current location display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                width: 1,
              ),
            ),
            child: _isLoadingLocation
                ? Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Getting your location...',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: isDark
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          widget.currentLocation ?? 'Location not available',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppTheme.textPrimaryDark
                                : AppTheme.textPrimaryLight,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _getCurrentLocation,
                        child: Text(
                          'Refresh',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],

        SizedBox(height: 1.h),

        // Location accuracy note
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: (isDark ? AppTheme.warningDark : AppTheme.warningLight)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isDark ? AppTheme.warningDark : AppTheme.warningLight)
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: isDark ? AppTheme.warningDark : AppTheme.warningLight,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Accurate location helps authorities respond faster to your issue.',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Simulate getting current location
      await Future.delayed(Duration(seconds: 2));

      // Mock location data
      const mockLocation =
          "123 Main Street, Downtown District, City Center, 12345";

      widget.onLocationSelected(mockLocation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location updated successfully'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location. Please enter manually.'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showMapPicker() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Location',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),

            // Map placeholder
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.backgroundDark
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'map',
                        color: isDark
                            ? AppTheme.textDisabledDark
                            : AppTheme.textDisabledLight,
                        size: 15.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Interactive Map',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Tap to select location',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppTheme.textDisabledDark
                              : AppTheme.textDisabledLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Confirm button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _locationController.text = "Selected location from map";
                    widget.onLocationSelected(_locationController.text);
                  },
                  child: Text('Confirm Location'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}