import 'package:cash_for_trash/features/worker/earnings_worker/data/model/earnings_worker_model.dart';
import 'package:equatable/equatable.dart';

abstract class EarningsWorkerState extends Equatable {
  const EarningsWorkerState();

  @override
  List<Object?> get props => [];
}

class EarningsWorkerInitialState extends EarningsWorkerState {}

class EarningsWorkerLoadingState extends EarningsWorkerState {}

class EarningsWorkerLoadedState extends EarningsWorkerState {
  final EarningsWorkerModel data;

  const EarningsWorkerLoadedState(this.data);

  @override
  List<Object?> get props => [data];
}

class EarningsWorkerErrorState extends EarningsWorkerState {
  final String errorMessage;

  const EarningsWorkerErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
