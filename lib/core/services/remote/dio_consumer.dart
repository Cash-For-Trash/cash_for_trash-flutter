import 'dart:developer';

import 'package:cash_for_trash/core/errors/handle_dio_exception.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/api_interceptor.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:cash_for_trash/core/services/remote/logging_interceptor.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.options.headers = {'Content-Type': 'application/json'};
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.addAll(LoggingInterceptor.getInterceptors());
  }

  @override
  Future<Either<String, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      return Left(DioExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<String, T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      return Left(DioExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<String, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      return Left(DioExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<String, T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      return Left(DioExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<String, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      return Left(DioExceptionHandler.handleException(e));
    }
  }

  Either<String, T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    log("The Response: $response");
    try {
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final bool success = responseData['success'] ?? false;
        final int status = responseData['status'] ?? response.statusCode ?? 0;
        final String message = responseData['message'] ?? 'Unknown error';

        if (success && (status == 200 || status == 201)) {
          if (fromJson != null) {
            return Right(fromJson(responseData));
          } else {
            return Right(responseData as T);
          }
        } else {
          final errors = responseData[ApiKey.errors];
          if (errors is List && errors.isNotEmpty) {
            return Left(errors.join(', '));
          }
          return Left(message);
        }
      }
      return Left('Unexpected response format');
    } catch (e) {
      return Left('Error parsing response: ${e.toString()}');
    }
  }
}
