import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repository/garbage_types_admin_repository.dart';
import '../model/garbage_type_admin_model.dart';

class GarbageTypesAdminRepositoryImpl implements GarbageTypesAdminRepository {
  final ApiConsumer apiConsumer;

  GarbageTypesAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<GarbageTypeAdminModel>>> getGarbageTypes() async {
    final result =
        await apiConsumer.get<Map<String, dynamic>>(EndPoint.garbageTypes);
    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List ? json['data'] as List : [];
        final list = rawList
            .map((item) => GarbageTypeAdminModel.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, GarbageTypeAdminModel>> createGarbageType(
      FormData formData) async {
    return await apiConsumer.post<GarbageTypeAdminModel>(
      EndPoint.garbageTypes,
      data: formData,
      isFromData: true,
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return GarbageTypeAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, GarbageTypeAdminModel>> updateGarbageType(
      String id, FormData formData) async {
    return await apiConsumer.patch<GarbageTypeAdminModel>(
      '${EndPoint.garbageTypes}/$id',
      data: formData,
      isFromData: true,
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return GarbageTypeAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, String>> deleteGarbageType(String id) async {
    final result = await apiConsumer.delete<Map<String, dynamic>>(
      '${EndPoint.garbageTypes}/$id',
    );
    return result.fold(
      (error) => Left(error),
      (json) =>
          Right(json['message']?.toString() ?? 'Garbage type deleted successfully'),
    );
  }
}
