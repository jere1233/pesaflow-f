import 'dart:convert';
import '../../../../core/network/api_client.dart';
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

  // Login
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  // Register (initiate payment + registration)
  Future<RegisterInitiationResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await apiClient.post(
        '/auth/register',
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
      final response = await apiClient.get('/auth/register/status/$transactionId');

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
      return;
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  // Send OTP
  Future<void> sendOtp(String identifier) async {
    try {
      final response = await apiClient.post(
        '/auth/send-otp',
        data: {'identifier': identifier},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  // Verify OTP
  Future<AuthResponseModel> verifyOtp(OtpVerificationModel request) async {
    try {
      final response = await apiClient.post(
        '/auth/verify-otp',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await apiClient.post(
        '/auth/forgot-password',
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
        '/auth/reset-password',
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
      final response = await apiClient.get('/auth/me');

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
        '/auth/refresh',
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
}
