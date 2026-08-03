import 'package:equatable/equatable.dart';
import '../../data/model/reward_admin_model.dart';

abstract class RewardsAdminState extends Equatable {
  const RewardsAdminState();

  @override
  List<Object?> get props => [];
}

class RewardsAdminInitialState extends RewardsAdminState {}

class RewardsAdminLoadingState extends RewardsAdminState {}

class RewardsAdminLoadedState extends RewardsAdminState {
  final List<RewardAdminModel> rewards;
  final bool isActionLoading;
  final String? successMessage;

  const RewardsAdminLoadedState({
    required this.rewards,
    this.isActionLoading = false,
    this.successMessage,
  });

  RewardsAdminLoadedState copyWith({
    List<RewardAdminModel>? rewards,
    bool? isActionLoading,
    String? successMessage,
  }) {
    return RewardsAdminLoadedState(
      rewards: rewards ?? this.rewards,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [rewards, isActionLoading, successMessage];
}

class RewardsAdminErrorState extends RewardsAdminState {
  final String errorMessage;

  const RewardsAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
