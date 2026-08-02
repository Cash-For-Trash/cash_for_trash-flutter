import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repository/availabilities_admin_repository.dart';
import '../model/availability_admin_model.dart';

class AvailabilitiesAdminRepositoryImpl
    implements AvailabilitiesAdminRepository {
  final ApiConsumer apiConsumer;

  AvailabilitiesAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<AvailabilityAdminModel>>>
      getAvailabilities() async {
    final result =
        await apiConsumer.get<Map<String, dynamic>>(EndPoint.availabilities);
    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List ? json['data'] as List : [];
        final list = rawList
            .map((item) => AvailabilityAdminModel.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, AvailabilityAdminModel>> createAvailability(
      Map<String, dynamic> data) async {
    return await apiConsumer.post<AvailabilityAdminModel>(
      EndPoint.availabilities,
      data: data,
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return AvailabilityAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, String>> deleteAvailability(String id) async {
    final result = await apiConsumer.delete<Map<String, dynamic>>(
      '${EndPoint.availabilities}/$id',
    );
    return result.fold(
      (error) => Left(error),
      (json) =>
          Right(json['message']?.toString() ?? 'Availability deleted successfully'),
    );
  }
}
