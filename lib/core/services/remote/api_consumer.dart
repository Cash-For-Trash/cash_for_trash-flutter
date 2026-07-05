import 'package:dartz/dartz.dart';

abstract class ApiConsumer {
  Future<Either<String, T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  });
  Future<Either<String, T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  });
  Future<Either<String, T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  });
  Future<Either<String, T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  });
  Future<Either<String, T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    T Function(Map<String, dynamic>)? fromJson,
  });
}