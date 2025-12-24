import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // NIDAAN Logo
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppTheme.shadowDark : AppTheme.shadowLight)
                    .withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'N',
              style: theme.textTheme.headlineLarge?.copyWith(
                color:
                    isDark ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight,
                fontWeight: FontWeight.w700,
                fontSize: 32.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),

        // App Name
        Text(
          'NIDAAN',
          style: theme.textTheme.headlineMedium?.copyWith(
            color:
                isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Civic Issue Reporting Made Simple',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),

        // Welcome Text
        Text(
          'Welcome Back',
          style: theme.textTheme.headlineSmall?.copyWith(
            color:
                isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 1.h),

        Text(
          'Sign in to continue reporting and tracking civic issues',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
