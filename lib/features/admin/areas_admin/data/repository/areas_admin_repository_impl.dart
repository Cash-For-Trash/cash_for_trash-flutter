import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repository/areas_admin_repository.dart';
import '../model/area_admin_model.dart';

class AreasAdminRepositoryImpl implements AreasAdminRepository {
  final ApiConsumer apiConsumer;

  AreasAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<AreaAdminModel>>> getAreas() async {
    final result = await apiConsumer.get<Map<String, dynamic>>(EndPoint.areas);
    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List ? json['data'] as List : [];
        final list = rawList
            .map((item) =>
                AreaAdminModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, AreaAdminModel>> createArea(
      Map<String, dynamic> data) async {
    return await apiConsumer.post<AreaAdminModel>(
      EndPoint.areas,
      data: data,
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return AreaAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, AreaAdminModel>> updateArea(
      String id, Map<String, dynamic> data) async {
    return await apiConsumer.patch<AreaAdminModel>(
      '${EndPoint.areas}/$id',
      data: data,
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return AreaAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, String>> deleteArea(String id) async {
    final result = await apiConsumer.delete<Map<String, dynamic>>(
      '${EndPoint.areas}/$id',
    );
    return result.fold(
      (error) => Left(error),
      (json) => Right(json['message']?.toString() ?? 'Area deleted successfully'),
    );
  }

  @override
  Future<Either<String, String>> updateAreaPrice(
      String id, double price) async {
    final result = await apiConsumer.patch<Map<String, dynamic>>(
      '${EndPoint.areas}/$id/price',
      data: {'service_price': price},
    );
    return result.fold(
      (error) => Left(error),
      (json) => Right(json['message']?.toString() ?? 'Price updated successfully'),
    );
  }
}
