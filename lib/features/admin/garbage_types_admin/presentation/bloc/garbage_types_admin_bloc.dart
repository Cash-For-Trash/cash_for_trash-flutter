import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/garbage_types_admin_repository.dart';
import 'garbage_types_admin_event.dart';
import 'garbage_types_admin_state.dart';
export 'garbage_types_admin_state.dart';

class GarbageTypesAdminBloc
    extends Bloc<GarbageTypesAdminEvent, GarbageTypesAdminState> {
  final GarbageTypesAdminRepository repository;

  GarbageTypesAdminBloc({required this.repository})
    : super(GarbageTypesAdminInitialState()) {
    on<GetGarbageTypesAdminEvent>(_onGetGarbageTypes);
    on<CreateGarbageTypeAdminEvent>(_onCreateGarbageType);
    on<UpdateGarbageTypeAdminEvent>(_onUpdateGarbageType);
    on<DeleteGarbageTypeAdminEvent>(_onDeleteGarbageType);
  }

  Future<void> _onGetGarbageTypes(
    GetGarbageTypesAdminEvent event,
    Emitter<GarbageTypesAdminState> emit,
  ) async {
    emit(GarbageTypesAdminLoadingState());
    final result = await repository.getGarbageTypes();
    result.fold(
      (error) => emit(GarbageTypesAdminErrorState(error)),
      (types) => emit(GarbageTypesAdminLoadedState(garbageTypes: types)),
    );
  }

  Future<void> _onCreateGarbageType(
    CreateGarbageTypeAdminEvent event,
    Emitter<GarbageTypesAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is GarbageTypesAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.createGarbageType(
      event.fields,
      event.imagePath,
    );
    result.fold(
      (error) => emit(GarbageTypesAdminErrorState(error)),
      (_) => add(const GetGarbageTypesAdminEvent()),
    );
  }

  Future<void> _onUpdateGarbageType(
    UpdateGarbageTypeAdminEvent event,
    Emitter<GarbageTypesAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is GarbageTypesAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.updateGarbageType(
      event.id,
      event.fields,
      event.imagePath,
    );
    result.fold(
      (error) => emit(GarbageTypesAdminErrorState(error)),
      (_) => add(const GetGarbageTypesAdminEvent()),
    );
  }

  Future<void> _onDeleteGarbageType(
    DeleteGarbageTypeAdminEvent event,
    Emitter<GarbageTypesAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is GarbageTypesAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.deleteGarbageType(event.id);
    result.fold(
      (error) => emit(GarbageTypesAdminErrorState(error)),
      (_) => add(const GetGarbageTypesAdminEvent()),
    );
  }
}
