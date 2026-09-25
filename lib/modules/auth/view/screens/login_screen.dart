import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/core/token_storage.dart';
import '../../../../services/providers/auth_provider.dart';
import '../../../../themes/utils.dart';
import '../../../../validation/validators/auth_validators.dart';
import '../../../../widgets/glass_text_field.dart';
import '../../model/login_request.dart';

/// Login — matches POST /auth/login.
///
/// On success:
/// - Saves the authentication token.
/// - Navigates to Dashboard.
///
/// On a 403 `requires_verification` response:
/// - Redirects the user to the OTP verification screen.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: errorColor,
      ),
    );
  }

  Future<void> _submit() async {
    final emailError =
        AuthValidators.validateEmail(_emailController.text);

    final passwordError = _passwordController.text.isEmpty
        ? 'Please enter your password'
        : null;

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    final firstError = emailError ?? passwordError;

    if (firstError != null) {
      _showError(firstError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final data = await ref.read(loginProvider(request).future);

      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token received.');
      }

      await TokenStorage.saveToken(token);

      if (!mounted) return;

      context.go(AppRoutes.dashboard);
    } on DioException catch (e) {
      if (!mounted) return;

      final responseData = e.response?.data;

      final requiresVerification =
          e.response?.statusCode == 403 &&
          responseData is Map &&
          responseData['requires_verification'] == true;

      if (requiresVerification) {
        final email =
            responseData['email'] as String? ??
            _emailController.text.trim();

        _showError('Please verify your email first.');

        context.push(
          AppRoutes.otp,
          extra: email,
        );
      } else {
        final message = e.response?.data is Map
            ? (e.response?.data['message'] as String? ??
                'Login failed.')
            : 'Login failed. Please check your credentials.';

        _showError(message);
      }
    } catch (error) {
      if (!mounted) return;

      _showError('Login failed: $error');
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
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _glow(
              actionHighlight.withOpacity(0.2),
              280,
            ),
          ),

          Positioned(
            bottom: -120,
            right: -80,
            child: _glow(
              successColor.withOpacity(0.1),
              280,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 32,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/aixx_logo.png',
                    width: 120,
                    height: 120,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: mutedTextColor,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: surfaceCards,
                      borderRadius:
                          BorderRadius.circular(kCardRadius),
                      border: Border.all(
                        color: glossOutline,
                      ),
                    ),
                    child: Column(
                      children: [
                        GlassTextField(
                          label: 'Email',
                          hint: 'jane@company.com',
                          icon: Icons.mail_outline,
                          controller: _emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              _emailError =
                                  AuthValidators.validateEmail(value);
                            });
                          },
                          errorText: _emailError,
                        ),

                        const SizedBox(height: 16),

                        GlassTextField(
                          label: 'Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _passwordError = value.isEmpty
                                  ? 'Please enter your password'
                                  : null;
                            });
                          },
                          errorText: _passwordError,
                        ),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => context.push(AppRoutes.forgotPassword),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: actionHighlight,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: actionHighlight,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  kCardRadius,
                                ),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Divider(
                          color: glossOutline,
                        ),

                        const SizedBox(height: 12),

                        InkWell(
                          onTap: () => context.go(AppRoutes.auth),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: mutedTextColor,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "Don't have an account? ",
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: actionHighlight,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0),
          ],
        ),
      ),
    );
  }
}