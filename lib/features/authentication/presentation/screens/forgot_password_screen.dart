import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.forgotPassword(
        _emailController.text.trim(),
      );

      if (success && mounted) {
        Fluttertoast.showToast(
          msg: "Password reset link sent to your email!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.success,
          textColor: Colors.white,
        );
        context.pop();
      } else if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(authProvider.errorMessage ?? 'Failed to send reset link'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Back Button - WHITE
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: screenHeight * 0.03),
                              
                              // Icon - WHITE BACKGROUND
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
                                    Icons.lock_reset_rounded,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Title - WHITE TEXT
                              Text(
                                'Forgot Password?',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Subtitle - WHITE TEXT
                              Text(
                                'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Email Field
                              CustomTextField(
                                controller: _emailController,
                                labelText: 'Email Address',
                                hintText: 'Enter your email',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleForgotPassword(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Reset Button
                              Consumer<AuthProvider>(
                                builder: (context, authProvider, _) {
                                  return CustomButton(
                                    text: 'Send Reset Link',
                                    onPressed: _handleForgotPassword,
                                    isLoading: authProvider.isLoading,
                                    backgroundColor: Colors.white,
                                    textColor: AppColors.primary,
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Back to Login - WHITE TEXT
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}