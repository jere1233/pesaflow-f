// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://pension-backend-rs4h.onrender.com';
  
  // Timeouts
  static const int connectionTimeout = 30000; 
  static const int receiveTimeout = 30000; 

  
  // Authentication Endpoints
  static const String login = '/api/auth/login';
  static const String loginOtp = '/api/auth/login/otp';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  static const String refreshToken = '/api/auth/refresh';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String sendOtp = '/api/auth/send-otp';
  static const String currentUser = '/api/auth/verify'; 
  static const String checkRegisterStatus = '/api/auth/register/status';
  static const String setPassword = '/api/auth/set-password';
  static const String promote = '/api/auth/promote';
  static const String demote = '/api/auth/demote';
  
  // Dashboard Endpoints
  static const String dashboardUser = '/api/dashboard/user';
  static const String dashboardTransactions = '/api/dashboard/transactions';
  static const String dashboardStats = '/api/dashboard/stats';
  
  // User Endpoints
  static const String users = '/api/users';
  static const String userNamesByPhone = '/api/users/user-names-by-phone';
  static const String updateProfile = '/api/users/profile';
  static const String changePassword = '/api/users/change-password';
  static const String deleteAccount = '/api/users/account';
  
  // Account Endpoints
  static const String accounts = '/api/accounts';
  static const String accountContribution = '/api/accounts'; // + /{id}/contribution
  static const String accountEarnings = '/api/accounts'; // + /{id}/earnings
  static const String accountWithdraw = '/api/accounts'; // + /{id}/withdraw
  static const String accountStatus = '/api/accounts'; // + /{id}/status
  static const String accountSummary = '/api/accounts'; // + /{id}/summary
  
  // Transaction Endpoints
  static const String transactions = '/api/transactions';
  static const String transactionDetail = '/api/transactions';
  static const String userTransactions = '/api/transactions/user';
  
  // Payment Endpoints
  static const String initiatePayment = '/api/payment/initiate';
  static const String checkPaymentStatus = '/api/payment/status';
  static const String paymentCallback = '/api/payment/callback';
  
  // Terms and Conditions Endpoints
  static const String termsAndConditions = '/api/terms-and-conditions';
  
  // Health Check
  static const String health = '/api/health';
  
  // Notifications
  static const String notifications = '/api/notifications';
  
  // Helper method to get full URL
  static String getFullUrl(String endpoint) => baseUrl + endpoint;
  
  // Helper method to build URL with path parameter
  static String buildUrl(String endpoint, String pathParam) {
    return '$baseUrl$endpoint/$pathParam';
  }
  
  // Helper method to build account URLs with ID
  static String getAccountUrl(String accountId) => '$accounts/$accountId';
  static String getAccountContributionUrl(String accountId) => '$accounts/$accountId/contribution';
  static String getAccountEarningsUrl(String accountId) => '$accounts/$accountId/earnings';
  static String getAccountWithdrawUrl(String accountId) => '$accounts/$accountId/withdraw';
  static String getAccountStatusUrl(String accountId) => '$accounts/$accountId/status';
  static String getAccountSummaryUrl(String accountId) => '$accounts/$accountId/summary';
  
  // Helper method to build user URLs with ID
  static String getUserUrl(String userId) => '$users/$userId';
  
  // Helper method to build transaction URLs
  static String getTransactionUrl(String transactionId) => '$transactions/$transactionId';
  
  // Helper method to build payment status URL
  static String getPaymentStatusUrl(String transactionId) => '$checkPaymentStatus/$transactionId';
  
  // Helper method to build register status URL
  static String getRegisterStatusUrl(String transactionId) => '$checkRegisterStatus/$transactionId';
}