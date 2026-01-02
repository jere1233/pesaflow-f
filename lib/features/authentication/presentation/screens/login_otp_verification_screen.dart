import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../widgets/custom_button.dart';
import '../widgets/password_text_field.dart';
import '../providers/auth_provider.dart';

class LoginOtpVerificationScreen extends StatefulWidget {
  final String identifier;
  final String verificationType;

  const LoginOtpVerificationScreen({
    super.key,
    required this.identifier,
    required this.verificationType,
  });

  @override
  State<LoginOtpVerificationScreen> createState() => _LoginOtpVerificationScreenState();
}

class _LoginOtpVerificationScreenState extends State<LoginOtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final _newPasswordController = TextEditingController();
  
  bool _showPasswordField = false;
  
  // Timer variables for resend OTP
  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _newPasswordController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });
    
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _handleResendOtp() async {
    if (!_canResend) return;

    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.resendOtp(widget.identifier);
    
    if (success && mounted) {
      Fluttertoast.showToast(
        msg: "OTP has been resent to ${widget.identifier}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.success,
        textColor: Colors.white,
      );
      
      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      
      // Restart timer
      _startResendTimer();
    } else if (mounted) {
      Fluttertoast.showToast(
        msg: authProvider.errorMessage ?? "Failed to resend OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      Fluttertoast.showToast(
        msg: "Please enter the complete OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    // If password field is shown, include new password
    final newPassword = _showPasswordField ? _newPasswordController.text : null;
    
    if (_showPasswordField && (newPassword == null || newPassword.length < 8)) {
      Fluttertoast.showToast(
        msg: "Password must be at least 8 characters",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    final success = await authProvider.verifyLoginOtp(otp, newPassword: newPassword);

    if (success && mounted) {
      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.success,
        textColor: Colors.white,
      );
      context.go(RouteNames.home);
    } else if (mounted) {
      // Check if we need to show password field
      if (authProvider.status == AuthStatus.tempPasswordRequired && !_showPasswordField) {
        setState(() {
          _showPasswordField = true;
        });
        Fluttertoast.showToast(
          msg: "Please set a permanent password to continue",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.info,
          textColor: Colors.white,
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verification Failed'),
            content: Text(authProvider.errorMessage ?? 'Invalid OTP'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? 40 : 24,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.email_outlined,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Title
                    Text(
                      _showPasswordField ? 'Set Your Password' : 'Verify Your Email',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    Text(
                      _showPasswordField
                          ? 'Enter the OTP and set a permanent password'
                          : 'Enter the 6-digit code sent to\n${widget.identifier}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 50,
                          height: 60,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(0),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    
                    // Show password field if needed
                    if (_showPasswordField) ...[
                      const SizedBox(height: 24),
                      PasswordTextField(
                        controller: _newPasswordController,
                        labelText: 'New Password',
                        hintText: 'Enter new password (min 8 characters)',
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                    
                    // Verify Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return CustomButton(
                          text: _showPasswordField ? 'Set Password & Login' : 'Verify',
                          onPressed: _handleVerifyOtp,
                          isLoading: authProvider.isLoading,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Resend OTP Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive the code? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return TextButton(
                              onPressed: _canResend && !authProvider.isLoading
                                  ? _handleResendOtp
                                  : null,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _canResend 
                                    ? 'Resend' 
                                    : 'Resend in ${_resendCountdown}s',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _canResend && !authProvider.isLoading
                                      ? AppColors.primary 
                                      : AppColors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
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