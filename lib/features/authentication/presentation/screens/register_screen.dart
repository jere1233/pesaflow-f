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
import '../widgets/terms_acceptance_checkbox.dart';
import '../widgets/country_dropdown_field.dart';
import '../providers/auth_provider.dart';
import '../../data/models/register_request_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
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
  
  // Step 5: Financial Info
  final _salaryController = TextEditingController();
  String? _contributionRate;
  final _retirementAgeController = TextEditingController();
  
  // Bank account details
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankBranchNameController = TextEditingController();
  final _bankBranchCodeController = TextEditingController();
  String? _selectedBankName;
  
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
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchTermsAndConditions();
      _fadeController.forward();
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
    _fadeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 5) {
        setState(() {
          _currentStep++;
          _fadeController.reset();
          _fadeController.forward();
        });
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
      setState(() {
        _currentStep--;
        _fadeController.reset();
        _fadeController.forward();
      });
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
    
    final pinText = _pinController.text.trim();
    
    final request = RegisterRequestModel(
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      pin: pinText.isNotEmpty ? pinText : null,
      
      bankAccountName: _bankAccountNameController.text.trim(),
      bankAccountNumber: _bankAccountNumberController.text.trim(),
      bankBranchName: _bankBranchNameController.text.trim(),
      bankBranchCode: _bankBranchCodeController.text.trim(),
      bankName: _selectedBankName ?? '',
      
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
      
      spouseName: _spouseNameController.text.isNotEmpty 
          ? _spouseNameController.text.trim() 
          : null,
      spouseDob: _spouseDobController.text.isNotEmpty 
          ? _spouseDobController.text 
          : null,
      children: _children.isNotEmpty ? _children : null,
      
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
      
      salary: _salaryController.text.isNotEmpty 
          ? num.tryParse(_salaryController.text) 
          : null,
      contributionRate: _contributionRate != null 
          ? num.tryParse(_contributionRate!) 
          : null,
      retirementAge: _retirementAgeController.text.isNotEmpty 
          ? int.tryParse(_retirementAgeController.text) 
          : null,
      
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF2C2C2E),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade400.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.error_outline, color: Colors.red.shade400, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Registration Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        content: Text(
          message, 
          style: TextStyle(fontSize: 15, height: 1.4, color: Colors.grey.shade300)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFE8744F),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0f1624),
              Color(0xFF1a2332),
              Color(0xFF0a0e1a),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? 40 : 24,
                    vertical: keyboardVisible ? 12 : 20,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1a2332),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFE8744F).withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                                BoxShadow(
                                  color: const Color(0xFFE8744F).withOpacity(0.1),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: _buildCurrentStep(),
                          ),
                          
                          const SizedBox(height: 24),
                          _buildNavigationButtons(),
                          
                          if (_currentStep == 0) ...[
                            const SizedBox(height: 24),
                            _buildLoginLink(),
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

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8744F).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE8744F).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFE8744F), size: 20),
                  onPressed: _previousStep,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8744F).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE8744F).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  'Step ${_currentStep + 1} of 6',
                  style: const TextStyle(
                    color: Color(0xFFE8744F),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: constraints.maxWidth * ((_currentStep + 1) / 6),
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8744F).withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8744F).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 32),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Set up your account credentials',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          CustomTextField(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'your.email@example.com',
            prefixIcon: Icons.email_rounded,
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
          
          const SizedBox(height: 20),
          
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
          
          const SizedBox(height: 20),
          
          PinTextField(
            controller: _pinController,
            labelText: '4-Digit PIN (Optional)',
            hintText: '••••',
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length != 4) {
                return 'PIN must be exactly 4 digits';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE8744F).withOpacity(0.1),
                  const Color(0xFFD85B42).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE8744F).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8744F).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFE8744F),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'PIN is optional. A temporary password will be sent to your email and phone after payment',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8744F).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.badge_rounded, color: Colors.white, size: 32),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Personal Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Tell us more about yourself',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          CustomTextField(
            controller: _firstNameController,
            labelText: 'First Name',
            hintText: 'John',
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 20),
          
          CustomTextField(
            controller: _lastNameController,
            labelText: 'Last Name',
            hintText: 'Doe',
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 20),
          
          DatePickerField(
            controller: _dateOfBirthController,
            labelText: 'Date of Birth',
            hintText: 'Select your date of birth',
            prefixIcon: Icons.cake_rounded,
            lastDate: DateTime.now().subtract(const Duration(days: 6570)),
            initialDate: DateTime.now().subtract(const Duration(days: 9125)),
          ),
          
          const SizedBox(height: 20),
          
          DropdownField(
            value: _gender,
            labelText: 'Gender',
            hintText: 'Select gender',
            prefixIcon: Icons.wc_rounded,
            items: const ['Male', 'Female', 'Other'],
            onChanged: (value) => setState(() => _gender = value),
          ),
          
          const SizedBox(height: 20),
          
          DropdownField(
            value: _maritalStatus,
            labelText: 'Marital Status',
            hintText: 'Select marital status',
            prefixIcon: Icons.favorite_rounded,
            items: const ['Single', 'Married', 'Divorced', 'Widowed'],
            onChanged: (value) => setState(() => _maritalStatus = value),
          ),
          
          const SizedBox(height: 20),
          
          CustomTextField(
            controller: _nationalIdController,
            labelText: 'National ID',
            hintText: '12345678',
            prefixIcon: Icons.credit_card_rounded,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8744F).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.family_restroom_rounded, color: Colors.white, size: 32),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Family Information',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Add your family details (optional)',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          if (_maritalStatus == 'Married') ...[
            CustomTextField(
              controller: _spouseNameController,
              labelText: 'Spouse Name',
              hintText: 'Enter spouse name',
              prefixIcon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            
            const SizedBox(height: 20),
            
            DatePickerField(
              controller: _spouseDobController,
              labelText: 'Spouse Date of Birth',
              hintText: 'Select date',
              prefixIcon: Icons.cake_rounded,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8744F).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.work_rounded, color: Colors.white, size: 32),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Address & Employment',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Where do you live and work?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          CustomTextField(
            controller: _addressController,
            labelText: 'Address',
            hintText: 'Enter your address',
            prefixIcon: Icons.home_rounded,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            maxLines: 2,
          ),
          
          const SizedBox(height: 20),
          
          CustomTextField(
            controller: _cityController,
            labelText: 'City',
            hintText: 'Nairobi',
            prefixIcon: Icons.location_city_rounded,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 20),
          
          CountryDropdownField(
            value: _country,
            labelText: 'Country',
            hintText: 'Select your country',
            prefixIcon: Icons.flag_rounded,
            onChanged: (value) => setState(() => _country = value),
          ),
          
          const SizedBox(height: 20),
          
          CustomTextField(
            controller: _occupationController,
            labelText: 'Occupation',
            hintText: 'Software Engineer',
            prefixIcon: Icons.work_outline_rounded,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 20),
          
          CustomTextField(
            controller: _employerController,
            labelText: 'Employer',
            hintText: 'Company Name',
            prefixIcon: Icons.business_rounded,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8744F).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 32),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Financial Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Tell us about your finances',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          NumericTextField(
            controller: _salaryController,
            labelText: 'Monthly Salary',
            hintText: '50000',
            prefixIcon: Icons.attach_money_rounded,
            prefixText: 'KES ',
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 20),
          
          DropdownField(
            value: _contributionRate,
            labelText: 'Contribution Rate',
            hintText: 'Select contribution rate',
            prefixIcon: Icons.percent_rounded,
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
          
          const SizedBox(height: 20),
          
          NumericTextField(
            controller: _retirementAgeController,
            labelText: 'Retirement Age',
            hintText: '60',
            prefixIcon: Icons.calendar_today_rounded,
            suffixText: 'years',
            allowDecimal: false,
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 20),
          
          DropdownField(
            value: _accountType,
            labelText: 'Account Type',
            hintText: 'Select account type',
            prefixIcon: Icons.account_balance_wallet_outlined,
            items: const ['MANDATORY', 'VOLUNTARY', 'INDIVIDUAL'],
            onChanged: (value) => setState(() => _accountType = value!),
          ),
          
          const SizedBox(height: 20),
          
          DropdownField(
            value: _riskProfile,
            labelText: 'Risk Profile',
            hintText: 'Select risk profile',
            prefixIcon: Icons.trending_up_rounded,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8744F).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 32),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Bank & Terms',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Final step - bank details and acceptance',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          BankDetailsWidget(
            accountNameController: _bankAccountNameController,
            accountNumberController: _bankAccountNumberController,
            branchNameController: _bankBranchNameController,
            branchCodeController: _bankBranchCodeController,
            selectedBankName: _selectedBankName,
            onBankNameChanged: (value) {
              setState(() => _selectedBankName = value);
            },
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE8744F).withOpacity(0.1),
                  const Color(0xFFD85B42).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE8744F).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8744F).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFE8744F),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Upon registration, you\'ll receive an M-Pesa prompt to pay 1 KES. After successful payment, a temporary password will be sent to your email and phone.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
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
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE8744F).withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8744F).withOpacity(0.1),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE8744F),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8744F), Color(0xFFD85B42)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8744F).withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _currentStep < 5 ? 'Next' : 'Complete Registration',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE8744F),
              ),
            ),
          ),
        ),
      ],
    );
  }
}