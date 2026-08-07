part of 'rewards_bloc.dart';

class RewardsState extends Equatable {
  final bool isRewardsLoading;
  final List<RewardModel> rewards;
  final String? rewardsErrorMessage;

  final bool isRedemptionsLoading;
  final List<RedemptionModel> redemptions;
  final String? redemptionsErrorMessage;

  final bool isRedeeming;
  final String? redeemSuccessMessage;
  final String? redeemErrorMessage;

  final bool isCustomerPointsLoading;
  final int customerPoints;
  final String? customerPointsErrorMessage;

  const RewardsState({
    this.isRewardsLoading = false,
    this.rewards = const [],
    this.rewardsErrorMessage,
    this.isRedemptionsLoading = false,
    this.redemptions = const [],
    this.redemptionsErrorMessage,
    this.isRedeeming = false,
    this.redeemSuccessMessage,
    this.redeemErrorMessage,
    this.isCustomerPointsLoading = false,
    this.customerPoints = 0,
    this.customerPointsErrorMessage,
  });

  RewardsState copyWith({
    bool? isRewardsLoading,
    List<RewardModel>? rewards,
    String? rewardsErrorMessage,
    bool clearRewardsError = false,
    bool? isRedemptionsLoading,
    List<RedemptionModel>? redemptions,
    String? redemptionsErrorMessage,
    bool clearRedemptionsError = false,
    bool? isRedeeming,
    String? redeemSuccessMessage,
    bool clearRedeemSuccess = false,
    String? redeemErrorMessage,
    bool clearRedeemError = false,
    bool? isCustomerPointsLoading,
    int? customerPoints,
    String? customerPointsErrorMessage,
    bool clearCustomerPointsError = false,
  }) {
    return RewardsState(
      isRewardsLoading: isRewardsLoading ?? this.isRewardsLoading,
      rewards: rewards ?? this.rewards,
      rewardsErrorMessage: clearRewardsError
          ? null
          : (rewardsErrorMessage ?? this.rewardsErrorMessage),
      isRedemptionsLoading: isRedemptionsLoading ?? this.isRedemptionsLoading,
      redemptions: redemptions ?? this.redemptions,
      redemptionsErrorMessage: clearRedemptionsError
          ? null
          : (redemptionsErrorMessage ?? this.redemptionsErrorMessage),
      isRedeeming: isRedeeming ?? this.isRedeeming,
      redeemSuccessMessage: clearRedeemSuccess
          ? null
          : (redeemSuccessMessage ?? this.redeemSuccessMessage),
      redeemErrorMessage: clearRedeemError
          ? null
          : (redeemErrorMessage ?? this.redeemErrorMessage),
      isCustomerPointsLoading:
          isCustomerPointsLoading ?? this.isCustomerPointsLoading,
      customerPoints: customerPoints ?? this.customerPoints,
      customerPointsErrorMessage: clearCustomerPointsError
          ? null
          : (customerPointsErrorMessage ?? this.customerPointsErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        isRewardsLoading,
        rewards,
        rewardsErrorMessage,
        isRedemptionsLoading,
        redemptions,
        redemptionsErrorMessage,
        isRedeeming,
        redeemSuccessMessage,
        redeemErrorMessage,
        isCustomerPointsLoading,
        customerPoints,
        customerPointsErrorMessage,
      ];
}
