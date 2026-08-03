import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import '../../domain/repository/rewards_repository.dart';
import '../model/reward_model.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final ApiConsumer apiConsumer;

  RewardsRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<RewardModel>>> getRewards() async {
    return await apiConsumer.get<List<RewardModel>>(
      EndPoint.rewards,
      fromJson: (json) {
        final data = json['data'] as List<dynamic>;
        return data
            .map((e) => RewardModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
