// lib/shared/routes/route_names.dart - COMPLETE UPDATED VERSION

class RouteNames {
  // Authentication Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String loginOtpVerification = '/login-otp-verification'; 
  static const String paymentStatus = '/payment-status';
  static const String termsAndConditions = '/terms-and-conditions'; 
  
  // Main App Routes
  static const String home = '/home';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transaction-detail';
  static const String transfer = '/transfer';
  static const String payments = '/payments';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  
  // 🆕 NEW ROUTES - Pension Management Features
  static const String pensionPlans = '/pension-plans';
  static const String downloadStatement = '/download-statement';
  static const String retirementGoals = '/retirement-goals';
  
  // Settings Routes
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String security = '/security';
  
  // Additional Routes
  static const String beneficiaries = '/beneficiaries';
  static const String addBeneficiary = '/add-beneficiary';
  static const String accountStatement = '/account-statement';
  static const String support = '/support';
  static const String faq = '/faq';
}