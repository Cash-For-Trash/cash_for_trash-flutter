part of 'rewards_bloc.dart';

abstract class RewardsEvent extends Equatable {
  const RewardsEvent();

  @override
  List<Object?> get props => [];
}

class GetRewardsEvent extends RewardsEvent {
  const GetRewardsEvent();
}

class GetMyRedemptionsEvent extends RewardsEvent {
  const GetMyRedemptionsEvent();
}

class RedeemRewardEvent extends RewardsEvent {
  final String rewardId;

  const RedeemRewardEvent(this.rewardId);

  @override
  List<Object?> get props => [rewardId];
}

class ClearRedeemStatusEvent extends RewardsEvent {
  const ClearRedeemStatusEvent();
}

class GetCustomerPointsEvent extends RewardsEvent {
  const GetCustomerPointsEvent();
}
