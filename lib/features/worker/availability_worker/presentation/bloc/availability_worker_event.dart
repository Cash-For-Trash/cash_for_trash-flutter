import 'package:cash_for_trash/features/worker/availability_worker/data/model/availability_worker_model.dart';
import 'package:equatable/equatable.dart';

abstract class AvailabilityWorkerEvent extends Equatable {
  const AvailabilityWorkerEvent();

  @override
  List<Object?> get props => [];
}

class GetMyAvailabilitiesEvent extends AvailabilityWorkerEvent {
  const GetMyAvailabilitiesEvent();
}

class CreateAvailabilityEvent extends AvailabilityWorkerEvent {
  final AvailabilityWorkerModel availability;

  const CreateAvailabilityEvent(this.availability);

  @override
  List<Object?> get props => [availability];
}

class UpdateAvailabilityEvent extends AvailabilityWorkerEvent {
  final String id;
  final AvailabilityWorkerModel availability;

  const UpdateAvailabilityEvent({
    required this.id,
    required this.availability,
  });

  @override
  List<Object?> get props => [id, availability];
}
