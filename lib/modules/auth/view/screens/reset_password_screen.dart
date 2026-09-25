import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/auth_provider.dart';
import '../../../../themes/utils.dart';
import '../../../../widgets/glass_text_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends ConsumerState<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final otp = _otpController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _errorMessage = null;
    });

    if (otp.isEmpty || otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the 6-digit reset code.';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a new password.';
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        _errorMessage =
            'Password must be at least 8 characters long.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(
        resetPasswordProvider(
          (
            email: widget.email,
            otp: otp,
            password: password,
          ),
        ).future,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully.'),
        ),
      );

      context.go(AppRoutes.login);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Could not reset password. Please check the code and try again.';
      });
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
    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/aixx_logo.png',
                  height: 42,
                ),
              ),

              const SizedBox(height: 56),

              Text(
                'Reset Password',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      color: onSurfaceColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter the 6-digit code sent to ${widget.email} and create a new password.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: mutedTextColor,
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: 32),

              GlassTextField(
                controller: _otpController,
                label: 'Reset Code',
                hint: 'Enter 6-digit code',
                keyboardType: TextInputType.number,
                icon: Icons.pin,
              ),

              const SizedBox(height: 16),

              GlassTextField(
                controller: _passwordController,
                label: 'New Password',
                hint: 'Enter your new password',
                obscureText: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 16),

              GlassTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Re-enter your new password',
                obscureText: true,
                icon: Icons.lock_outline,
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: errorColor,
                    fontSize: 13,
                  ),
                ),
              ],

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Reset Password'),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => context.go(AppRoutes.login),
                  child: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
