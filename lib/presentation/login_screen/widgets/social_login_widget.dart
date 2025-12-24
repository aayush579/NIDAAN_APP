import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function() onGoogleLogin;
  final Function() onAppleLogin;
  final bool isLoading;

  const SocialLoginWidget({
    super.key,
    required this.onGoogleLogin,
    required this.onAppleLogin,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          children: [
            // Google Login Button
            Expanded(
              child: _SocialLoginButton(
                onPressed: isLoading ? null : onGoogleLogin,
                icon: 'g_translate',
                label: 'Google',
                backgroundColor:
                    isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                textColor: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                borderColor:
                    isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              ),
            ),
            SizedBox(width: 4.w),

            // Apple Login Button
            Expanded(
              child: _SocialLoginButton(
                onPressed: isLoading ? null : onAppleLogin,
                icon: 'apple',
                label: 'Apple',
                backgroundColor:
                    isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                textColor: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                borderColor:
                    isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _SocialLoginButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 6.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: textColor,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
