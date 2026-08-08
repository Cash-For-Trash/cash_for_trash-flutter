import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/availabilities_admin_repository.dart';
import 'availabilities_admin_event.dart';
import 'availabilities_admin_state.dart';
export 'availabilities_admin_state.dart';

class AvailabilitiesAdminBloc
    extends Bloc<AvailabilitiesAdminEvent, AvailabilitiesAdminState> {
  final AvailabilitiesAdminRepository repository;

  AvailabilitiesAdminBloc({required this.repository})
      : super(AvailabilitiesAdminInitialState()) {
    on<GetAvailabilitiesAdminEvent>(_onGetAvailabilities);
    on<CreateAvailabilityAdminEvent>(_onCreateAvailability);
    on<DeleteAvailabilityAdminEvent>(_onDeleteAvailability);
  }

  Future<void> _onGetAvailabilities(
    GetAvailabilitiesAdminEvent event,
    Emitter<AvailabilitiesAdminState> emit,
  ) async {
    emit(AvailabilitiesAdminLoadingState());
    final result = await repository.getAvailabilities();
    result.fold(
      (error) => emit(AvailabilitiesAdminErrorState(error)),
      (data) => emit(AvailabilitiesAdminLoadedState(availabilities: data)),
    );
  }

  Future<void> _onCreateAvailability(
    CreateAvailabilityAdminEvent event,
    Emitter<AvailabilitiesAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is AvailabilitiesAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.createAvailability(event.data);
    result.fold(
      (error) => emit(AvailabilitiesAdminErrorState(error)),
      (_) => add(const GetAvailabilitiesAdminEvent()),
    );
  }

  Future<void> _onDeleteAvailability(
    DeleteAvailabilityAdminEvent event,
    Emitter<AvailabilitiesAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is AvailabilitiesAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.deleteAvailability(event.id);
    result.fold(
      (error) => emit(AvailabilitiesAdminErrorState(error)),
      (_) => add(const GetAvailabilitiesAdminEvent()),
    );
  }
}
