// lib/core/constants/api_constants.dart
class ApiConstants {
  // Base URL - Updated to use Render backend
  static const String baseUrl = 'https://pension-backend-rs4h.onrender.com/api';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String loginOtp = '/auth/login/otp';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String sendOtp = '/auth/send-otp';
  static const String currentUser = '/auth/verify'; 
  static const String checkRegisterStatus = '/auth/register/status';
  
  // Dashboard Endpoints (NEW)
  static const String dashboardUser = '/dashboard/user';
  static const String dashboardTransactions = '/dashboard/transactions';
  static const String dashboardStats = '/dashboard/stats';
  
  // User Endpoints
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String deleteAccount = '/users/account';
  
  // Transaction Endpoints
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transactions';
  static const String userTransactions = '/transactions/user';
  
  // Payment Endpoints
  static const String initiatePayment = '/payments/initiate';
  static const String checkPaymentStatus = '/payments/status';
  static const String paymentCallback = '/payments/callback';
  
  // M-Pesa Endpoints
  static const String mpesaSTKPush = '/mpesa/stk-push';
  static const String mpesaCallback = '/mpesa/callback';
  static const String mpesaQuery = '/mpesa/query';
  
  // Other Endpoints
  static const String health = '/health';
  static const String notifications = '/notifications';
  
  // Helper method to get full URL
  static String getFullUrl(String endpoint) => baseUrl + endpoint;
  
  // Helper method to build URL with path parameter
  static String buildUrl(String endpoint, String pathParam) {
    return '$baseUrl$endpoint/$pathParam';
  }
}