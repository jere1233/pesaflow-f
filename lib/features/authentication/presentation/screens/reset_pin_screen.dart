///home/hp/JERE/pension-frontend/lib/features/authentication/presentation/screens/reset_pin_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_text_field.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class ResetPinScreen extends StatefulWidget {
  const ResetPinScreen({super.key});

  @override
  State<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (_phoneFormKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.resetPin(
        _phoneController.text.trim(),
      );

      if (success && mounted) {
        setState(() => _otpSent = true);
        Fluttertoast.showToast(
          msg: "OTP sent to your phone via SMS!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.info,
          textColor: Colors.white,
        );
      } else if (mounted) {
        _showErrorDialog(authProvider.errorMessage ?? 'Failed to send OTP');
      }
    }
  }

  Future<void> _handleResetPin() async {
    if (_otpFormKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.resetPinVerify(
        phone: _phoneController.text.trim(),
        otp: _otpController.text.trim(),
        newPin: _newPinController.text,
      );

      if (success && mounted) {
        Fluttertoast.showToast(
          msg: "PIN reset successfully! You can now login with your new PIN.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.success,
          textColor: Colors.white,
        );
        context.go(RouteNames.login);
      } else if (mounted) {
        _showErrorDialog(authProvider.errorMessage ?? 'Failed to reset PIN');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
              
              // Content
              Expanded(
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.pin_outlined,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Title
                            Text(
                              _otpSent ? 'Reset PIN' : 'Forgot PIN?',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 28,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Subtitle
                            Text(
                              _otpSent
                                  ? 'Enter the OTP sent to your phone via SMS and your new 4-digit PIN'
                                  : 'Enter your phone number and we\'ll send you an OTP via SMS to reset your PIN',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Form
                            if (!_otpSent)
                              _buildPhoneForm()
                            else
                              _buildOtpForm(),
                            
                            const SizedBox(height: 24),
                            
                            // Back to Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_back,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: () => context.pop(),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Back to Login',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneForm() {
    return Form(
      key: _phoneFormKey,
      child: Column(
        children: [
          PhoneTextField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: '+254712345678',
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSendOtp(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp(r'^\+254[17]\d{8}$').hasMatch(value)) {
                return 'Enter valid Kenyan number (+254...)';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 32),
          
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return CustomButton(
                text: 'Send OTP',
                onPressed: _handleSendOtp,
                isLoading: authProvider.isLoading,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpForm() {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _otpController,
            labelText: 'OTP Code',
            hintText: 'Enter 6-digit OTP',
            prefixIcon: Icons.lock_outline,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter OTP';
              }
              if (value.length != 6) {
                return 'OTP must be 6 digits';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _newPinController,
            labelText: 'New PIN',
            hintText: 'Enter new 4-digit PIN',
            prefixIcon: Icons.pin_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLength: 4,
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new PIN';
              }
              if (value.length != 4) {
                return 'PIN must be 4 digits';
              }
              if (value == '0000' || value == '1234' || value == '1111') {
                return 'Please choose a more secure PIN';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _confirmPinController,
            labelText: 'Confirm PIN',
            hintText: 'Re-enter new PIN',
            prefixIcon: Icons.pin_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 4,
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onFieldSubmitted: (_) => _handleResetPin(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm PIN';
              }
              if (value != _newPinController.text) {
                return 'PINs do not match';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 32),
          
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return CustomButton(
                text: 'Reset PIN',
                onPressed: _handleResetPin,
                isLoading: authProvider.isLoading,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Resend OTP
          TextButton(
            onPressed: () {
              setState(() => _otpSent = false);
              _otpController.clear();
            },
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}