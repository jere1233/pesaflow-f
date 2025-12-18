import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/link_text.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  bool _isPhone(String value) {
    return RegExp(r'^0[0-9]{9}$').hasMatch(value);
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final emailOrPhone = _emailOrPhoneController.text.trim();
      
      final success = await authProvider.register(
        email: _isEmail(emailOrPhone) ? emailOrPhone : '',
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _isPhone(emailOrPhone) ? emailOrPhone : '',
      );

      if (success && mounted) {
        Fluttertoast.showToast(
          msg: "Registration successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.success,
          textColor: Colors.white,
        );
        
        if (_isPhone(emailOrPhone)) {
          context.push(
            RouteNames.otpVerification,
            extra: {
              'phoneNumber': emailOrPhone,
              'verificationType': 'register',
            },
          );
        } else {
          context.go(RouteNames.home);
        }
      } else if (mounted) {
        _showErrorDialog(authProvider.errorMessage ?? 'Registration failed');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Failed'),
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
                              SizedBox(height: screenHeight * 0.02),
                              
                              const AuthHeader(
                                title: 'Create Account',
                                subtitle: 'Sign up to start managing your pension',
                              ),
                              
                              const SizedBox(height: 32),
                              
                              CustomTextField(
                                controller: _firstNameController,
                                labelText: 'First Name',
                                hintText: 'Enter your first name',
                                prefixIcon: Icons.person_outline,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  if (value.length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 16),
                              
                              CustomTextField(
                                controller: _lastNameController,
                                labelText: 'Last Name',
                                hintText: 'Enter your last name',
                                prefixIcon: Icons.person_outline,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  if (value.length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Combined Email or Phone Field
                              CustomTextField(
                                controller: _emailOrPhoneController,
                                labelText: 'Email or Phone',
                                hintText: 'Enter email or phone (07XXXXXXXX)',
                                prefixIcon: Icons.alternate_email,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email or phone number';
                                  }
                                  
                                  final isEmail = _isEmail(value);
                                  final isPhone = _isPhone(value);
                                  
                                  if (!isEmail && !isPhone) {
                                    return 'Enter a valid email or phone (07XXXXXXXX)';
                                  }
                                  
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 16),
                              
                              PasswordTextField(
                                controller: _passwordController,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleRegister(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (!value.contains(RegExp(r'[A-Z]'))) {
                                    return 'Password must contain at least one uppercase letter';
                                  }
                                  if (!value.contains(RegExp(r'[0-9]'))) {
                                    return 'Password must contain at least one number';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              Consumer<AuthProvider>(
                                builder: (context, authProvider, _) {
                                  return CustomButton(
                                    text: 'Create Account',
                                    onPressed: _handleRegister,
                                    isLoading: authProvider.isLoading,
                                    backgroundColor: Colors.white,
                                    textColor: AppColors.primary,
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              LinkText(
                                normalText: 'Already have an account? ',
                                linkText: 'Login',
                                onTap: () => context.pop(),
                                normalTextColor: Colors.white,
                                linkTextColor: Colors.white,
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