import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import '../../domain/repository/rewards_repository.dart';
import '../model/redemption_model.dart';
import '../model/reward_model.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final ApiConsumer apiConsumer;

  RewardsRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<RewardModel>>> getRewards() async {
    return await apiConsumer.get<List<RewardModel>>(
      EndPoint.rewardsAdmin,
      fromJson: (json) {
        final data = json['data'] as List<dynamic>;
        return data
            .map((e) => RewardModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Either<String, List<RedemptionModel>>> getMyRedemptions() async {
    final result = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.myRedemptions,
    );
    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List ? json['data'] as List : [];
        final list = rawList
            .map((e) => RedemptionModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, String>> redeemReward(String rewardId) async {
    final result = await apiConsumer.post<Map<String, dynamic>>(
      '${EndPoint.rewardRedeems}/$rewardId',
    );
    return result.fold(
      (error) => Left(error),
      (json) => Right(json['message']?.toString() ?? 'Redeemed successfully'),
    );
  }

  @override
  Future<Either<String, int>> getCustomerPoints() async {
    final result = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.customerPoints,
    );
    return result.fold(
      (error) => Left(error),
      (json) {
        final dataObj = json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : (json['data'] is num || json['data'] is String ? {'points': json['data']} : json);
        final rawPts = dataObj['points'] ?? dataObj['green_points'] ?? json['points'] ?? json['data'] ?? 0;
        if (rawPts is num) {
          return Right(rawPts.toInt());
        } else if (rawPts is String) {
          return Right(int.tryParse(rawPts) ?? 0);
        }
        return const Right(0);
      },
    );
  }
}
