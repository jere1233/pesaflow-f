///home/hp/JERE/pension-frontend/lib/features/authentication/presentation/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/auth_response_model.dart';
import '../../domain/entities/user.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

class AuthProvider extends ChangeNotifier {
  final AuthRemoteDataSource _authDataSource;
  final FlutterSecureStorage _storage;

  AuthProvider({
    required AuthRemoteDataSource authDataSource,
    required FlutterSecureStorage storage,
  })  : _authDataSource = authDataSource,
        _storage = storage;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Check if user is logged in
  Future<void> checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'auth_token');
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

  // Check registration payment status and complete registration if tokens returned
  Future<bool> checkRegistrationStatus(String transactionId) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final authResponse = await _authDataSource.checkRegisterStatus(transactionId);

      await _saveTokens(authResponse);
      _user = authResponse.user.toEntity();
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

  // Send OTP
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _authDataSource.sendOtp(phoneNumber);

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(
      String phoneNumber, String otp, String verificationType) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final request = OtpVerificationModel(
        phoneNumber: phoneNumber,
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
    await _storage.write(key: 'auth_token', value: response.accessToken);
    await _storage.write(key: 'refresh_token', value: response.refreshToken);
  }

  // Clear tokens
  Future<void> _clearTokens() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
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