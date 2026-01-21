// lib/features/reports/data/datasources/report_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<String> generateTransactionReport({
    required String title,
    required List<Map<String, dynamic>> transactions,
  });

  Future<String> generateCustomerReport({
    required String title,
    required Map<String, dynamic> user,
    required List<Map<String, dynamic>> transactions,
  });

  Future<List<ReportModel>> getReports();

  Future<ReportModel> getReportById(String reportId);

  Future<void> deleteReport(String reportId);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio dio;
  final Logger logger;

  ReportRemoteDataSourceImpl({
    required this.dio,
    required this.logger,
  });

  @override
  Future<String> generateTransactionReport({
    required String title,
    required List<Map<String, dynamic>> transactions,
  }) async {
    try {
      logger.info('DataSource: Generating transaction report');

      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.generateTransactionReport}',
        data: {
          'title': title,
          'transactions': transactions,
        },
      );

      logger.info('DataSource: Transaction report response - ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['reportId'] != null) {
          return data['reportId'] as String;
        } else {
          throw ServerException(data['message'] ?? 'Failed to generate transaction report');
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
        e.response?.data?['error'] ?? 'Failed to generate transaction report',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<String> generateCustomerReport({
    required String title,
    required Map<String, dynamic> user,
    required List<Map<String, dynamic>> transactions,
  }) async {
    try {
      logger.info('DataSource: Generating customer report');

      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.generateCustomerReport}',
        data: {
          'title': title,
          'user': user,
          'transactions': transactions,
        },
      );

      logger.info('DataSource: Customer report response - ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['reportId'] != null) {
          return data['reportId'] as String;
        } else {
          throw ServerException(data['message'] ?? 'Failed to generate customer report');
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
        e.response?.data?['error'] ?? 'Failed to generate customer report',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<List<ReportModel>> getReports() async {
    try {
      logger.info('DataSource: Fetching reports');

      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.reports}',
      );

      logger.info('DataSource: Reports response - ${response.statusCode}');
      logger.info('DataSource: Reports data - ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map) {
          if (data['success'] == true && data['data'] != null) {
            final List<dynamic> reportsJson = data['data'];
            return reportsJson
                .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
                .toList();
          } else if (data['success'] == false) {
            throw ServerException(data['error'] ?? data['message'] ?? 'Failed to fetch reports');
          }
        }
        
        throw ServerException('Invalid response format from server');
      } else {
        throw ServerException('Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.error('DataSource: DioException - ${e.message}');
      logger.error('DataSource: DioException response - ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please login again.');
      }

      if (e.response?.statusCode == 403) {
        throw UnauthorizedException('Access denied. Please login again.');
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      }

      if (e.type == DioExceptionType.unknown) {
        throw NetworkException('Network error. Please check your internet connection.');
      }

      throw ServerException(
        e.response?.data?['error'] ?? e.message ?? 'Failed to fetch reports',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ReportModel> getReportById(String reportId) async {
    try {
      logger.info('DataSource: Fetching report by ID: $reportId');

      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.getReportUrl(reportId)}',
      );

      logger.info('DataSource: Report response - ${response.statusCode}');
      logger.info('DataSource: Report data - ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle both wrapped and unwrapped response formats
        if (data is Map) {
          // If response has success field, it's wrapped
          if (data.containsKey('success') && data['success'] == true && data.containsKey('report')) {
            return ReportModel.fromJson(data['report'] as Map<String, dynamic>);
          }
          // If response is the report directly (unwrapped)
          if (data.containsKey('id') && data.containsKey('title')) {
            return ReportModel.fromJson(data as Map<String, dynamic>);
          }
          // If response has error
          if (data['success'] == false || data.containsKey('error')) {
            throw ServerException(data['error'] ?? data['message'] ?? 'Failed to fetch report');
          }
        }
        
        // Try parsing directly as report model
        return ReportModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw ServerException('Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.error('DataSource: DioException - ${e.message}');
      logger.error('DataSource: DioException response - ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please login again.');
      }

      if (e.response?.statusCode == 403) {
        throw UnauthorizedException('Access denied. Please login again.');
      }

      if (e.response?.statusCode == 404) {
        throw ServerException('Report not found');
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      }

      if (e.type == DioExceptionType.unknown) {
        throw NetworkException('Network error. Please check your internet connection.');
      }

      throw ServerException(
        e.response?.data?['error'] ?? e.message ?? 'Failed to fetch report',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    try {
      logger.info('DataSource: Deleting report: $reportId');

      final response = await dio.delete(
        '${ApiConstants.baseUrl}${ApiConstants.getReportUrl(reportId)}',
      );

      logger.info('DataSource: Delete report response - ${response.statusCode}');
      logger.info('DataSource: Delete report data - ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle both wrapped and unwrapped response formats
        if (data is Map) {
          // If response has success field
          if (data.containsKey('success')) {
            if (data['success'] == true) {
              return; // Successful deletion
            } else {
              throw ServerException(data['error'] ?? data['message'] ?? 'Failed to delete report');
            }
          }
          // If no success field but we got 200, assume success
          return;
        }
      } else if (response.statusCode == 404) {
        throw ServerException('Report not found');
      } else {
        throw ServerException('Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.error('DataSource: DioException - ${e.message}');
      logger.error('DataSource: DioException response - ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please login again.');
      }

      if (e.response?.statusCode == 403) {
        throw UnauthorizedException('Access denied. Please login again.');
      }

      if (e.response?.statusCode == 404) {
        throw ServerException('Report not found');
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      }

      if (e.type == DioExceptionType.unknown) {
        throw NetworkException('Network error. Please check your internet connection.');
      }

      throw ServerException(
        e.response?.data?['error'] ?? e.message ?? 'Failed to delete report',
      );
    } catch (e) {
      logger.error('DataSource: Unexpected error - $e');
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }
}