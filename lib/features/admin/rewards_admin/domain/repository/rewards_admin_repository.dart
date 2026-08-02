import 'package:cash_for_trash/features/admin/rewards_admin/data/model/reward_admin_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class RewardsAdminRepository {
  Future<Either<String, List<RewardAdminModel>>> getRewards();

  Future<Either<String, RewardAdminModel>> createReward(FormData formData);

  Future<Either<String, RewardAdminModel>> updateReward(
      String id, FormData formData);

  Future<Either<String, String>> deleteReward(String id);
}
