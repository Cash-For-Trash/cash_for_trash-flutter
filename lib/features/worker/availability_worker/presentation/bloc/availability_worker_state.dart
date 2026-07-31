import 'package:cash_for_trash/features/worker/availability_worker/data/model/availability_worker_model.dart';
import 'package:equatable/equatable.dart';

abstract class AvailabilityWorkerState extends Equatable {
  const AvailabilityWorkerState();

  @override
  List<Object?> get props => [];
}

class AvailabilityWorkerInitialState extends AvailabilityWorkerState {}

class AvailabilityWorkerLoadingState extends AvailabilityWorkerState {}

class AvailabilityWorkerLoadedState extends AvailabilityWorkerState {
  final List<AvailabilityWorkerModel> availabilities;
  final List<Map<String, dynamic>> areas;

  const AvailabilityWorkerLoadedState({
    required this.availabilities,
    required this.areas,
  });

  @override
  List<Object?> get props => [availabilities, areas];
}

class AvailabilityWorkerActionSuccessState extends AvailabilityWorkerState {
  final String message;

  const AvailabilityWorkerActionSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class AvailabilityWorkerErrorState extends AvailabilityWorkerState {
  final String errorMessage;

  const AvailabilityWorkerErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
