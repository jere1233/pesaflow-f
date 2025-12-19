class ApiConstants {
  // Base URL - Use 10.0.2.2 for Android Emulator to access localhost
  // Change to your production URL when deploying
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  
  // Alternative URLs (uncomment the one you need):
  // static const String baseUrl = 'http://localhost:5000/api'; // For iOS Simulator
  // static const String baseUrl = 'http://192.168.1.x:5000/api'; // For physical device (replace x with your IP)
  // static const String baseUrl = 'https://your-production-url.com/api'; // For production
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String sendOtp = '/auth/send-otp';
  static const String currentUser = '/auth/me';
  static const String checkRegisterStatus = '/auth/register/status'; // /{transactionId}
  
  // User Endpoints
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String deleteAccount = '/users/account';
  
  // Transaction Endpoints
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transactions'; // /{id}
  static const String userTransactions = '/transactions/user'; // /{userId}
  
  // Payment Endpoints
  static const String initiatePayment = '/payments/initiate';
  static const String checkPaymentStatus = '/payments/status'; // /{transactionId}
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