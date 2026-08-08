import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/areas_admin_repository.dart';
import 'areas_admin_event.dart';
import 'areas_admin_state.dart';
export 'areas_admin_state.dart';

class AreasAdminBloc extends Bloc<AreasAdminEvent, AreasAdminState> {
  final AreasAdminRepository repository;

  AreasAdminBloc({required this.repository})
      : super(AreasAdminInitialState()) {
    on<GetAreasAdminEvent>(_onGetAreas);
    on<CreateAreaAdminEvent>(_onCreateArea);
    on<UpdateAreaAdminEvent>(_onUpdateArea);
    on<DeleteAreaAdminEvent>(_onDeleteArea);
    on<UpdateAreaPriceAdminEvent>(_onUpdateAreaPrice);
  }

  Future<void> _onGetAreas(
    GetAreasAdminEvent event,
    Emitter<AreasAdminState> emit,
  ) async {
    emit(AreasAdminLoadingState());
    final result = await repository.getAreas();
    result.fold(
      (error) => emit(AreasAdminErrorState(error)),
      (areas) => emit(AreasAdminLoadedState(areas: areas)),
    );
  }

  Future<void> _onCreateArea(
    CreateAreaAdminEvent event,
    Emitter<AreasAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is AreasAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    } else {
      emit(AreasAdminLoadingState());
    }

    final result = await repository.createArea(event.data);
    result.fold(
      (error) => emit(AreasAdminErrorState(error)),
      (_) => add(const GetAreasAdminEvent()),
    );
  }

  Future<void> _onUpdateArea(
    UpdateAreaAdminEvent event,
    Emitter<AreasAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is AreasAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.updateArea(event.id, event.data);
    result.fold(
      (error) => emit(AreasAdminErrorState(error)),
      (_) => add(const GetAreasAdminEvent()),
    );
  }

  Future<void> _onDeleteArea(
    DeleteAreaAdminEvent event,
    Emitter<AreasAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is AreasAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.deleteArea(event.id);
    result.fold(
      (error) => emit(AreasAdminErrorState(error)),
      (_) => add(const GetAreasAdminEvent()),
    );
  }

  Future<void> _onUpdateAreaPrice(
    UpdateAreaPriceAdminEvent event,
    Emitter<AreasAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is AreasAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.updateAreaPrice(event.id, event.price);
    result.fold(
      (error) => emit(AreasAdminErrorState(error)),
      (_) => add(const GetAreasAdminEvent()),
    );
  }
}
