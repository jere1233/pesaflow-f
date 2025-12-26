///home/hp/JERE/pension-frontend/lib/features/authentication/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/register_initiation_response_model.dart';
import '../../data/models/terms_and_conditions_model.dart';
import '../../domain/entities/user.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  awaitingOtp,
  tempPasswordRequired,
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
  
  // Login flow tracking
  String? _pendingLoginIdentifier;
  String? _pendingLoginOtp;
  
  // Registration payment tracking
  String? _registrationTransactionId;
  String? _registrationCheckoutRequestId;

  // Terms and Conditions
  TermsAndConditionsModel? _termsAndConditions;
  bool _isLoadingTerms = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get pendingLoginIdentifier => _pendingLoginIdentifier;
  String? get registrationTransactionId => _registrationTransactionId;
  String? get registrationCheckoutRequestId => _registrationCheckoutRequestId;
  TermsAndConditionsModel? get termsAndConditions => _termsAndConditions;
  bool get isLoadingTerms => _isLoadingTerms;

  // Check if user is logged in
  Future<void> checkAuthStatus() async {
    try {
      final token = await SecureStorageHelper.read('auth_token');
      if (token != null) {
        _status = AuthStatus.authenticated;
        await getCurrentUser();
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Login Step 1: Initiate login (sends OTP)
  Future<bool> initiateLogin(String identifier, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final request = LoginRequestModel(identifier: identifier, password: password);
      final response = await _authDataSource.initiateLogin(request);

      if (response['success'] == true) {
        _pendingLoginIdentifier = identifier;
        _status = AuthStatus.awaitingOtp;
        _setLoading(false);
        return true;
      }

      _setLoading(false);
      return false;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('Failed to initiate login: ', '');
      notifyListeners();
      return false;
    }
  }

  // Login Step 2: Verify OTP (and set permanent password if needed)
  Future<bool> verifyLoginOtp(String otp, {String? newPassword}) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      if (_pendingLoginIdentifier == null) {
        throw Exception('No pending login session');
      }

      final response = await _authDataSource.loginWithOtp(
        _pendingLoginIdentifier!,
        otp,
        newPassword: newPassword,
      );

      await _saveTokens(response);
      _user = response.user.toEntity();
      _status = AuthStatus.authenticated;
      _pendingLoginIdentifier = null;
      _pendingLoginOtp = null;

      _setLoading(false);
      return true;
    } on Exception catch (e) {
      final errorMsg = e.toString();
      
      if (errorMsg.contains('TEMP_PASSWORD_REQUIRED')) {
        // User needs to set permanent password
        _pendingLoginOtp = otp;
        _status = AuthStatus.tempPasswordRequired;
        _setLoading(false);
        notifyListeners();
        return false;
      }

      _setLoading(false);
      _errorMessage = errorMsg.replaceAll('Exception: ', '').replaceAll('Failed to verify OTP: ', '');
      _status = AuthStatus.awaitingOtp;
      notifyListeners();
      return false;
    }
  }

  // ============================================================================
  // LEGACY METHODS - For backward compatibility with old OTP screen
  // ============================================================================
  
  /// Send OTP (Legacy - redirects to initiateLogin for login flow)
  Future<bool> sendOtp(String identifier) async {
    // This is a placeholder for the old OTP screen
    // In reality, OTP is sent during initiateLogin
    _errorMessage = "Please use the login screen to initiate OTP";
    notifyListeners();
    return false;
  }

  /// Verify OTP (Legacy - redirects to verifyLoginOtp)
  Future<bool> verifyOtp(String identifier, String otp, String verificationType) async {
    if (verificationType == 'login') {
      _pendingLoginIdentifier = identifier;
      return await verifyLoginOtp(otp);
    }
    
    _errorMessage = "Invalid verification type";
    notifyListeners();
    return false;
  }

  // ============================================================================

  // Register (initiate payment + registration)
  Future<RegisterInitiationResponseModel> register(RegisterRequestModel request) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final response = await _authDataSource.register(request);

      _registrationTransactionId = response.transactionId;
      _registrationCheckoutRequestId = response.checkoutRequestId;

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

      await _saveTokens(response);
      _user = response.user.toEntity();
      _status = AuthStatus.authenticated;
      
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

  // Logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authDataSource.logout();
      await _clearTokens();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _pendingLoginIdentifier = null;
      _pendingLoginOtp = null;
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

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
  Future<bool> resetPassword(String email, String otp, String newPassword) async {
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

  // ============================================================================
  // 🆕 NEW: Terms and Conditions Methods
  // ============================================================================

  /// Fetch Terms and Conditions from API
  Future<bool> fetchTermsAndConditions() async {
    try {
      _isLoadingTerms = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authDataSource.getTermsAndConditions();
      _termsAndConditions = TermsAndConditionsModel.fromJson(response);

      _isLoadingTerms = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoadingTerms = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('Failed to fetch terms and conditions: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Get cached terms or fetch if not available
  Future<TermsAndConditionsModel?> getTermsAndConditions() async {
    if (_termsAndConditions != null) {
      return _termsAndConditions;
    }
    
    final success = await fetchTermsAndConditions();
    return success ? _termsAndConditions : null;
  }

  // ============================================================================

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