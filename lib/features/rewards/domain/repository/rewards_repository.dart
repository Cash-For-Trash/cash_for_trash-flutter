import 'package:dartz/dartz.dart';
import '../../data/model/redemption_model.dart';
import '../../data/model/reward_model.dart';
import '../../data/model/rewards_leaderboard_model.dart';
import '../../data/model/customer_points_model.dart';

abstract class RewardsRepository {
  Future<Either<String, List<RewardModel>>> getRewards();
  Future<Either<String, List<RedemptionModel>>> getMyRedemptions();
  Future<Either<String, String>> redeemReward(String rewardId);
  Future<Either<String, int>> getCustomerPoints();
  Future<Either<String, CustomerPointsModel>> getCustomerPointsSummary();
  Future<Either<String, List<RewardsLeaderboardModel>>> getLeaderboard();
}
