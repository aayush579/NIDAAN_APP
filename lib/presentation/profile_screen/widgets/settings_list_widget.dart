import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsListWidget extends StatelessWidget {
  final Function(String) onSettingTap;
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  const SettingsListWidget({
    super.key,
    required this.onSettingTap,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> settingsItems = [
      {
        "title": "Account Information",
        "subtitle": "Manage your personal details",
        "icon": "person_outline",
        "key": "account_info",
        "hasToggle": false,
      },
      {
        "title": "Notification Preferences",
        "subtitle": "Control your notification settings",
        "icon": "notifications_outlined",
        "key": "notifications",
        "hasToggle": false,
      },
      {
        "title": "Privacy Settings",
        "subtitle": "Manage data sharing and privacy",
        "icon": "privacy_tip_outlined",
        "key": "privacy",
        "hasToggle": false,
      },
      {
        "title": "Language Selection",
        "subtitle": "Choose your preferred language",
        "icon": "language",
        "key": "language",
        "hasToggle": false,
      },
      {
        "title": "Theme Toggle",
        "subtitle": "Switch between light and dark mode",
        "icon": "palette_outlined",
        "key": "theme",
        "hasToggle": true,
      },
      {
        "title": "Help & Support",
        "subtitle": "Get help and contact support",
        "icon": "help_outline",
        "key": "help",
        "hasToggle": false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Settings",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: settingsItems.length,
          separatorBuilder: (context, index) => Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          itemBuilder: (context, index) {
            final item = settingsItems[index];
            return _SettingsListItem(
              title: item["title"] as String,
              subtitle: item["subtitle"] as String,
              iconName: item["icon"] as String,
              hasToggle: item["hasToggle"] as bool,
              toggleValue: item["key"] == "theme" ? isDarkMode : false,
              onTap: () => onSettingTap(item["key"] as String),
              onToggle: item["key"] == "theme" ? onThemeToggle : null,
            );
          },
        ),
      ],
    );
  }
}

class _SettingsListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final bool hasToggle;
  final bool toggleValue;
  final VoidCallback onTap;
  final Function(bool)? onToggle;

  const _SettingsListItem({
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.hasToggle,
    required this.toggleValue,
    required this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: hasToggle ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            // Icon
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                size: 5.w,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 4.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            // Action
            if (hasToggle && onToggle != null)
              Switch(
                value: toggleValue,
                onChanged: onToggle,
              )
            else
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                size: 4.w,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
