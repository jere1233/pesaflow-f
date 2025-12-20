// lib/features/transactions/data/datasources/transaction_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_detail_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionDetailModel>> getAllTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<TransactionDetailModel> getTransactionById(String id);
  Future<List<TransactionDetailModel>> searchTransactions(String query);
  Future<List<TransactionDetailModel>> getTransactionsByCategory(String category);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TransactionDetailModel>> getAllTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      final response = await dio.get(
        '/transactions',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle different response structures
        List<dynamic> transactionsList;
        if (data is Map && data.containsKey('data')) {
          transactionsList = data['data'] as List;
        } else if (data is List) {
          transactionsList = data;
        } else {
          throw ServerException('Invalid response format');
        }

        return transactionsList
            .map((json) => TransactionDetailModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to load transactions');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired');
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException('Transactions not found');
      }
      throw ServerException(e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<TransactionDetailModel> getTransactionById(String id) async {
    try {
      final response = await dio.get('/transactions/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle different response structures
        Map<String, dynamic> transactionData;
        if (data is Map && data.containsKey('data')) {
          transactionData = Map<String, dynamic>.from(data['data']);
        } else if (data is Map) {
          transactionData = Map<String, dynamic>.from(data);
        } else {
          throw ServerException('Invalid response format');
        }

        return TransactionDetailModel.fromJson(transactionData);
      } else {
        throw ServerException('Failed to load transaction details');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired');
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException('Transaction not found');
      }
      throw ServerException(e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionDetailModel>> searchTransactions(String query) async {
    try {
      final response = await dio.get(
        '/transactions/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        List<dynamic> transactionsList;
        if (data is Map && data.containsKey('data')) {
          transactionsList = data['data'] as List;
        } else if (data is List) {
          transactionsList = data;
        } else {
          throw ServerException('Invalid response format');
        }

        return transactionsList
            .map((json) => TransactionDetailModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to search transactions');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error occurred');
    }
  }

  @override
  Future<List<TransactionDetailModel>> getTransactionsByCategory(
    String category,
  ) async {
    try {
      final response = await dio.get(
        '/transactions/category/$category',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        List<dynamic> transactionsList;
        if (data is Map && data.containsKey('data')) {
          transactionsList = data['data'] as List;
        } else if (data is List) {
          transactionsList = data;
        } else {
          throw ServerException('Invalid response format');
        }

        return transactionsList
            .map((json) => TransactionDetailModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to load transactions by category');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error occurred');
    }
  }
}