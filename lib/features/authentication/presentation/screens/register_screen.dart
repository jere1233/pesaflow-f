
///home/hp/JERE/pension-frontend/lib/features/authentication/presentation/screens/register_screen.dart
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
import '../../data/models/auth_response_model.dart';

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
  // Additional controllers for full registration payload
  final _dobController = TextEditingController();
  String? _genderValue;
  String? _maritalStatusValue;
  final _spouseNameController = TextEditingController();
  final _spouseDobController = TextEditingController();
  final List<ChildModel> _childrenList = [];
  final _nationalIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _occupationController = TextEditingController();
  final _employerController = TextEditingController();
  final _salaryController = TextEditingController();
  final _contributionController = TextEditingController();
  final _retirementController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _spouseNameController.dispose();
    _spouseDobController.dispose();
    _nationalIdController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _occupationController.dispose();
    _employerController.dispose();
    _salaryController.dispose();
    _contributionController.dispose();
    _retirementController.dispose();
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
      final registerRequest = RegisterRequestModel(
        email: _isEmail(emailOrPhone) ? emailOrPhone : '',
        password: _passwordController.text,
        phone: _isPhone(emailOrPhone) ? emailOrPhone : '',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: _dobController.text.isNotEmpty ? _dobController.text : null,
        gender: _genderValue,
        maritalStatus: _maritalStatusValue,
        spouseName: _spouseNameController.text.isNotEmpty ? _spouseNameController.text : null,
        spouseDob: _spouseDobController.text.isNotEmpty ? _spouseDobController.text : null,
        children: _childrenList.isNotEmpty ? List<ChildModel>.from(_childrenList) : null,
        nationalId: _nationalIdController.text.isNotEmpty ? _nationalIdController.text : null,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        city: _cityController.text.isNotEmpty ? _cityController.text : null,
        country: _countryController.text.isNotEmpty ? _countryController.text : null,
        occupation: _occupationController.text.isNotEmpty ? _occupationController.text : null,
        employer: _employerController.text.isNotEmpty ? _employerController.text : null,
        salary: _salaryController.text.isNotEmpty ? num.tryParse(_salaryController.text) : null,
        contributionRate: _contributionController.text.isNotEmpty ? num.tryParse(_contributionController.text) : null,
        retirementAge: _retirementController.text.isNotEmpty ? int.tryParse(_retirementController.text) : null,
      );

      final initiation = await authProvider.register(registerRequest);

      if (initiation.success && mounted) {
        Fluttertoast.showToast(
          msg: initiation.message ?? 'Payment initiated. Complete M-Pesa on your phone.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.success,
          textColor: Colors.white,
        );

        // If we have a transactionId, poll the status endpoint until completed
        if (initiation.transactionId != null && initiation.transactionId!.isNotEmpty) {
          _pollRegistrationStatus(initiation.transactionId!);
        } else {
          // No transaction id — just inform the user
          _showInfoDialog('Payment initiated', initiation.message ?? 'Please complete payment on your phone.');
        }
      } else if (mounted) {
        _showErrorDialog(authProvider.errorMessage ?? initiation.message ?? 'Registration initiation failed');
      }
    }
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
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

  void _pollRegistrationStatus(String transactionId) {
    final authProvider = context.read<AuthProvider>();
    // Show a progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Start polling when dialog shows
        Future.microtask(() async {
          const int maxAttempts = 24; // poll for up to 2 minutes (24 * 5s)
          int attempts = 0;

          while (attempts < maxAttempts) {
            attempts++;
            final completed = await authProvider.checkRegistrationStatus(transactionId);
            if (completed && mounted) {
              Navigator.of(context).pop(); // close dialog
              Fluttertoast.showToast(
                msg: 'Registration completed!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.success,
                textColor: Colors.white,
              );
              if (mounted) context.go(RouteNames.home);
              return;
            }

            // wait 5 seconds before next poll
            await Future.delayed(const Duration(seconds: 5));
          }

          // timed out
          if (mounted) {
            Navigator.of(context).pop();
            _showErrorDialog('Payment not confirmed yet. Please check your M-Pesa and try again later.');
          }
        });

        return AlertDialog(
          title: const Text('Waiting for payment confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Please approve the M-Pesa prompt on your phone.'),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Future<ChildModel?> _showAddChildDialog() async {
    final nameController = TextEditingController();
    final dobController = TextEditingController();
    ChildModel? result;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Child'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2015),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dobController.text = picked.toIso8601String().split('T').first;
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: dobController,
                    decoration: const InputDecoration(labelText: 'DOB (YYYY-MM-DD)'),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final dob = dobController.text.trim();
                if (name.isEmpty || dob.isEmpty) return;
                result = ChildModel(name: name, dob: dob);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    dobController.dispose();
    return result;
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
                              
                              const SizedBox(height: 16),

                              // Date of Birth
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(1990, 1, 1),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    _dobController.text = picked.toIso8601String().split('T').first;
                                    setState(() {});
                                  }
                                },
                                child: AbsorbPointer(
                                  child: CustomTextField(
                                    controller: _dobController,
                                    labelText: 'Date of Birth',
                                    hintText: 'YYYY-MM-DD',
                                    prefixIcon: Icons.cake_outlined,
                                    readOnly: true,
                                    validator: (value) {
                                      // optional
                                      return null;
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Gender & Marital Status
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _genderValue,
                                      items: const [
                                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: 'Gender',
                                      ),
                                      onChanged: (v) => setState(() => _genderValue = v),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _maritalStatusValue,
                                      items: const [
                                        DropdownMenuItem(value: 'Single', child: Text('Single')),
                                        DropdownMenuItem(value: 'Married', child: Text('Married')),
                                        DropdownMenuItem(value: 'Divorced', child: Text('Divorced')),
                                        DropdownMenuItem(value: 'Widowed', child: Text('Widowed')),
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: 'Marital Status',
                                      ),
                                      onChanged: (v) => setState(() => _maritalStatusValue = v),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Spouse fields (shown when married)
                              if (_maritalStatusValue == 'Married') ...[
                                CustomTextField(
                                  controller: _spouseNameController,
                                  labelText: 'Spouse Name',
                                  hintText: 'Enter spouse name',
                                  prefixIcon: Icons.person_outline,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => null,
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(1990, 1, 1),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      _spouseDobController.text = picked.toIso8601String().split('T').first;
                                      setState(() {});
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      controller: _spouseDobController,
                                      labelText: 'Spouse DOB',
                                      hintText: 'YYYY-MM-DD',
                                      prefixIcon: Icons.cake_outlined,
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // Children list
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text('Children', style: TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _childrenList.map((c) {
                                      return Chip(
                                        label: Text('${c.name} (${c.dob})'),
                                        onDeleted: () {
                                          setState(() => _childrenList.remove(c));
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        final child = await _showAddChildDialog();
                                        if (child != null) setState(() => _childrenList.add(child));
                                      },
                                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                                      label: const Text('Add Child', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              CustomTextField(
                                controller: _nationalIdController,
                                labelText: 'National ID',
                                hintText: 'Enter national ID',
                                prefixIcon: Icons.contact_mail_outlined,
                                textInputAction: TextInputAction.next,
                                validator: (value) => null,
                              ),

                              const SizedBox(height: 12),

                              CustomTextField(
                                controller: _addressController,
                                labelText: 'Address',
                                hintText: 'Enter your address',
                                prefixIcon: Icons.home_outlined,
                                textInputAction: TextInputAction.next,
                                maxLines: 2,
                                validator: (value) => null,
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _cityController,
                                      labelText: 'City',
                                      hintText: 'City',
                                      prefixIcon: Icons.location_city_outlined,
                                      validator: (v) => null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _countryController,
                                      labelText: 'Country',
                                      hintText: 'Country',
                                      prefixIcon: Icons.public_outlined,
                                      validator: (v) => null,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              CustomTextField(
                                controller: _occupationController,
                                labelText: 'Occupation',
                                hintText: 'Enter occupation',
                                prefixIcon: Icons.work_outline,
                                validator: (v) => null,
                              ),

                              const SizedBox(height: 12),

                              CustomTextField(
                                controller: _employerController,
                                labelText: 'Employer',
                                hintText: 'Enter employer',
                                prefixIcon: Icons.business_outlined,
                                validator: (v) => null,
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _salaryController,
                                      labelText: 'Salary',
                                      hintText: '0',
                                      prefixIcon: Icons.attach_money_outlined,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      validator: (v) => null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _contributionController,
                                      labelText: 'Contribution Rate (%)',
                                      hintText: '0',
                                      prefixIcon: Icons.trending_up_outlined,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))],
                                      validator: (v) => null,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              CustomTextField(
                                controller: _retirementController,
                                labelText: 'Retirement Age',
                                hintText: '0',
                                prefixIcon: Icons.calendar_today_outlined,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (v) => null,
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