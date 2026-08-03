import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/rewards_admin_repository.dart';
import 'rewards_admin_event.dart';
import 'rewards_admin_state.dart';

class RewardsAdminBloc extends Bloc<RewardsAdminEvent, RewardsAdminState> {
  final RewardsAdminRepository repository;

  RewardsAdminBloc({required this.repository})
      : super(RewardsAdminInitialState()) {
    on<GetRewardsAdminEvent>(_onGetRewards);
    on<CreateRewardAdminEvent>(_onCreateReward);
    on<UpdateRewardAdminEvent>(_onUpdateReward);
    on<DeleteRewardAdminEvent>(_onDeleteReward);
  }

  Future<void> _onGetRewards(
    GetRewardsAdminEvent event,
    Emitter<RewardsAdminState> emit,
  ) async {
    emit(RewardsAdminLoadingState());
    final result = await repository.getRewards();
    result.fold(
      (error) => emit(RewardsAdminErrorState(error)),
      (rewards) => emit(RewardsAdminLoadedState(rewards: rewards)),
    );
  }

  Future<void> _onCreateReward(
    CreateRewardAdminEvent event,
    Emitter<RewardsAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is RewardsAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.createReward(event.formData);
    result.fold(
      (error) => emit(RewardsAdminErrorState(error)),
      (_) => add(const GetRewardsAdminEvent()),
    );
  }

  Future<void> _onUpdateReward(
    UpdateRewardAdminEvent event,
    Emitter<RewardsAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is RewardsAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.updateReward(event.id, event.formData);
    result.fold(
      (error) => emit(RewardsAdminErrorState(error)),
      (_) => add(const GetRewardsAdminEvent()),
    );
  }

  Future<void> _onDeleteReward(
    DeleteRewardAdminEvent event,
    Emitter<RewardsAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is RewardsAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.deleteReward(event.id);
    result.fold(
      (error) => emit(RewardsAdminErrorState(error)),
      (_) => add(const GetRewardsAdminEvent()),
    );
  }
}
