import 'package:dartz/dartz.dart';
import '../../data/model/reward_model.dart';

abstract class RewardsRepository {
  Future<Either<String, List<RewardModel>>> getRewards();
}
