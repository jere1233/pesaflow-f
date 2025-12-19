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
      logger.info('DataSource: Fetching user profile from /dashboard/user');
      
      final response = await dio.get(
        '${ApiConstants.baseUrl}/dashboard/user',
      );

      logger.info('DataSource: User profile response - ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['user'] != null) {
          return UserModel.fromJson(data['user']);
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
      logger.info('DataSource: Fetching transactions from /dashboard/transactions');
      
      final response = await dio.get(
        '${ApiConstants.baseUrl}/dashboard/transactions',
      );

      logger.info('DataSource: Transactions response - ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['transactions'] != null) {
          final List<dynamic> transactionsJson = data['transactions'];
          return transactionsJson
              .map((json) => DashboardTransactionModel.fromJson(json))
              .toList();
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
      logger.info('DataSource: Fetching stats from /dashboard/stats');
      
      final response = await dio.get(
        '${ApiConstants.baseUrl}/dashboard/stats',
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