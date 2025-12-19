import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_text_field.dart';
import '../widgets/phone_text_field.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/numeric_text_field.dart';
import '../widgets/children_input_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/step_indicator.dart';
import '../widgets/link_text.dart';
import '../providers/auth_provider.dart';
import '../../data/models/auth_response_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKeys = List.generate(5, (_) => GlobalKey<FormState>());
  int _currentStep = 0;
  
  // Step 1: Basic Info
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Step 2: Personal Details
  final _dateOfBirthController = TextEditingController();
  String? _gender;
  String? _maritalStatus;
  final _nationalIdController = TextEditingController();
  
  // Step 3: Family Info
  final _spouseNameController = TextEditingController();
  final _spouseDobController = TextEditingController();
  List<ChildModel> _children = [];
  
  // Step 4: Address & Employment
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _occupationController = TextEditingController();
  final _employerController = TextEditingController();
  
  // Step 5: Financial Info
  final _salaryController = TextEditingController();
  final _contributionRateController = TextEditingController();
  final _retirementAgeController = TextEditingController();

  final List<String> _stepLabels = [
    'Basic Info',
    'Personal Details',
    'Family Info',
    'Employment',
    'Financial',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _dateOfBirthController.dispose();
    _nationalIdController.dispose();
    _spouseNameController.dispose();
    _spouseDobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _occupationController.dispose();
    _employerController.dispose();
    _salaryController.dispose();
    _contributionRateController.dispose();
    _retirementAgeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 4) {
        setState(() => _currentStep++);
      } else {
        _handleRegister();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  Future<void> _handleRegister() async {
    final authProvider = context.read<AuthProvider>();
    
    final request = RegisterRequestModel(
      // Basic Info
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      
      // Personal Details
      dateOfBirth: _dateOfBirthController.text.isNotEmpty 
          ? _dateOfBirthController.text 
          : null,
      gender: _gender,
      maritalStatus: _maritalStatus,
      nationalId: _nationalIdController.text.isNotEmpty 
          ? _nationalIdController.text.trim() 
          : null,
      
      // Family Info
      spouseName: _spouseNameController.text.isNotEmpty 
          ? _spouseNameController.text.trim() 
          : null,
      spouseDob: _spouseDobController.text.isNotEmpty 
          ? _spouseDobController.text 
          : null,
      children: _children.isNotEmpty ? _children : null,
      
      // Address & Employment
      address: _addressController.text.isNotEmpty 
          ? _addressController.text.trim() 
          : null,
      city: _cityController.text.isNotEmpty 
          ? _cityController.text.trim() 
          : null,
      country: _countryController.text.isNotEmpty 
          ? _countryController.text.trim() 
          : null,
      occupation: _occupationController.text.isNotEmpty 
          ? _occupationController.text.trim() 
          : null,
      employer: _employerController.text.isNotEmpty 
          ? _employerController.text.trim() 
          : null,
      
      // Financial Info
      salary: _salaryController.text.isNotEmpty 
          ? num.tryParse(_salaryController.text) 
          : null,
      contributionRate: _contributionRateController.text.isNotEmpty 
          ? num.tryParse(_contributionRateController.text) 
          : null,
      retirementAge: _retirementAgeController.text.isNotEmpty 
          ? int.tryParse(_retirementAgeController.text) 
          : null,
    );

    final success = await authProvider.register(request);

    if (success && mounted) {
      Fluttertoast.showToast(
        msg: "Registration initiated! Please complete M-Pesa payment.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.info,
        textColor: Colors.white,
      );
      
      // Navigate to payment status screen or home
      context.go(RouteNames.home);
    } else if (mounted) {
      _showErrorDialog(authProvider.errorMessage ?? 'Registration failed');
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
              // Back Button & Progress
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: _previousStep,
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StepIndicator(
                      currentStep: _currentStep,
                      totalSteps: 5,
                      stepLabels: _stepLabels,
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
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
                        children: [
                          _buildCurrentStep(),
                          const SizedBox(height: 32),
                          _buildNavigationButtons(),
                          if (_currentStep == 0) ...[
                            const SizedBox(height: 24),
                            LinkText(
                              normalText: 'Already have an account? ',
                              linkText: 'Login',
                              onTap: () => context.pop(),
                              normalTextColor: Colors.white,
                              linkTextColor: Colors.white,
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
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

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2PersonalDetails();
      case 2:
        return _buildStep3FamilyInfo();
      case 3:
        return _buildStep4AddressEmployment();
      case 4:
        return _buildStep5FinancialInfo();
      default:
        return const SizedBox();
    }
  }

  // Step 1: Basic Info
  Widget _buildStep1BasicInfo() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Let\'s get started with your basic information',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
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
          
          CustomTextField(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
          
          const SizedBox(height: 16),
          
          PhoneTextField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: '+254712345678',
            textInputAction: TextInputAction.next,
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
          
          const SizedBox(height: 16),
          
          PasswordTextField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
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
        ],
      ),
    );
  }

  // Step 2: Personal Details
  Widget _buildStep2PersonalDetails() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Tell us more about yourself',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          DatePickerField(
            controller: _dateOfBirthController,
            labelText: 'Date of Birth',
            hintText: 'Select your date of birth',
            prefixIcon: Icons.cake_outlined,
            lastDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
            initialDate: DateTime.now().subtract(const Duration(days: 9125)), // 25 years ago
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your date of birth';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          DropdownField(
            value: _gender,
            labelText: 'Gender',
            hintText: 'Select gender',
            prefixIcon: Icons.wc_outlined,
            items: const ['Male', 'Female', 'Other'],
            onChanged: (value) => setState(() => _gender = value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          DropdownField(
            value: _maritalStatus,
            labelText: 'Marital Status',
            hintText: 'Select marital status',
            prefixIcon: Icons.favorite_outline,
            items: const ['Single', 'Married', 'Divorced', 'Widowed'],
            onChanged: (value) => setState(() => _maritalStatus = value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your marital status';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _nationalIdController,
            labelText: 'National ID',
            hintText: 'Enter your national ID',
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your national ID';
              }
              if (value.length < 7) {
                return 'Please enter a valid national ID';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Step 3: Family Info
  Widget _buildStep3FamilyInfo() {
    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Family Information',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Add your family details (optional)',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          if (_maritalStatus == 'Married') ...[
            CustomTextField(
              controller: _spouseNameController,
              labelText: 'Spouse Name',
              hintText: 'Enter spouse name',
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            
            const SizedBox(height: 16),
            
            DatePickerField(
              controller: _spouseDobController,
              labelText: 'Spouse Date of Birth',
              hintText: 'Select date',
              prefixIcon: Icons.cake_outlined,
              lastDate: DateTime.now(),
            ),
            
            const SizedBox(height: 24),
          ],
          
          ChildrenInputWidget(
            children: _children,
            onChildrenChanged: (children) {
              setState(() => _children = children);
            },
          ),
        ],
      ),
    );
  }

  // Step 4: Address & Employment
  Widget _buildStep4AddressEmployment() {
    return Form(
      key: _formKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Address & Employment',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Where do you live and work?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          CustomTextField(
            controller: _addressController,
            labelText: 'Address',
            hintText: 'Enter your address',
            prefixIcon: Icons.home_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _cityController,
            labelText: 'City',
            hintText: 'Enter your city',
            prefixIcon: Icons.location_city_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _countryController,
            labelText: 'Country',
            hintText: 'Enter your country',
            prefixIcon: Icons.flag_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your country';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _occupationController,
            labelText: 'Occupation',
            hintText: 'Enter your occupation',
            prefixIcon: Icons.work_outline,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your occupation';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _employerController,
            labelText: 'Employer',
            hintText: 'Enter your employer',
            prefixIcon: Icons.business_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your employer';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Step 5: Financial Info
  Widget _buildStep5FinancialInfo() {
    return Form(
      key: _formKeys[4],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Financial Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Final step - tell us about your finances',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          NumericTextField(
            controller: _salaryController,
            labelText: 'Monthly Salary',
            hintText: 'Enter your monthly salary',
            prefixIcon: Icons.attach_money,
            prefixText: 'KES ',
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your salary';
              }
              final salary = num.tryParse(value);
              if (salary == null || salary <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          NumericTextField(
            controller: _contributionRateController,
            labelText: 'Contribution Rate',
            hintText: 'Enter contribution rate',
            prefixIcon: Icons.percent_outlined,
            suffixText: '%',
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter contribution rate';
              }
              final rate = num.tryParse(value);
              if (rate == null || rate <= 0 || rate > 100) {
                return 'Enter valid percentage (1-100)';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          NumericTextField(
            controller: _retirementAgeController,
            labelText: 'Retirement Age',
            hintText: 'Enter planned retirement age',
            prefixIcon: Icons.calendar_today_outlined,
            suffixText: 'years',
            allowDecimal: false,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter retirement age';
              }
              final age = int.tryParse(value);
              if (age == null || age < 50 || age > 75) {
                return 'Enter age between 50 and 75';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Upon registration, you\'ll receive an M-Pesa prompt to pay the registration fee.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: CustomButton(
                  text: 'Back',
                  onPressed: authProvider.isLoading ? null : _previousStep,
                  buttonType: ButtonType.outline,
                  backgroundColor: Colors.white,
                  textColor: Colors.white,
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: CustomButton(
                text: _currentStep < 4 ? 'Next' : 'Complete Registration',
                onPressed: _nextStep,
                isLoading: authProvider.isLoading,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}