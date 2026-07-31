import 'package:cash_for_trash/features/worker/home_worker/domain/repository/home_worker_repository.dart';
import 'package:cash_for_trash/features/worker/home_worker/presentation/bloc/home_worker_event.dart';
import 'package:cash_for_trash/features/worker/home_worker/presentation/bloc/home_worker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWorkerBloc extends Bloc<HomeWorkerEvent, HomeWorkerState> {
  final HomeWorkerRepository repository;

  HomeWorkerBloc({required this.repository}) : super(HomeWorkerInitialState()) {
    on<GetHomeWorkerDataEvent>(_onGetHomeWorkerData);
  }

  Future<void> _onGetHomeWorkerData(
    GetHomeWorkerDataEvent event,
    Emitter<HomeWorkerState> emit,
  ) async {
    emit(HomeWorkerLoadingState());
    final result = await repository.getHomeWorkerData();
    result.fold(
      (error) => emit(HomeWorkerErrorState(error)),
      (data) => emit(HomeWorkerLoadedState(data)),
    );
  }
}
