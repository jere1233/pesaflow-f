import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';

// ============================================================================
// 🚀 UNIFIED OTP VERIFICATION - Supports BOTH Email and Phone
// ============================================================================
class OtpVerificationScreen extends StatefulWidget {
  final String identifier; // Can be email OR phone number
  final String verificationType;

  const OtpVerificationScreen({
    super.key,
    required this.identifier,
    required this.verificationType,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  int _resendCountdown = 60;
  Timer? _timer;
  bool _canResend = false;

  // Detect if identifier is email or phone
  bool get _isEmail => widget.identifier.contains('@');
  String get _identifierType => _isEmail ? 'email' : 'phone';
  IconData get _identifierIcon => _isEmail ? Icons.email_outlined : Icons.sms_outlined;
  String get _identifierLabel => _isEmail ? 'Email' : 'Number';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _resendCountdown = 60;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    
    // Use unified OTP verification (works for both email and phone)
    final success = await authProvider.verifyOtp(
      widget.identifier,
      otp,
      widget.verificationType,
    );

    if (success && mounted) {
      Fluttertoast.showToast(
        msg: "Verification successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.success,
        textColor: Colors.white,
      );
      
      context.go(RouteNames.home);
    } else if (mounted) {
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

  Future<void> _handleResendOtp() async {
    if (!_canResend) return;

    final authProvider = context.read<AuthProvider>();
    
    // Use unified send OTP (works for both email and phone)
    final success = await authProvider.sendOtp(widget.identifier);

    if (success && mounted) {
      Fluttertoast.showToast(
        msg: "OTP sent to your $_identifierLabel!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.success,
        textColor: Colors.white,
      );
      _startCountdown();
      
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    } else if (mounted) {
      Fluttertoast.showToast(
        msg: authProvider.errorMessage ?? "Failed to send OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.error,
        textColor: Colors.white,
      );
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
                    
                    // Icon - Dynamic based on email or phone
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _identifierIcon,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Title - Dynamic based on email or phone
                    Text(
                      'Verify Your $_identifierLabel',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle showing identifier
                    Text(
                      'Enter the 6-digit code sent to\n${widget.identifier}',
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
                              
                              // Auto-verify when all 6 digits entered
                              if (index == 5 && value.isNotEmpty) {
                                _handleVerifyOtp();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Verify Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return CustomButton(
                          text: 'Verify',
                          onPressed: _handleVerifyOtp,
                          isLoading: authProvider.isLoading,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Resend OTP
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
                        TextButton(
                          onPressed: _canResend ? _handleResendOtp : null,
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
                              color: _canResend 
                                  ? AppColors.primary 
                                  : AppColors.textSecondary,
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
    );
  }
}