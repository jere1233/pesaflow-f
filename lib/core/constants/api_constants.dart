class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://localhost:8000/api'; // Change for production
  static const String prodBaseUrl = 'https://your-production-url.com/api';
  
  // Timeout
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
  
  // API Endpoints
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  
  // User/Profile
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String changePassword = '/user/change-password';
  static const String uploadAvatar = '/user/avatar/upload';
  
  // Account
  static const String accounts = '/accounts';
  static const String accountBalance = '/accounts/balance';
  static const String accountStatement = '/accounts/statement';
  
  // Transactions
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transactions'; // + /{id}
  static const String recentTransactions = '/transactions/recent';
  
  // Transfer
  static const String transfer = '/transfer/send';
  static const String beneficiaries = '/transfer/beneficiaries';
  static const String addBeneficiary = '/transfer/beneficiaries/add';
  static const String deleteBeneficiary = '/transfer/beneficiaries'; // + /{id}
  static const String validateAccount = '/transfer/validate-account';
  
  // Payments
  static const String payments = '/payments';
  static const String payBill = '/payments/bill';
  static const String mpesaPayment = '/payments/mpesa';
  static const String bills = '/payments/bills';
  static const String paymentHistory = '/payments/history';
  
  // Notifications
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications'; // + /{id}/read
  static const String markAllAsRead = '/notifications/read-all';
  
  // Settings
  static const String settings = '/settings';
  static const String updateSettings = '/settings/update';
  
  // Support
  static const String contactSupport = '/support/contact';
  static const String faq = '/support/faq';
  
  // KYC
  static const String uploadKyc = '/kyc/upload';
  static const String kycStatus = '/kyc/status';
}