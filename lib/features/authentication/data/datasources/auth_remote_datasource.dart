///home/hp/JERE/pension-frontend/lib/features/authentication/data/datasources/auth_remote_datasource.dart

import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/register_initiation_response_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({
    required this.apiClient,
  });

  // ============================================================================
  // LOGIN FLOW (Two-Step: Password + OTP)
  // ============================================================================

  /// Step 1: Send password, get OTP sent to email/SMS
  /// POST /api/auth/login
  /// Swagger-compliant responses:
  /// - 200/201: OTP sent successfully
  /// - 401: Invalid credentials (email/phone not found OR password incorrect)
  /// - 403: Too many failed attempts (OTP forced by backend)
  /// - 429: Rate limited
  /// - 500: Server error
  Future<Map<String, dynamic>> initiateLogin(LoginRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      // Handle successful responses: 200/201 = normal flow; 403 = too many failed attempts (OTP forced by backend)
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 403) {
        return {
          'success': response.data['success'] ?? true,
          'message': response.data['message'] ?? 'OTP sent to your email',
          'statusCode': response.statusCode,
        };
      }
      // Handle error responses per Swagger spec
      else if (response.statusCode == 401) {
        // 401 Unauthorized: Invalid credentials
        throw Exception(response.data['message'] ?? response.data['error'] ?? 'Invalid credentials');
      } else if (response.statusCode == 429) {
        // 429 Too Many Requests: Rate limited
        throw Exception(response.data['message'] ?? 'Too many login attempts. Please try again later.');
      } else if (response.statusCode == 500) {
        // 500 Server Error
        throw Exception('Server error. Please try again later.');
      } else {
        // Other errors
        throw Exception(response.data['message'] ?? response.data['error'] ?? 'Login failed');
      }
    } catch (e) {
      final errorString = e.toString().replaceAll('Exception: ', '');
      throw Exception(errorString);
    }
  }

  /// Step 2: Verify OTP (and optionally set permanent password for first-time users)
  /// POST /api/auth/login/otp
  /// Swagger-compliant responses:
  /// - 200/201: OTP verified, login successful
  /// - 400: Invalid OTP or expired
  /// - 401: Unauthorized (invalid identifier)
  /// - 429: Rate limited (too many OTP attempts)
  /// - 500: Server error
  Future<AuthResponseModel> loginWithOtp(
    String identifier,
    String otp, {
    String? newPassword,
  }) async {
    try {
      final data = {
        'identifier': identifier,
        'otp': otp,
      };
      
      if (newPassword != null) {
        data['newPassword'] = newPassword;
      }

      final response = await apiClient.post(
        ApiConstants.loginOtp,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        // Check if temporary password needs to be set
        if (responseData['temporary'] == true) {
          throw Exception('TEMP_PASSWORD_REQUIRED');
        }
        
        return AuthResponseModel.fromJson(responseData);
      } else if (response.statusCode == 400) {
        // 400 Bad Request: Invalid or expired OTP
        throw Exception(response.data['message'] ?? 'Invalid or expired OTP. Please request a new one.');
      } else if (response.statusCode == 401) {
        // 401 Unauthorized: Invalid identifier
        throw Exception(response.data['message'] ?? 'Invalid credentials. Please login again.');
      } else if (response.statusCode == 429) {
        // 429 Too Many Requests: Rate limited
        throw Exception(response.data['message'] ?? 'Too many OTP verification attempts. Please try again later.');
      } else if (response.statusCode == 500) {
        // 500 Server Error
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  // ============================================================================
  // REGISTRATION FLOW (M-Pesa Payment + Auto Account Creation)
  // ============================================================================

  /// Initiate registration and M-Pesa payment
  /// POST /api/auth/register
  Future<RegisterInitiationResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterInitiationResponseModel.fromJson(
          response.data is Map ? Map<String, dynamic>.from(response.data) : {},
        );
      } else {
        throw Exception(response.data['message'] ?? 'Registration initiation failed');
      }
    } catch (e) {
      throw Exception('Failed to initiate registration: ${e.toString()}');
    }
  }

  /// Check registration payment status
  /// GET /api/auth/register/status/:transactionId
  Future<AuthResponseModel> checkRegisterStatus(String transactionId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getRegisterStatusUrl(transactionId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data is Map ? Map<String, dynamic>.from(response.data) : {};

        if (data.containsKey('token') || data.containsKey('access_token')) {
          final authJson = <String, dynamic>{
            'access_token': data['access_token'] ?? data['token'],
            'refresh_token': data['refresh_token'] ?? data['refreshToken'] ?? '',
            'user': data['user'] ?? {},
            'token_type': data['token_type'] ?? data['tokenType'] ?? 'Bearer',
            'expires_in': data['expires_in'] ?? data['expiresIn'] ?? 3600,
          };
          return AuthResponseModel.fromJson(authJson);
        }

        throw Exception(data['message'] ?? data['error'] ?? 'Payment pending');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to check registration status');
      }
    } catch (e) {
      throw Exception('Failed to check registration status: ${e.toString()}');
    }
  }

  // ============================================================================
  // PASSWORD MANAGEMENT (🆕 NEW)
  // ============================================================================

  /// Change password (authenticated)
  /// POST /api/auth/change-password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  /// Request password reset OTP (unauthenticated)
  /// POST /api/auth/forgot-password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await apiClient.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'Failed to send reset OTP');
      }
    } catch (e) {
      throw Exception('Failed to send reset OTP: ${e.toString()}');
    }
  }

  /// Verify OTP and reset password (unauthenticated)
  /// POST /api/auth/forgot-password/verify
  Future<void> forgotPasswordVerify({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.forgotPasswordVerify,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'Failed to reset password');
      }
    } catch (e) {
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }

  // ============================================================================
  // PIN MANAGEMENT (🆕 NEW)
  // ============================================================================

  /// Change PIN (authenticated)
  /// POST /api/auth/change-pin
  Future<void> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.changePin,
        data: {
          'currentPin': currentPin,
          'newPin': newPin,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'Failed to change PIN');
      }
    } catch (e) {
      throw Exception('Failed to change PIN: ${e.toString()}');
    }
  }

  /// Request PIN reset OTP (unauthenticated)
  /// POST /api/auth/reset-pin
  Future<void> resetPin(String phone) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resetPin,
        data: {'phone': phone},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'Failed to send PIN reset OTP');
      }
    } catch (e) {
      throw Exception('Failed to send PIN reset OTP: ${e.toString()}');
    }
  }

  /// Verify OTP and reset PIN (unauthenticated)
  /// POST /api/auth/reset-pin/verify
  Future<void> resetPinVerify({
    required String phone,
    required String otp,
    required String newPin,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resetPinVerify,
        data: {
          'phone': phone,
          'otp': otp,
          'newPin': newPin,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'Failed to reset PIN');
      }
    } catch (e) {
      throw Exception('Failed to reset PIN: ${e.toString()}');
    }
  }

  // ============================================================================
  // SET PASSWORD & PIN (Authenticated)
  // ============================================================================

  /// Set permanent password (and optionally PIN)
  /// POST /api/auth/set-password
  Future<void> setPassword({
    required String password,
    String? pin,
  }) async {
    try {
      final data = {'password': password};
      if (pin != null) {
        data['pin'] = pin;
      }

      final response = await apiClient.post(
        ApiConstants.setPassword,
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'Failed to set password');
      }
    } catch (e) {
      throw Exception('Failed to set password: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER MANAGEMENT
  // ============================================================================

  /// Get current user
  /// GET /api/auth/verify
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiConstants.currentUser);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
      } else {
        throw Exception('Failed to get user data');
      }
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Backend doesn't have logout endpoint yet
      // Just clear local tokens
      return;
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  /// Refresh token
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: ${e.toString()}');
    }
  }

  // ============================================================================
  // TERMS & CONDITIONS
  // ============================================================================

  /// Get Terms and Conditions (public endpoint)
  /// GET /api/terms-and-conditions
  Future<Map<String, dynamic>> getTermsAndConditions() async {
    try {
      final response = await apiClient.get(
        ApiConstants.termsAndConditions,
      );

      if (response.statusCode == 200) {
        return response.data is Map ? Map<String, dynamic>.from(response.data) : {};
      } else {
        throw Exception(response.data['error'] ?? 'Failed to fetch terms and conditions');
      }
    } catch (e) {
      throw Exception('Failed to fetch terms and conditions: ${e.toString()}');
    }
  }
}