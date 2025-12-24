import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SignupPromptWidget extends StatelessWidget {
  const SignupPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New user? ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
              fontSize: 12.sp,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/signup-screen');
            },
            child: Text(
              'Sign Up',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                decoration: TextDecoration.underline,
                decorationColor:
                    isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
