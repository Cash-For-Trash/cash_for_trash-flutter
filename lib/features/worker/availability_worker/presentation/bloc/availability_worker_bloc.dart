import 'package:cash_for_trash/features/worker/availability_worker/domain/repository/availability_worker_repository.dart';
import 'package:cash_for_trash/features/worker/availability_worker/presentation/bloc/availability_worker_event.dart';
import 'package:cash_for_trash/features/worker/availability_worker/presentation/bloc/availability_worker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvailabilityWorkerBloc extends Bloc<AvailabilityWorkerEvent, AvailabilityWorkerState> {
  final AvailabilityWorkerRepository repository;

  AvailabilityWorkerBloc({required this.repository})
      : super(AvailabilityWorkerInitialState()) {
    on<GetMyAvailabilitiesEvent>(_onGetMyAvailabilities);
    on<CreateAvailabilityEvent>(_onCreateAvailability);
    on<UpdateAvailabilityEvent>(_onUpdateAvailability);
  }

  Future<void> _onGetMyAvailabilities(
    GetMyAvailabilitiesEvent event,
    Emitter<AvailabilityWorkerState> emit,
  ) async {
    emit(AvailabilityWorkerLoadingState());
    final availRes = await repository.getMyAvailabilities();
    final areasRes = await repository.getServiceAreas();

    availRes.fold(
      (error) => emit(AvailabilityWorkerErrorState(error)),
      (availabilities) {
        final areas = areasRes.fold((_) => <Map<String, dynamic>>[], (a) => a);
        emit(AvailabilityWorkerLoadedState(
          availabilities: availabilities,
          areas: areas,
        ));
      },
    );
  }

  Future<void> _onCreateAvailability(
    CreateAvailabilityEvent event,
    Emitter<AvailabilityWorkerState> emit,
  ) async {
    emit(AvailabilityWorkerLoadingState());
    final result = await repository.createAvailability(event.availability);
    result.fold(
      (error) => emit(AvailabilityWorkerErrorState(error)),
      (_) => emit(const AvailabilityWorkerActionSuccessState('Slot created successfully')),
    );
  }

  Future<void> _onUpdateAvailability(
    UpdateAvailabilityEvent event,
    Emitter<AvailabilityWorkerState> emit,
  ) async {
    emit(AvailabilityWorkerLoadingState());
    final result = await repository.updateAvailability(event.id, event.availability);
    result.fold(
      (error) => emit(AvailabilityWorkerErrorState(error)),
      (_) => emit(const AvailabilityWorkerActionSuccessState('Slot updated successfully')),
    );
  }
}
