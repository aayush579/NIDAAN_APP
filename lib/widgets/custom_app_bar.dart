import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for civic technology application
/// Implements Contemporary Civic Minimalism design principles
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ??
              (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ??
          (isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF)),
      foregroundColor: foregroundColor ??
          (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
      elevation: elevation,
      shadowColor: isDark ? const Color(0x1A000000) : const Color(0x0A000000),
      surfaceTintColor: Colors.transparent,
      leading: leading ??
          (showBackButton && Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                )
              : null),
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: foregroundColor ??
            (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ??
            (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
        size: 24,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  /// Factory constructor for home screen app bar
  factory CustomAppBar.home(BuildContext context) {
    return CustomAppBar(
      title: 'Civic Connect',
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
          tooltip: 'Notifications',
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/profile-screen');
          },
          tooltip: 'Profile',
        ),
      ],
    );
  }

  /// Factory constructor for report issue screen app bar
  factory CustomAppBar.reportIssue(BuildContext context) {
    return CustomAppBar(
      title: 'Report Issue',
      actions: [
        TextButton(
          onPressed: () {
            // Handle save draft
          },
          child: Text(
            'Save Draft',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2563EB),
            ),
          ),
        ),
      ],
    );
  }

  /// Factory constructor for issue detail screen app bar
  factory CustomAppBar.issueDetail(BuildContext context, {String? issueId}) {
    return CustomAppBar(
      title: issueId != null ? 'Issue #$issueId' : 'Issue Details',
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {
            // Handle share issue
          },
          tooltip: 'Share',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                // Handle edit issue
                break;
              case 'delete':
                // Handle delete issue
                break;
              case 'report':
                // Handle report issue
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Edit Issue'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline,
                      size: 20, color: Color(0xFFDC2626)),
                  SizedBox(width: 12),
                  Text('Delete Issue',
                      style: TextStyle(color: Color(0xFFDC2626))),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Report Issue'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Factory constructor for map view screen app bar
  factory CustomAppBar.mapView(BuildContext context) {
    return CustomAppBar(
      title: 'Issue Map',
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_outlined),
          onPressed: () {
            // Handle filter options
          },
          tooltip: 'Filter',
        ),
        IconButton(
          icon: const Icon(Icons.my_location_outlined),
          onPressed: () {
            // Handle location centering
          },
          tooltip: 'My Location',
        ),
      ],
    );
  }

  /// Factory constructor for profile screen app bar
  factory CustomAppBar.profile(BuildContext context) {
    return CustomAppBar(
      title: 'Profile',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            // Handle settings
          },
          tooltip: 'Settings',
        ),
      ],
    );
  }

  /// Factory constructor for login screen app bar
  factory CustomAppBar.login(BuildContext context) {
    return const CustomAppBar(
      title: 'Sign In',
      showBackButton: false,
      centerTitle: true,
    );
  }
}
