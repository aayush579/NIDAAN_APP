import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_header_widget.dart';
import './widgets/signup_prompt_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _scrollController = ScrollController();

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@nidaan.com': 'admin123',
    'user@nidaan.com': 'user123',
    'citizen@nidaan.com': 'citizen123',
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.errorDark
              : AppTheme.errorLight,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.successDark
              : AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Firebase authentication delay
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      if (_mockCredentials.containsKey(email) &&
          _mockCredentials[email] == password) {
        // Success - trigger haptic feedback
        HapticFeedback.lightImpact();

        _showSuccessSnackBar('Login successful! Welcome to NIDAAN');

        // Navigate to home dashboard
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home-dashboard',
            (route) => false,
          );
        }
      } else {
        // Invalid credentials
        _showErrorSnackBar('Invalid email or password. Please try again.');
      }
    } catch (e) {
      // Network or other errors
      _showErrorSnackBar(
          'Login failed. Please check your connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Google authentication
      await Future.delayed(const Duration(seconds: 2));

      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Google login successful!');

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorSnackBar('Google login failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Apple authentication
      await Future.delayed(const Duration(seconds: 2));

      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Apple login successful!');

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorSnackBar('Apple login failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // Header with logo and welcome text
                    const LoginHeaderWidget(),
                    SizedBox(height: 4.h),

                    // Login Form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: 4.h),

                    // Social Login Options
                    SocialLoginWidget(
                      onGoogleLogin: _handleGoogleLogin,
                      onAppleLogin: _handleAppleLogin,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: 4.h),

                    // Sign Up Prompt
                    const SignupPromptWidget(),
                    SizedBox(height: 2.h),

                    // Mock Credentials Info (for testing)
                    if (Theme.of(context).brightness == Brightness.dark)
                      Container(
                        padding: EdgeInsets.all(3.w),
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.dividerDark.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Credentials:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            ..._mockCredentials.entries.map((entry) => Padding(
                                  padding: EdgeInsets.only(bottom: 0.5.h),
                                  child: Text(
                                    '${entry.key} / ${entry.value}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondaryDark,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
