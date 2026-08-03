import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/reward_model.dart';
import '../../domain/repository/rewards_repository.dart';

part 'rewards_event.dart';
part 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final RewardsRepository repository;

  RewardsBloc({required this.repository}) : super(RewardsInitial()) {
    on<GetRewardsEvent>(_onGetRewards);
  }

  Future<void> _onGetRewards(
    GetRewardsEvent event,
    Emitter<RewardsState> emit,
  ) async {
    emit(RewardsLoading());
    final result = await repository.getRewards();
    result.fold(
      (error) => emit(RewardsError(error)),
      (rewards) => emit(RewardsLoaded(rewards)),
    );
  }
}
