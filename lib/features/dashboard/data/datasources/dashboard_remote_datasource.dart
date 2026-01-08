// lib/features/dashboard/data/datasources/dashboard_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../../authentication/data/models/user_model.dart';
import '../models/dashboard_transaction_model.dart';
import '../models/stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<List<DashboardTransactionModel>> getTransactions();
  Future<DashboardStatsModel> getStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  final Logger logger;

  DashboardRemoteDataSourceImpl({
    required this.dio,
    required this.logger,
  });

  @override
  Future<UserModel> getUserProfile() async {
    try {
      logger.info('DataSource: Fetching user profile from ${ApiConstants.dashboardUser}');
      
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.dashboardUser}',
      );

      logger.info('DataSource: User profile response - ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['user'] != null) {
          // Ensure bank details are populated: some backends return bank info via /api/accounts
            final Map<String, dynamic> userJson = (data['user'] is Map)
              ? Map<String, dynamic>.from(data['user'] as Map)
              : <String, dynamic>{};

          try {
            // If user has no bank info, try to fetch accounts and merge the first account's bank fields
            final hasBank = (userJson['bankAccount'] != null) ||
                (userJson['bankDetails'] != null) ||
                (userJson['bank_name'] != null) ||
                (userJson['bankName'] != null);

            if (!hasBank) {
              final accountsResp = await dio.get('${ApiConstants.baseUrl}${ApiConstants.accounts}');
              if (accountsResp.statusCode == 200) {
                final accountsData = accountsResp.data;
                final accountsList = accountsData['accounts'];
                if (accountsList is List && accountsList.isNotEmpty) {
                  final firstAcc = accountsList.first;
                  if (firstAcc is Map) {
                    // Map account fields to bankAccount shape our model expects
                    final bankMap = <String, dynamic>{
                      'bankName': firstAcc['bankName'] ?? firstAcc['bank_name'] ?? firstAcc['bankName'] ?? firstAcc['bankName'],
                      'accountNumber': firstAcc['bankAccountNumber'] ?? firstAcc['bank_account_number'] ?? firstAcc['bankAccountNumber'] ?? firstAcc['bankAccountNumber'],
                      'accountName': firstAcc['bankAccountName'] ?? firstAcc['bankAccountName'] ?? firstAcc['bankAccountName'],
                      'branchName': firstAcc['bankBranchName'] ?? firstAcc['bank_branch_name'] ?? firstAcc['bankBranchName'],
                      'branchCode': firstAcc['bankBranchCode'] ?? firstAcc['bank_branch_code'] ?? firstAcc['bankBranchCode'],
                    };

                    userJson['bankAccount'] = bankMap;
                  }
                }
              }
            }
          } catch (_) {
            // ignore account fetch errors; return user as-is
          }

          return UserModel.fromJson(userJson);
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch user profile');
        }
      } else {
        throw ServerException('Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.error('DataSource: DioException - ${e.message}');
      
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please login again.');
      }
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      }
      
      if (e.type == DioExceptionType.unknown) {
        throw NetworkException('Network error. Please check your internet connection.');
      }
      
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to fetch user profile',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<List<DashboardTransactionModel>> getTransactions() async {
    try {
      logger.info('DataSource: Fetching transactions from ${ApiConstants.dashboardTransactions}');
      
      // Prefer fetching transactions for the user's default account
      // Step 1: try to fetch accounts and select a preferred one (MANDATORY or first)
      try {
        final accountsResp = await dio.get('${ApiConstants.baseUrl}${ApiConstants.accounts}');
        if (accountsResp.statusCode == 200) {
          final accountsData = accountsResp.data;
          final accountsList = accountsData['accounts'];
          if (accountsList is List && accountsList.isNotEmpty) {
            // Try to find MANDATORY account, else take first
            Map? selected;
            try {
              selected = (accountsList.firstWhere((a) {
                final acc = a as Map;
                final accType = acc['accountType'] ?? acc['account_type'];
                return accType != null && accType.toString().toUpperCase() == 'MANDATORY';
              }) as Map);
            } catch (_) {
              selected = accountsList.first as Map;
            }

            if (selected != null && selected['id'] != null) {
              final accountId = selected['id'].toString();
              final txResp = await dio.get(
                '${ApiConstants.baseUrl}${ApiConstants.getAccountTransactionsUrl(accountId)}',
                queryParameters: {
                  'limit': 5,
                  'sort': 'desc',
                },
              );

              if (txResp.statusCode == 200) {
                final txData = txResp.data;
                final txList = txData['transactions'] ?? txData['transactions'] ?? txData['data'] ?? [];
                if (txList is List) {
                  return txList.map((json) => DashboardTransactionModel.fromJson(json)).toList();
                }
              }
            }
          }
        }
      } catch (e) {
        // ignore and fallback to dashboard endpoint
        logger.warning('DataSource: Failed to fetch per-account transactions - $e');
      }

      // Fallback: use dashboard transactions endpoint
      final response = await dio.get('${ApiConstants.baseUrl}${ApiConstants.dashboardTransactions}');
      logger.info('DataSource: Transactions response - ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['transactions'] != null) {
          final List<dynamic> transactionsJson = data['transactions'];
          return transactionsJson.map((json) => DashboardTransactionModel.fromJson(json)).toList();
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch transactions');
        }
      } else {
        throw ServerException('Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.error('DataSource: DioException - ${e.message}');
      
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please login again.');
      }
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      }
      
      if (e.type == DioExceptionType.unknown) {
        throw NetworkException('Network error. Please check your internet connection.');
      }
      
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to fetch transactions',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<DashboardStatsModel> getStats() async {
    try {
      logger.info('DataSource: Fetching stats from ${ApiConstants.dashboardStats}');
      
      // ✅ FIXED: Now using the constant that includes /api prefix
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.dashboardStats}',
      );

      logger.info('DataSource: Stats response - ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        return DashboardStatsModel.fromJson(data);
      } else {
        throw ServerException('Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.error('DataSource: DioException - ${e.message}');
      
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please login again.');
      }
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      }
      
      if (e.type == DioExceptionType.unknown) {
        throw NetworkException('Network error. Please check your internet connection.');
      }
      
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to fetch stats',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }
}