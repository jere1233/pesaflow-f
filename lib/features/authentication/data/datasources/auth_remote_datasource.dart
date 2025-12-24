///home/hp/JERE/pension-frontend/lib/features/authentication/data/datasources/auth_remote_datasource.dart
import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/register_initiation_response_model.dart';
import '../models/otp_verification_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({
    required this.apiClient,
  });

  // ============================================================================
  // ✅ FIXED: Now using ApiConstants instead of hardcoded paths
  // ============================================================================

  // Login Step 1: Send password, get OTP sent to email
  Future<Map<String, dynamic>> initiateLogin(LoginRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login, // ✅ Using constant instead of '/auth/login'
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': response.data['success'] ?? true,
          'message': response.data['message'] ?? 'OTP sent to your email',
        };
      } else {
        throw Exception(response.data['message'] ?? response.data['error'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Failed to initiate login: ${e.toString()}');
    }
  }

  // Login Step 2: Verify OTP (and optionally set permanent password)
  Future<AuthResponseModel> loginWithOtp(String identifier, String otp, {String? newPassword}) async {
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
      } else {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  // Register (initiate payment + registration)
  Future<RegisterInitiationResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register, // ✅ Using constant
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterInitiationResponseModel.fromJson(
            response.data is Map ? Map<String, dynamic>.from(response.data) : {});
      } else {
        throw Exception(response.data['message'] ?? 'Registration initiation failed');
      }
    } catch (e) {
      throw Exception('Failed to initiate registration: ${e.toString()}');
    }
  }

  // Check registration payment/status
  Future<AuthResponseModel> checkRegisterStatus(String transactionId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getRegisterStatusUrl(transactionId), // ✅ Using helper method
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

  // Logout
  Future<void> logout() async {
    try {
      // If backend has logout endpoint, uncomment:
      // await apiClient.post(ApiConstants.logout);
      return;
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await apiClient.post(
        ApiConstants.forgotPassword, // ✅ Using constant
        data: {'email': email},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to send reset link');
      }
    } catch (e) {
      throw Exception('Failed to send reset link: ${e.toString()}');
    }
  }

  // Reset Password
  Future<void> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resetPassword, // ✅ Using constant
        data: {
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }

  // Get Current User
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiConstants.currentUser); // ✅ Using constant

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
      } else {
        throw Exception('Failed to get user data');
      }
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  // Refresh Token
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        ApiConstants.refreshToken, // ✅ Using constant
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

  // Send OTP (for generic OTP sending)
  Future<void> sendOtp(String identifier) async {
    try {
      final response = await apiClient.post(
        ApiConstants.sendOtp, // ✅ Using constant
        data: {'identifier': identifier},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  // Verify OTP (for generic OTP verification)
  Future<void> verifyOtp(String identifier, String otp, String verificationType) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyOtp, // ✅ Using constant
        data: {
          'identifier': identifier,
          'otp': otp,
          'verificationType': verificationType,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  // Set Password (for setting/changing permanent password)
  Future<void> setPassword(String newPassword) async {
    try {
      final response = await apiClient.post(
        ApiConstants.setPassword, // ✅ Using constant
        data: {'newPassword': newPassword},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to set password');
      }
    } catch (e) {
      throw Exception('Failed to set password: ${e.toString()}');
    }
  }
}