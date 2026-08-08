import 'package:cash_for_trash/features/admin/rewards_admin/data/model/reward_admin_model.dart';
import 'package:dartz/dartz.dart';

abstract class RewardsAdminRepository {
  Future<Either<String, List<RewardAdminModel>>> getRewards();

  Future<Either<String, RewardAdminModel>> createReward(
    Map<String, dynamic> fields,
    String imagePath,
  );

  Future<Either<String, RewardAdminModel>> updateReward(
    String id,
    Map<String, dynamic> fields,
    String? imagePath,
  );

  Future<Either<String, String>> deleteReward(String id);
}
