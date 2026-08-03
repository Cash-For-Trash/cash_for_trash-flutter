import 'package:cash_for_trash/features/worker/home_worker/data/model/home_worker_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeWorkerState extends Equatable {
  const HomeWorkerState();

  @override
  List<Object?> get props => [];
}

class HomeWorkerInitialState extends HomeWorkerState {}

class HomeWorkerLoadingState extends HomeWorkerState {}

class HomeWorkerLoadedState extends HomeWorkerState {
  final HomeWorkerModel data;

  const HomeWorkerLoadedState(this.data);

  @override
  List<Object?> get props => [data];
}

class HomeWorkerErrorState extends HomeWorkerState {
  final String errorMessage;

  const HomeWorkerErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
