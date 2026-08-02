import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repository/redemptions_admin_repository.dart';
import '../model/redemption_admin_model.dart';

class RedemptionsAdminRepositoryImpl implements RedemptionsAdminRepository {
  final ApiConsumer apiConsumer;

  RedemptionsAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<RedemptionAdminModel>>> getRedemptions() async {
    final result =
        await apiConsumer.get<Map<String, dynamic>>(EndPoint.rewardRedeems);
    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List ? json['data'] as List : [];
        final list = rawList
            .map((item) => RedemptionAdminModel.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, String>> approveRedemption(String redemptionId) async {
    final result = await apiConsumer.put<Map<String, dynamic>>(
      '${EndPoint.rewardRedeems}/approve/$redemptionId',
      data: {},
    );
    return result.fold(
      (error) => Left(error),
      (json) =>
          Right(json['message']?.toString() ?? 'Redemption approved successfully'),
    );
  }

  @override
  Future<Either<String, String>> rejectRedemption(String redemptionId) async {
    final result = await apiConsumer.put<Map<String, dynamic>>(
      '${EndPoint.rewardRedeems}/reject/$redemptionId',
      data: {},
    );
    return result.fold(
      (error) => Left(error),
      (json) =>
          Right(json['message']?.toString() ?? 'Redemption rejected successfully'),
    );
  }
}
