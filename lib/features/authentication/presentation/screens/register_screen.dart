///home/hp/JERE/AutoNest-frontend/lib/features/authentication/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_text_field.dart';
import '../widgets/pin_text_field.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/numeric_text_field.dart';
import '../widgets/children_input_widget.dart';
import '../widgets/bank_details_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/step_indicator.dart';
import '../widgets/link_text.dart';
import '../widgets/terms_acceptance_checkbox.dart';
import '../widgets/country_dropdown_field.dart'; 
import '../providers/auth_provider.dart';
import '../../data/models/register_request_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKeys = List.generate(6, (_) => GlobalKey<FormState>());
  int _currentStep = 0;
  
  // Step 1: Account Credentials
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  
  // Step 2: Personal Details
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
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
  String? _country = 'Kenya';
  final _occupationController = TextEditingController();
  final _employerController = TextEditingController();
  
  // Step 5: Financial & Bank Details
  final _salaryController = TextEditingController();
  String? _contributionRate;
  final _retirementAgeController = TextEditingController();
  
  // Bank account details
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankBranchNameController = TextEditingController();
  final _bankBranchCodeController = TextEditingController();
  
  // Pension settings
  String _accountType = 'MANDATORY';
  String _riskProfile = 'MEDIUM';

  // Terms and Conditions acceptance
  bool _acceptedTerms = false;
  String? _termsError;

  final List<String> _stepLabels = [
    'Account',
    'Personal',
    'Family',
    'Employment',
    'Financial',
    'Bank & Terms',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchTermsAndConditions();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _nationalIdController.dispose();
    _spouseNameController.dispose();
    _spouseDobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _occupationController.dispose();
    _employerController.dispose();
    _salaryController.dispose();
    _retirementAgeController.dispose();
    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();
    _bankBranchNameController.dispose();
    _bankBranchCodeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 5) {
        setState(() => _currentStep++);
      } else {
        if (!_acceptedTerms) {
          setState(() {
            _termsError = 'You must accept the Terms and Conditions to continue';
          });
          return;
        }
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

  void _handleTermsTap() {
    final authProvider = context.read<AuthProvider>();
    final terms = authProvider.termsAndConditions;

    if (terms != null && terms.body.isNotEmpty) {
      context.push(
        RouteNames.termsAndConditions,
        extra: {
          'htmlContent': terms.body,
          'showAcceptButton': false,
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: "Loading Terms and Conditions...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.info,
        textColor: Colors.white,
      );
      
      authProvider.fetchTermsAndConditions().then((success) {
        if (success && mounted) {
          _handleTermsTap();
        }
      });
    }
  }

  Future<void> _handleRegister() async {
    final authProvider = context.read<AuthProvider>();
    
    final request = RegisterRequestModel(
      // Account credentials (REQUIRED)
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      pin: _pinController.text.trim(),
      
      // Bank account details (REQUIRED)
      bankAccountName: _bankAccountNameController.text.trim(),
      bankAccountNumber: _bankAccountNumberController.text.trim(),
      bankBranchName: _bankBranchNameController.text.trim(),
      bankBranchCode: _bankBranchCodeController.text.trim(),
      
      // Personal Details
      firstName: _firstNameController.text.isNotEmpty 
          ? _firstNameController.text.trim() 
          : null,
      lastName: _lastNameController.text.isNotEmpty 
          ? _lastNameController.text.trim() 
          : null,
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
      country: _country,
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
      contributionRate: _contributionRate != null 
          ? num.tryParse(_contributionRate!) 
          : null,
      retirementAge: _retirementAgeController.text.isNotEmpty 
          ? int.tryParse(_retirementAgeController.text) 
          : null,
      
      // Account Configuration
      accountType: _accountType,
      riskProfile: _riskProfile,
      currency: 'KES',
      accountStatus: 'ACTIVE',
      kycVerified: false,
      complianceStatus: 'PENDING',
    );

    final initiation = await authProvider.register(request);

    if (initiation.success && mounted) {
      final transactionId = initiation.transactionId ?? authProvider.registrationTransactionId;

      Fluttertoast.showToast(
        msg: initiation.message ?? 'Registration initiated! Please complete M-Pesa payment.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.info,
        textColor: Colors.white,
      );

      if (transactionId != null && transactionId.isNotEmpty) {
        context.go('${RouteNames.paymentStatus}/$transactionId');
      } else {
        context.go(RouteNames.home);
      }
    } else if (mounted) {
      _showErrorDialog(authProvider.errorMessage ?? initiation.message ?? 'Registration failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                            onPressed: _previousStep,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    StepIndicator(
                      currentStep: _currentStep,
                      totalSteps: 6,
                      stepLabels: _stepLabels,
                    ),
                  ],
                ),
              ),
              
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
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: _buildCurrentStep(),
                          ),
                          
                          const SizedBox(height: 28),
                          _buildNavigationButtons(),
                          
                          if (_currentStep == 0) ...[
                            const SizedBox(height: 24),
                            LinkText(
                              normalText: 'Already have an account? ',
                              linkText: 'Login',
                              onTap: () => context.pop(),
                              normalTextColor: Colors.white.withOpacity(0.9),
                              linkTextColor: AppColors.highlightGold,
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
        return _buildStep1AccountCredentials();
      case 1:
        return _buildStep2PersonalDetails();
      case 2:
        return _buildStep3FamilyInfo();
      case 3:
        return _buildStep4AddressEmployment();
      case 4:
        return _buildStep5FinancialInfo();
      case 5:
        return _buildStep6BankAndTerms();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1AccountCredentials() {
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
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Set up your account credentials',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.85),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
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
            labelText: 'Phone Number (M-Pesa)',
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
          
          PinTextField(
            controller: _pinController,
            labelText: '4-Digit PIN',
            hintText: '****',
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a PIN';
              }
              if (value.length != 4) {
                return 'PIN must be exactly 4 digits';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.highlightGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.highlightGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.highlightGold,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'A temporary password will be sent to your email and phone after payment',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Tell us more about yourself',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.85),
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
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _lastNameController,
            labelText: 'Last Name',
            hintText: 'Enter your last name',
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 16),
          
          DatePickerField(
            controller: _dateOfBirthController,
            labelText: 'Date of Birth',
            hintText: 'Select your date of birth',
            prefixIcon: Icons.cake_outlined,
            lastDate: DateTime.now().subtract(const Duration(days: 6570)),
            initialDate: DateTime.now().subtract(const Duration(days: 9125)),
          ),
          
          const SizedBox(height: 16),
          
          DropdownField(
            value: _gender,
            labelText: 'Gender',
            hintText: 'Select gender',
            prefixIcon: Icons.wc_outlined,
            items: const ['Male', 'Female', 'Other'],
            onChanged: (value) => setState(() => _gender = value),
          ),
          
          const SizedBox(height: 16),
          
          DropdownField(
            value: _maritalStatus,
            labelText: 'Marital Status',
            hintText: 'Select marital status',
            prefixIcon: Icons.favorite_outline,
            items: const ['Single', 'Married', 'Divorced', 'Widowed'],
            onChanged: (value) => setState(() => _maritalStatus = value),
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _nationalIdController,
            labelText: 'National ID',
            hintText: 'Enter your national ID',
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

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
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Add your family details (optional)',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.85),
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
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Where do you live and work?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.85),
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
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _cityController,
            labelText: 'City',
            hintText: 'Enter your city',
            prefixIcon: Icons.location_city_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 16),
          
          CountryDropdownField(
            value: _country,
            labelText: 'Country',
            hintText: 'Select your country',
            prefixIcon: Icons.flag_outlined,
            onChanged: (value) => setState(() => _country = value),
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _occupationController,
            labelText: 'Occupation',
            hintText: 'Enter your occupation',
            prefixIcon: Icons.work_outline,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _employerController,
            labelText: 'Employer',
            hintText: 'Enter your employer',
            prefixIcon: Icons.business_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

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
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Tell us about your finances',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.85),
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
          ),
          
          const SizedBox(height: 16),
          
          DropdownField(
            value: _contributionRate,
            labelText: 'Contribution Rate',
            hintText: 'Select contribution rate',
            prefixIcon: Icons.percent_outlined,
            items: const ['2', '5', '10', '15', '20'],
            onChanged: (value) => setState(() => _contributionRate = value),
            displaySuffix: '%',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a contribution rate';
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
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 16),
          
          DropdownField(
            value: _accountType,
            labelText: 'Account Type',
            hintText: 'Select account type',
            prefixIcon: Icons.account_balance_wallet_outlined,
            items: const ['MANDATORY', 'VOLUNTARY', 'INDIVIDUAL'],
            onChanged: (value) => setState(() => _accountType = value!),
          ),
          
          const SizedBox(height: 16),
          
          DropdownField(
            value: _riskProfile,
            labelText: 'Risk Profile',
            hintText: 'Select risk profile',
            prefixIcon: Icons.trending_up_outlined,
            items: const ['LOW', 'MEDIUM', 'HIGH'],
            onChanged: (value) => setState(() => _riskProfile = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildStep6BankAndTerms() {
    return Form(
      key: _formKeys[5],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Bank & Terms',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Final step - bank details and acceptance',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          BankDetailsWidget(
            accountNameController: _bankAccountNameController,
            accountNumberController: _bankAccountNumberController,
            branchNameController: _bankBranchNameController,
            branchCodeController: _bankBranchCodeController,
          ),
          
          const SizedBox(height: 24),
          
          TermsAcceptanceCheckbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
                if (_acceptedTerms) {
                  _termsError = null;
                }
              });
            },
            onTermsTap: _handleTermsTap,
            errorText: _termsError,
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.highlightGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.highlightGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.highlightGold,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Upon registration, you\'ll receive an M-Pesa prompt to pay 1 KES. After successful payment, a temporary password will be sent to your email and phone.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.95),
                    height: 1.5,
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
                  backgroundColor: Colors.white.withOpacity(0.3),
                  textColor: Colors.white,
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: CustomButton(
                text: _currentStep < 5 ? 'Next' : 'Complete Registration',
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