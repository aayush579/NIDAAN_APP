import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
// Add this import for GoogleFonts
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/image_gallery_widget.dart';
import './widgets/issue_form_widget.dart';
import './widgets/location_selector_widget.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/image_gallery_widget.dart';
import 'widgets/issue_form_widget.dart';
import 'widgets/location_selector_widget.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  // Form data
  List<String> _capturedImages = [];
  String? _currentLocation;
  bool _useCurrentLocation = true;
  String? _issueTitle;
  String? _issueDescription;
  String? _issueCategory;
  String? _issuePriority;
  bool _isAnonymous = false;

  // UI state
  bool _isSubmitting = false;
  bool _showCamera = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() {
    if (_useCurrentLocation) {
      setState(() {
        _currentLocation =
            "123 Main Street, Downtown District, City Center, 12345";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: _buildAppBar(isDark),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(isDark),
                    SizedBox(height: 3.h),

                    // Camera Section
                    if (_showCamera) ...[
                      _buildSectionTitle('Photo Evidence', isDark),
                      SizedBox(height: 2.h),
                      CameraPreviewWidget(
                        onImageCaptured: _onImageCaptured,
                        onGalleryTap: _pickImageFromGallery,
                      ),
                      SizedBox(height: 2.h),
                    ],

                    // Image Gallery
                    if (_capturedImages.isNotEmpty) ...[
                      ImageGalleryWidget(
                        imagePaths: _capturedImages,
                        onRemoveImage: _removeImage,
                        onAddImage: _showImageSourceDialog,
                        maxImages: 5,
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Toggle Camera View
                    _buildCameraToggle(isDark),
                    SizedBox(height: 3.h),

                    // Location Section
                    LocationSelectorWidget(
                      currentLocation: _currentLocation,
                      onLocationSelected: (location) {
                        setState(() {
                          _currentLocation = location;
                        });
                      },
                      useCurrentLocation: _useCurrentLocation,
                      onUseCurrentLocationChanged: (value) {
                        setState(() {
                          _useCurrentLocation = value;
                          if (value) {
                            _initializeLocation();
                          } else {
                            _currentLocation = null;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Issue Form
                    IssueFormWidget(
                      title: _issueTitle,
                      description: _issueDescription,
                      category: _issueCategory,
                      priority: _issuePriority,
                      isAnonymous: _isAnonymous,
                      onTitleChanged: (value) =>
                          setState(() => _issueTitle = value),
                      onDescriptionChanged: (value) =>
                          setState(() => _issueDescription = value),
                      onCategoryChanged: (value) =>
                          setState(() => _issueCategory = value),
                      onPriorityChanged: (value) =>
                          setState(() => _issuePriority = value),
                      onAnonymousChanged: (value) =>
                          setState(() => _isAnonymous = value),
                      formKey: _formKey,
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Bottom Submit Section
            _buildSubmitSection(isDark),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
      foregroundColor:
          isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
      elevation: 2.0,
      shadowColor: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'close',
          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          size: 6.w,
        ),
        onPressed: () => _handleCancel(),
        tooltip: 'Cancel',
      ),
      title: Text(
        'Report Issue',
        style: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _saveDraft,
          child: Text(
            'Save Draft',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Report a Civic Issue',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color:
                isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Help improve your community by reporting issues that need attention.',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
      ),
    );
  }

  Widget _buildCameraToggle(bool isDark) {
    return GestureDetector(
      onTap: () => setState(() => _showCamera = !_showCamera),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: _showCamera ? 'visibility_off' : 'camera_alt',
              color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              _showCamera ? 'Hide Camera' : 'Show Camera',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitSection(bool isDark) {
    final isFormValid = _isFormValid();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Progress indicator
          if (_capturedImages.isNotEmpty ||
              _issueTitle?.isNotEmpty == true) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Progress: ${_getFormProgress()}% complete',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isFormValid && !_isSubmitting ? _submitIssue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid
                    ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                    : (isDark
                        ? AppTheme.textDisabledDark
                        : AppTheme.textDisabledLight),
                foregroundColor: Colors.white,
                elevation: isFormValid ? 2.0 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Submitting...',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Submit Issue Report',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          if (!isFormValid) ...[
            SizedBox(height: 1.h),
            Text(
              'Please fill in all required fields to submit',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.errorLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  void _onImageCaptured(String imagePath) {
    if (_capturedImages.length < 5) {
      setState(() {
        _capturedImages.add(imagePath);
      });

      // Haptic feedback
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo captured successfully'),
          backgroundColor: AppTheme.successLight,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum 5 photos allowed'),
          backgroundColor: AppTheme.warningLight,
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        _onImageCaptured(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image from gallery'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Add Photo',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // Camera capture handled by camera widget
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.backgroundDark
                            : AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppTheme.dividerDark
                              : AppTheme.dividerLight,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'camera_alt',
                            color: isDark
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                            size: 8.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Camera',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromGallery();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.backgroundDark
                            : AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppTheme.dividerDark
                              : AppTheme.dividerLight,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'photo_library',
                            color: isDark
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                            size: 8.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Gallery',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _capturedImages.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo removed'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  bool _isFormValid() {
    return _issueTitle?.trim().isNotEmpty == true &&
        _issueDescription?.trim().isNotEmpty == true &&
        _issueCategory?.isNotEmpty == true &&
        _issuePriority?.isNotEmpty == true &&
        (_useCurrentLocation ? _currentLocation?.isNotEmpty == true : true);
  }

  int _getFormProgress() {
    int completed = 0;
    int total = 5;

    if (_issueTitle?.trim().isNotEmpty == true) completed++;
    if (_issueDescription?.trim().isNotEmpty == true) completed++;
    if (_issueCategory?.isNotEmpty == true) completed++;
    if (_issuePriority?.isNotEmpty == true) completed++;
    if (_useCurrentLocation ? _currentLocation?.isNotEmpty == true : true)
      completed++;

    return ((completed / total) * 100).round();
  }

  void _handleCancel() {
    if (_hasUnsavedChanges()) {
      _showCancelDialog();
    } else {
      Navigator.pop(context);
    }
  }

  bool _hasUnsavedChanges() {
    return _capturedImages.isNotEmpty ||
        _issueTitle?.trim().isNotEmpty == true ||
        _issueDescription?.trim().isNotEmpty == true ||
        _issueCategory?.isNotEmpty == true ||
        _issuePriority?.isNotEmpty == true;
  }

  void _showCancelDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? AppTheme.dialogDark : AppTheme.dialogLight,
          title: Text(
            'Discard Changes?',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color:
                  isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
            ),
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to discard them?',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Keep Editing',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Discard',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.errorLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveDraft() {
    // Mock save draft functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  Future<void> _submitIssue() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Mock submission delay
      await Future.delayed(Duration(seconds: 3));

      // Haptic feedback for success - fix the method name
      HapticFeedback.mediumImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('Issue reported successfully!'),
              ],
            ),
            backgroundColor: AppTheme.successLight,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate back to home dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit issue. Please try again.'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}