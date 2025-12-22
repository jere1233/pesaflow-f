import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/register_initiation_response_model.dart';
import '../../data/models/otp_verification_model.dart';
import '../../domain/entities/user.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

class AuthProvider extends ChangeNotifier {
  final AuthRemoteDataSource _authDataSource;

  AuthProvider({
    required AuthRemoteDataSource authDataSource,
  }) : _authDataSource = authDataSource;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  
  // Registration payment tracking
  String? _registrationTransactionId;
  String? _registrationCheckoutRequestId;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get registrationTransactionId => _registrationTransactionId;
  String? get registrationCheckoutRequestId => _registrationCheckoutRequestId;

  // Check if user is logged in
  Future<void> checkAuthStatus() async {
    try {
      final token = await SecureStorageHelper.read('auth_token');
      if (token != null) {
        _status = AuthStatus.authenticated;
        // Fetch user data
        await getCurrentUser();
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final request = LoginRequestModel(identifier: email, password: password);
      final response = await _authDataSource.login(request);

      await _saveTokens(response);
      _user = response.user.toEntity();
      _status = AuthStatus.authenticated;

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  // Register (initiate payment + registration)
  Future<RegisterInitiationResponseModel> register(RegisterRequestModel request) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final response = await _authDataSource.register(request);

      // Store transaction details for status checking
      _registrationTransactionId = response.transactionId;
      _registrationCheckoutRequestId = response.checkoutRequestId;

      // Save transaction ID to storage for persistence
      if (_registrationTransactionId != null) {
        await SecureStorageHelper.write(
          'pending_registration_tx',
          _registrationTransactionId!,
        );
      }

      _setLoading(false);

      return response;
    } catch (e) {
      _setLoading(false);
      final msg = e.toString().replaceAll('Exception: ', '');
      _errorMessage = msg;
      notifyListeners();
      return RegisterInitiationResponseModel(success: false, status: 'failed', message: msg);
    }
  }

  // Check registration payment status
  Future<bool> checkRegistrationStatus(String transactionId) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final response = await _authDataSource.checkRegisterStatus(transactionId);

      // If successful, save tokens and user data
      await _saveTokens(response);
      _user = response.user.toEntity();
      _status = AuthStatus.authenticated;
      
      // Clear pending transaction
      await SecureStorageHelper.delete('pending_registration_tx');
      _registrationTransactionId = null;
      _registrationCheckoutRequestId = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Check for pending registration on app start
  Future<void> checkPendingRegistration() async {
    try {
      final pendingTx = await SecureStorageHelper.read('pending_registration_tx');
      if (pendingTx != null) {
        _registrationTransactionId = pendingTx;
        // Optionally auto-check status
        await checkRegistrationStatus(pendingTx);
      }
    } catch (e) {
      // Ignore errors, user can manually check
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authDataSource.logout();
      await _clearTokens();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // ============================================================================
  // 🚀 UNIFIED OTP METHODS - Work with both email and phone
  // ============================================================================

  /// Send OTP to email or phone (automatically detected by backend)
  /// @param identifier - Can be email (user@example.com) or phone (+254712345678)
  Future<bool> sendOtp(String identifier) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _authDataSource.sendOtp(identifier);

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Verify OTP from email or phone (automatically detected by backend)
  /// @param identifier - Can be email or phone number
  /// @param otp - 6-digit OTP code
  /// @param verificationType - Type of verification (login, register, etc.)
  Future<bool> verifyOtp(String identifier, String otp, String verificationType) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final request = OtpVerificationModel(
        identifier: identifier,
        otp: otp,
        verificationType: verificationType,
      );

      final response = await _authDataSource.verifyOtp(request);

      await _saveTokens(response);
      _user = response.user.toEntity();
      _status = AuthStatus.authenticated;

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ============================================================================

  // Forgot Password
  Future<bool> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _authDataSource.forgotPassword(email);

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _authDataSource.resetPassword(email, otp, newPassword);

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Get Current User
  Future<void> getCurrentUser() async {
    try {
      final userModel = await _authDataSource.getCurrentUser();
      _user = userModel.toEntity();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Save tokens
  Future<void> _saveTokens(AuthResponseModel response) async {
    await SecureStorageHelper.write('auth_token', response.accessToken);
    await SecureStorageHelper.write('refresh_token', response.refreshToken);
  }

  // Clear tokens
  Future<void> _clearTokens() async {
    await SecureStorageHelper.delete('auth_token');
    await SecureStorageHelper.delete('refresh_token');
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
