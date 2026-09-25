/*
@Author - yehenSamarasinghe
@Date - 2026/09/16
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/core/token_storage.dart';
import '../../../../services/providers/auth_provider.dart';
import '../../../../themes/utils.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();

  Timer? _timer;
  int _secondsRemaining = 600;
  bool _isLoading = false;
  bool _isResending = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = 600;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();

        if (mounted) {
          setState(() {
            _secondsRemaining = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6 || int.tryParse(otp) == null) {
      setState(() {
        _errorMessage = 'Please enter the 6-digit OTP.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ref.read(verifyOtpProvider({
        'email': widget.email,
        'otp': otp,
        }).future,
);

      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token received.');
      }

      await TokenStorage.saveToken(token);

      if (!mounted) return;

      context.go(AppRoutes.dashboard);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Invalid or expired OTP. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending || _secondsRemaining > 0) {
      return;
    }

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      await ref.read(resendOtpProvider(widget.email).future);

      if (!mounted) return;

      _otpController.clear();
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new OTP has been sent to your email.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Could not resend OTP. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceCards,
                    borderRadius: BorderRadius.circular(kCardRadius),
                    border: Border.all(color: glossOutline),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/aixx_logo.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Verify Your Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: onSurfaceColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'We sent a 6-digit verification code to',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: mutedTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: actionHighlight,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 10,
                          color: onSurfaceColor,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '••••••',
                          hintStyle: TextStyle(
                            color: mutedTextColor.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: canvasBase,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kCardRadius),
                            borderSide: BorderSide(color: glossOutline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kCardRadius),
                            borderSide: BorderSide(color: glossOutline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kCardRadius),
                            borderSide: BorderSide(
                              color: actionHighlight,
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() {
                              _errorMessage = null;
                            });
                          }
                        },
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: errorColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Text(
                        _secondsRemaining > 0
                            ? 'Code expires in $_formattedTime'
                            : 'Code expired',
                        style: TextStyle(
                          fontSize: 13,
                          color: mutedTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: actionHighlight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kCardRadius),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Verify Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed:
                            (_secondsRemaining > 0 || _isResending)
                                ? null
                                : _resendOtp,
                        child: _isResending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Resend OTP'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => context.go(AppRoutes.auth),
                        child: const Text('Back to Registration'),
                      ),
                    ],
                  ),
                ),
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
          colors: [color, color.withOpacity(0)],
        ),
      ),
    );
  }
}