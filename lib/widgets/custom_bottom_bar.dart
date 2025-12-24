import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data class
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom Bottom Navigation Bar for civic technology application
/// Implements Contemporary Civic Minimalism with smart navigation indicators
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
  });

  /// Hardcoded navigation items for civic application
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home-dashboard',
    ),
    NavigationItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Report',
      route: '/report-issue-screen',
    ),
    NavigationItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'Map',
      route: '/map-view-screen',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF)),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x1A000000) : const Color(0x0A000000),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return _NavigationBarItem(
                item: item,
                isSelected: isSelected,
                onTap: () => _handleNavigation(context, index, item.route),
                selectedColor: selectedItemColor ??
                    (isDark
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF2563EB)),
                unselectedColor: unselectedItemColor ??
                    (isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF475569)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index, String route) {
    onTap(index);

    // Navigate to the selected route if it's different from current
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}

/// Individual navigation bar item with custom indicator animation
class _NavigationBarItem extends StatefulWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const _NavigationBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  State<_NavigationBarItem> createState() => _NavigationBarItemState();
}

class _NavigationBarItemState extends State<_NavigationBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _indicatorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(_NavigationBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom indicator with animation
            AnimatedBuilder(
              animation: _indicatorAnimation,
              builder: (context, child) {
                return Container(
                  height: 3,
                  width: 24 * _indicatorAnimation.value,
                  decoration: BoxDecoration(
                    color: widget.selectedColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            // Icon with scale animation
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    widget.isSelected
                        ? widget.item.activeIcon
                        : widget.item.icon,
                    size: 24,
                    color: widget.isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            // Label with color transition
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight:
                    widget.isSelected ? FontWeight.w500 : FontWeight.w400,
                color: widget.isSelected
                    ? widget.selectedColor
                    : widget.unselectedColor,
                letterSpacing: 0.4,
              ),
              child: Text(widget.item.label),
            ),
          ],
        ),
      ),
    );
  }
}