/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../themes/utils.dart';
import '../../../../widgets/glass_dropdown.dart';
import '../../../../widgets/glass_text_field.dart';
import '../../../../widgets/mobile_number_field.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _language = 'english';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            child: _glow(actionHighlight.withOpacity(0.2), 280),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: _glow(successColor.withOpacity(0.1), 280),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                children: [
                  Image.asset('assets/images/aixx_logo.png', width: 120, height: 120),
                  const SizedBox(height: 8),
                  Text(
                    'Secure Gateway Authentication',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: mutedTextColor),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: surfaceCards,
                      borderRadius: BorderRadius.circular(kCardRadius),
                      border: Border.all(color: glossOutline),
                    ),
                    child: Column(
                      children: [
                        GlassTextField(
                          label: 'Full Name',
                          hint: 'Jane Doe',
                          icon: Icons.person_outline,
                          controller: _fullNameController,
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          label: 'Business Email',
                          hint: 'jane@company.com',
                          icon: Icons.mail_outline,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        MobileNumberField(controller: _mobileController),
                        const SizedBox(height: 16),
                        GlassDropdown<String>(
                          label: 'Preferred Language',
                          icon: Icons.language,
                          value: _language,
                          items: const [
                            GlassDropdownItem(value: 'english', label: 'English'),
                            GlassDropdownItem(value: 'mandarin', label: 'Mandarin'),
                            GlassDropdownItem(value: 'malay', label: 'Malay'),
                            GlassDropdownItem(value: 'hindi', label: 'Hindi'),
                            GlassDropdownItem(value: 'tamil', label: 'Tamil'),
                          ],
                          onChanged: (val) => setState(() => _language = val!),
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          label: 'Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          label: 'Confirm Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          controller: _confirmPasswordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go(AppRoutes.dashboard);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: actionHighlight,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kCardRadius),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Continue to Workspace',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(color: glossOutline),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14, color: mutedTextColor),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: actionHighlight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "By continuing, you agree to AIXX's Terms of Service & Privacy Policy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: mutedTextColor),
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
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }
}