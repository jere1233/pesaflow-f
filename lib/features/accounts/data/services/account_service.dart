///home/hp/JERE/pension-frontend/lib/features/accounts/data/services/account_service.dart

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/account_model.dart';

class AccountService {
  final ApiClient _apiClient;

  AccountService({ApiClient? apiClient}) 
      : _apiClient = apiClient ?? ApiClient();

  // ============================================================================
  // ACCOUNT CRUD OPERATIONS
  // ============================================================================

  /// Get all accounts for the current user
  /// GET /api/accounts
  Future<List<AccountModel>> getAccounts() async {
    try {
      final response = await _apiClient.get(ApiConstants.accounts);

      if (response.statusCode == 200) {
        final data = response.data;
        final accountsData = data['accounts'] as List;
        return accountsData.map((json) => AccountModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['error'] ?? 'Failed to fetch accounts');
      }
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  /// Get account details by ID
  /// GET /api/accounts/:id
  Future<AccountModel> getAccountById(int id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.getAccountUrl(id.toString()),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AccountModel.fromJson(data['account']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to fetch account');
      }
    } catch (e) {
      throw Exception('Failed to fetch account: $e');
    }
  }

  // ============================================================================
  // CONTRIBUTIONS (🆕 NEW)
  // ============================================================================

  /// Add contribution to account
  /// POST /api/accounts/:id/contribution
  Future<AccountModel> addContribution({
    required int accountId,
    required double employeeAmount,
    double? employerAmount,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.getAccountContributionUrl(accountId.toString()),
        data: {
          'employeeAmount': employeeAmount,
          if (employerAmount != null) 'employerAmount': employerAmount,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AccountModel.fromJson(data['account']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to add contribution');
      }
    } catch (e) {
      throw Exception('Failed to add contribution: $e');
    }
  }

  // ============================================================================
  // EARNINGS (🆕 NEW)
  // ============================================================================

  /// Add earnings to account (interest, investment returns, dividends)
  /// POST /api/accounts/:id/earnings
  Future<AccountModel> addEarnings({
    required int accountId,
    required String type, // 'interest', 'investment_returns', 'dividends'
    required double amount,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.getAccountEarningsUrl(accountId.toString()),
        data: {
          'type': type,
          'amount': amount,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AccountModel.fromJson(data['account']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to add earnings');
      }
    } catch (e) {
      throw Exception('Failed to add earnings: $e');
    }
  }

  // ============================================================================
  // DEPOSITS (🆕 NEW - M-Pesa Integration)
  // ============================================================================

  /// Deposit funds to account via M-Pesa STK Push
  /// POST /api/accounts/:id/deposit
  Future<Map<String, dynamic>> depositFunds({
    required int accountId,
    required double amount,
    String? phone,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.getAccountDepositUrl(accountId.toString()),
        data: {
          'amount': amount,
          if (phone != null) 'phone': phone,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'success': data['success'] ?? true,
          'status': data['status'],
          'message': data['message'],
          'transactionId': data['transactionId'],
          'checkoutRequestId': data['checkoutRequestId'],
          'statusCheckUrl': data['statusCheckUrl'],
        };
      } else {
        throw Exception(response.data['error'] ?? 'Failed to initiate deposit');
      }
    } catch (e) {
      throw Exception('Failed to deposit funds: $e');
    }
  }

  // ============================================================================
  // WITHDRAWALS (🆕 NEW)
  // ============================================================================

  /// Withdraw funds from account
  /// POST /api/accounts/:id/withdraw
  Future<AccountModel> withdrawFunds({
    required int accountId,
    required double amount,
    required String withdrawalType,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.getAccountWithdrawUrl(accountId.toString()),
        data: {
          'amount': amount,
          'withdrawalType': withdrawalType,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AccountModel.fromJson(data['account']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to withdraw funds');
      }
    } catch (e) {
      throw Exception('Failed to withdraw funds: $e');
    }
  }

  // ============================================================================
  // ACCOUNT STATUS (🆕 NEW)
  // ============================================================================

  /// Update account status
  /// PUT /api/accounts/:id/status
  Future<AccountModel> updateAccountStatus({
    required int accountId,
    required String accountStatus, // 'ACTIVE', 'SUSPENDED', 'CLOSED', 'FROZEN', 'DECEASED'
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.getAccountStatusUrl(accountId.toString()),
        data: {
          'accountStatus': accountStatus,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AccountModel.fromJson(data['account']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to update account status');
      }
    } catch (e) {
      throw Exception('Failed to update account status: $e');
    }
  }

  // ============================================================================
  // ACCOUNT SUMMARY (🆕 NEW)
  // ============================================================================

  /// Get account summary with all balances
  /// GET /api/accounts/:id/summary
  Future<Map<String, dynamic>> getAccountSummary(int accountId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.getAccountSummaryUrl(accountId.toString()),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['summary'];
      } else {
        throw Exception(response.data['error'] ?? 'Failed to fetch account summary');
      }
    } catch (e) {
      throw Exception('Failed to fetch account summary: $e');
    }
  }
}