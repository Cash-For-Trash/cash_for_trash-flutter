import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/redemption_model.dart';
import '../../data/model/reward_model.dart';
import '../../domain/repository/rewards_repository.dart';

part 'rewards_event.dart';
part 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final RewardsRepository repository;

  RewardsBloc({required this.repository}) : super(const RewardsState()) {
    on<GetRewardsEvent>(_onGetRewards);
    on<GetMyRedemptionsEvent>(_onGetMyRedemptions);
    on<RedeemRewardEvent>(_onRedeemReward);
    on<ClearRedeemStatusEvent>(_onClearRedeemStatus);
    on<GetCustomerPointsEvent>(_onGetCustomerPoints);
  }

  Future<void> _onGetRewards(
    GetRewardsEvent event,
    Emitter<RewardsState> emit,
  ) async {
    emit(state.copyWith(isRewardsLoading: true, clearRewardsError: true));
    final result = await repository.getRewards();
    result.fold(
      (error) => emit(state.copyWith(
        isRewardsLoading: false,
        rewardsErrorMessage: error,
      )),
      (rewards) => emit(state.copyWith(
        isRewardsLoading: false,
        rewards: rewards,
      )),
    );
  }

  Future<void> _onGetMyRedemptions(
    GetMyRedemptionsEvent event,
    Emitter<RewardsState> emit,
  ) async {
    emit(state.copyWith(isRedemptionsLoading: true, clearRedemptionsError: true));
    final result = await repository.getMyRedemptions();
    result.fold(
      (error) => emit(state.copyWith(
        isRedemptionsLoading: false,
        redemptionsErrorMessage: error,
      )),
      (redemptions) => emit(state.copyWith(
        isRedemptionsLoading: false,
        redemptions: redemptions,
      )),
    );
  }

  Future<void> _onRedeemReward(
    RedeemRewardEvent event,
    Emitter<RewardsState> emit,
  ) async {
    emit(state.copyWith(
      isRedeeming: true,
      clearRedeemSuccess: true,
      clearRedeemError: true,
    ));
    final result = await repository.redeemReward(event.rewardId);
    result.fold(
      (error) => emit(state.copyWith(
        isRedeeming: false,
        redeemErrorMessage: error,
      )),
      (message) {
        emit(state.copyWith(
          isRedeeming: false,
          redeemSuccessMessage: message,
        ));
        add(const GetCustomerPointsEvent());
      },
    );
  }

  void _onClearRedeemStatus(
    ClearRedeemStatusEvent event,
    Emitter<RewardsState> emit,
  ) {
    emit(state.copyWith(
      clearRedeemSuccess: true,
      clearRedeemError: true,
    ));
  }

  Future<void> _onGetCustomerPoints(
    GetCustomerPointsEvent event,
    Emitter<RewardsState> emit,
  ) async {
    emit(state.copyWith(isCustomerPointsLoading: true, clearCustomerPointsError: true));
    final result = await repository.getCustomerPoints();
    result.fold(
      (error) => emit(state.copyWith(
        isCustomerPointsLoading: false,
        customerPointsErrorMessage: error,
      )),
      (points) => emit(state.copyWith(
        isCustomerPointsLoading: false,
        customerPoints: points,
      )),
    );
  }
}
